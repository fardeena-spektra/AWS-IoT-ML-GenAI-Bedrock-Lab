"""
psb-score-telemetry  (Python 3.13, stdlib + boto3 only)

What this function does (runs every 5 minutes from EventBridge rule psb-lab-score-every-5-min)
--------------------------------------------------------------------------------------------
1. Reads the last WINDOW_MINUTES of raw readings from InfluxDB (measurement
   "telemetry"), pivoting the 4 fields into one row per reading.
2. Sends the rows as text/csv (temperature_c,humidity_pct,co2_ppm,vibration_g)
   to the SageMaker serverless endpoint psb-anomaly-endpoint (Random Cut Forest),
   in batches of 500. RCF answers {"scores":[{"score": x}, ...]}.
3. flagged = score > ANOMALY_CUTOFF (the 98th percentile printed by the notebook).
4. Writes each scored reading back to InfluxDB measurement "anomaly"
   (tags device, location; fields anomaly_score, flagged + the 4 sensor values).
5. Saves the batch as CSV to s3://<S3_BUCKET>/curated/scored/YYYY/MM/DD/HHMMSS.csv.
6. Logs "[ok] scored=<n> flagged=<m>" (also when n=0, which keeps the
   CloudWatch metric filter psb-lab-anomaly-batches fed) and returns
   {"scored": n, "flagged": m}.

Environment variables
---------------------
INFLUX_URL, INFLUX_ORG, INFLUX_BUCKET, INFLUX_SECRET_ID   (same as the other Lambdas)
SAGEMAKER_ENDPOINT   psb-anomaly-endpoint
S3_BUCKET            psb-lab-<DeploymentID>
ANOMALY_CUTOFF       float printed by notebook cell 10
WINDOW_MINUTES       6
"""

import csv
import io
import json
import os
import urllib.error
import urllib.request
from datetime import datetime, timezone

import boto3

INFLUX_URL = os.environ.get("INFLUX_URL", "").rstrip("/")
INFLUX_ORG = os.environ.get("INFLUX_ORG", "psb")
INFLUX_BUCKET = os.environ.get("INFLUX_BUCKET", "telemetry")
INFLUX_SECRET_ID = os.environ.get("INFLUX_SECRET_ID", "psb/influxdb/admin-token")
SAGEMAKER_ENDPOINT = os.environ.get("SAGEMAKER_ENDPOINT", "psb-anomaly-endpoint")
S3_BUCKET = os.environ.get("S3_BUCKET", "")
ANOMALY_CUTOFF = float(os.environ.get("ANOMALY_CUTOFF", "3.0"))
WINDOW_MINUTES = max(1, min(int(os.environ.get("WINDOW_MINUTES", "6")), 1440))

FEATURES = ("temperature_c", "humidity_pct", "co2_ppm", "vibration_g")
BATCH_SIZE = 500

_token_cache = None
_secrets = None
_sm_runtime = None
_s3 = None


# ---------------------------------------------------------------- InfluxDB helpers
def get_token():
    global _token_cache, _secrets
    if _token_cache is None:
        if _secrets is None:
            _secrets = boto3.client("secretsmanager")
        raw = _secrets.get_secret_value(SecretId=INFLUX_SECRET_ID)["SecretString"]
        try:
            _token_cache = json.loads(raw)["token"]
        except (ValueError, KeyError, TypeError):
            _token_cache = raw.strip()
    return _token_cache


def _convert(value, datatype):
    if value == "" or value is None:
        return None
    if datatype == "double":
        return float(value)
    if datatype in ("long", "unsignedLong"):
        return int(value)
    if datatype == "boolean":
        return value.lower() == "true"
    if datatype and (datatype.startswith("dateTime") or datatype == "string"):
        return value
    try:
        return float(value)
    except ValueError:
        return value


def parse_annotated_csv(text):
    """Parse InfluxDB annotated CSV (multiple tables, '#' rows, repeated headers, blank lines)."""
    rows, header, datatypes = [], None, None
    for record in csv.reader(io.StringIO(text)):
        if not record or all(c.strip() == "" for c in record):
            header, datatypes = None, None
            continue
        if record[0].startswith("#"):
            if record[0] == "#datatype":
                datatypes, header = record, None
            continue
        if header is None:
            header = record
            continue
        if record == header:
            continue
        row = {}
        for i, col in enumerate(header):
            if col in ("", "result", "table") or i >= len(record):
                continue
            row[col] = _convert(record[i], datatypes[i] if datatypes and i < len(datatypes) else None)
        if "error" in header and "_time" not in header:
            raise RuntimeError(f"Flux error: {row.get('error')}")
        rows.append(row)
    return rows


def _influx_request(path, body, content_type, accept=None):
    headers = {"Authorization": f"Token {get_token()}", "Content-Type": content_type}
    if accept:
        headers["Accept"] = accept
    req = urllib.request.Request(f"{INFLUX_URL}{path}", data=body.encode("utf-8"), method="POST", headers=headers)
    try:
        with urllib.request.urlopen(req, timeout=20) as resp:
            return resp.status, resp.read().decode("utf-8")
    except urllib.error.HTTPError as err:
        print(f"[error] InfluxDB {path} failed: HTTP {err.code} {err.read().decode('utf-8', 'replace')}")
        raise


def read_recent_rows():
    field_filter = " or ".join(f'r._field == "{f}"' for f in FEATURES)
    flux = (
        f'from(bucket: "{INFLUX_BUCKET}")\n'
        f'  |> range(start: -{WINDOW_MINUTES}m)\n'
        f'  |> filter(fn: (r) => r._measurement == "telemetry")\n'
        f'  |> filter(fn: (r) => {field_filter})\n'
        f'  |> pivot(rowKey: ["_time"], columnKey: ["_field"], valueColumn: "_value")\n'
        f'  |> group()\n'
        f'  |> sort(columns: ["_time"])'
    )
    body = json.dumps({"query": flux, "type": "flux",
                       "dialect": {"header": True, "annotations": ["datatype", "group", "default"]}})
    _, text = _influx_request(f"/api/v2/query?org={INFLUX_ORG}", body, "application/json", "application/csv")
    rows = parse_annotated_csv(text)
    # Keep only complete readings (all 4 features numeric).
    return [r for r in rows if all(isinstance(r.get(f), (int, float)) for f in FEATURES)]


def rfc3339_to_ms(value):
    """'2026-10-15T09:30:00.123456789Z' -> epoch ms (handles nanosecond fractions)."""
    s = value.strip().replace("Z", "+00:00")
    if "." in s:
        head, rest = s.split(".", 1)
        frac, tz = rest, ""
        for sep in ("+", "-"):
            if sep in rest:
                frac, tz = rest.split(sep, 1)
                tz = sep + tz
                break
        s = f"{head}.{(frac + '000000')[:6]}{tz}"
    dt = datetime.fromisoformat(s)
    if dt.tzinfo is None:
        dt = dt.replace(tzinfo=timezone.utc)
    return int(dt.timestamp() * 1000)


def _escape_tag(value):
    return str(value).replace("\\", "\\\\").replace(",", "\\,").replace("=", "\\=").replace(" ", "\\ ")


def anomaly_line(row, score, flagged):
    fields = [f"anomaly_score={float(score)!r}", f"flagged={'true' if flagged else 'false'}"]
    fields += [f"{f}={float(row[f])!r}" for f in FEATURES]
    tags = f"device={_escape_tag(row.get('device') or 'unknown')},location={_escape_tag(row.get('location') or 'unknown')}"
    return f"anomaly,{tags} {','.join(fields)} {rfc3339_to_ms(row['_time'])}"


# ---------------------------------------------------------------- SageMaker scoring
def score_rows(rows):
    global _sm_runtime
    if _sm_runtime is None:
        _sm_runtime = boto3.client("sagemaker-runtime")
    scores = []
    for i in range(0, len(rows), BATCH_SIZE):
        batch = rows[i:i + BATCH_SIZE]
        payload = "\n".join(",".join(str(float(r[f])) for f in FEATURES) for r in batch)
        resp = _sm_runtime.invoke_endpoint(EndpointName=SAGEMAKER_ENDPOINT, ContentType="text/csv",
                                           Accept="application/json", Body=payload)
        result = json.loads(resp["Body"].read())
        scores.extend(float(s["score"]) for s in result["scores"])
    if len(scores) != len(rows):
        raise RuntimeError(f"endpoint returned {len(scores)} scores for {len(rows)} rows")
    return scores


def write_csv_to_s3(rows, scores, flags, now):
    global _s3
    if _s3 is None:
        _s3 = boto3.client("s3")
    buf = io.StringIO()
    w = csv.writer(buf)
    w.writerow(["time", "device", "location", *FEATURES, "anomaly_score", "flagged"])
    for r, s, fl in zip(rows, scores, flags):
        w.writerow([r["_time"], r.get("device"), r.get("location"), *[r[f] for f in FEATURES], round(s, 6), fl])
    key = now.strftime("curated/scored/%Y/%m/%d/%H%M%S.csv")
    _s3.put_object(Bucket=S3_BUCKET, Key=key, Body=buf.getvalue().encode("utf-8"), ContentType="text/csv")
    return key


def lambda_handler(event, context):
    now = datetime.now(timezone.utc)
    rows = read_recent_rows()
    print(f"[info] window={WINDOW_MINUTES}m rows={len(rows)} endpoint={SAGEMAKER_ENDPOINT} cutoff={ANOMALY_CUTOFF}")
    if not rows:
        print("[ok] scored=0 flagged=0")
        return {"scored": 0, "flagged": 0}

    scores = score_rows(rows)
    flags = [s > ANOMALY_CUTOFF for s in scores]

    lines = "\n".join(anomaly_line(r, s, fl) for r, s, fl in zip(rows, scores, flags))
    status, _ = _influx_request(f"/api/v2/write?org={INFLUX_ORG}&bucket={INFLUX_BUCKET}&precision=ms",
                                lines, "text/plain; charset=utf-8")
    key = write_csv_to_s3(rows, scores, flags, now)
    n, m = len(rows), sum(flags)
    print(f"[info] influx write status={status} s3://{S3_BUCKET}/{key}")
    print(f"[ok] scored={n} flagged={m}")
    return {"scored": n, "flagged": m}
