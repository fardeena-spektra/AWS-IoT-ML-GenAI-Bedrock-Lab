"""
PSB Academy CloudLab - scheduled anomaly scoring.

Every 5 minutes:
  1. read the most recent readings from Timestream for InfluxDB
  2. score them against the SageMaker serverless endpoint
  3. write the anomaly_score back into the same InfluxDB bucket
  4. append the scored rows to s3://<bucket>/curated/scored/
"""
import csv
import io
import json
import os
import time
import urllib.request
from collections import defaultdict

import boto3

INFLUX_URL = os.environ["INFLUX_URL"]
INFLUX_ORG = os.environ["INFLUX_ORG"]
INFLUX_BUCKET = os.environ["INFLUX_BUCKET"]
SECRET_ID = os.environ["INFLUX_SECRET_ID"]
ENDPOINT_NAME = os.environ["SAGEMAKER_ENDPOINT"]
S3_BUCKET = os.environ["S3_BUCKET"]
CUTOFF = float(os.environ.get("ANOMALY_CUTOFF", "1.5"))
WINDOW_MINUTES = int(os.environ.get("WINDOW_MINUTES", "6"))

FEATURES = ["temperature_c", "humidity_pct", "co2_ppm", "vibration_g"]

_sm = boto3.client("secretsmanager")
_runtime = boto3.client("sagemaker-runtime")
_s3 = boto3.client("s3")
_token_cache = None


def _token():
    global _token_cache
    if _token_cache is None:
        secret = _sm.get_secret_value(SecretId=SECRET_ID)["SecretString"]
        _token_cache = json.loads(secret)["token"]
    return _token_cache


def _parse_annotated_csv(body):
    """InfluxDB returns annotated CSV: skip #comment lines, take each
    table's own header row. See Lab 03 for the full explanation."""
    rows, header = [], None
    for line in body.splitlines():
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        fields = next(csv.reader([line]))
        if "_time" in fields or "result" in fields:
            header = fields
            continue
        if header:
            rows.append(dict(zip(header, fields)))
    return rows


def _influx(path, body, content_type, accept=None):
    headers = {"Authorization": f"Token {_token()}",
               "Content-Type": content_type}
    if accept:
        headers["Accept"] = accept
    request = urllib.request.Request(
        url=f"{INFLUX_URL}{path}", data=body.encode("utf-8"),
        method="POST", headers=headers)
    with urllib.request.urlopen(request, timeout=15) as response:
        return response.read().decode("utf-8"), response.status


def read_recent():
    """Pivot the last WINDOW_MINUTES of readings into feature rows."""
    flux = f'''
from(bucket: "{INFLUX_BUCKET}")
  |> range(start: -{WINDOW_MINUTES}m)
  |> filter(fn: (r) => r["_measurement"] == "reading")
  |> filter(fn: (r) => contains(value: r["_field"],
                                set: {json.dumps(FEATURES)}))
  |> pivot(rowKey: ["_time"], columnKey: ["_field"], valueColumn: "_value")
  |> keep(columns: ["_time", "device_id", "location"] + {json.dumps(FEATURES)})
  |> sort(columns: ["_time"])
'''.strip()
    body, _ = _influx(f"/api/v2/query?org={INFLUX_ORG}", flux,
                      "application/vnd.flux", "application/csv")

    rows = []
    for row in _parse_annotated_csv(body):
        if not row.get("_time"):
            continue
        try:
            features = [float(row[f]) for f in FEATURES]
        except (KeyError, TypeError, ValueError):
            continue          # incomplete pivot row - skip it
        rows.append({
            "time": row["_time"],
            "device_id": row.get("device_id", "unknown"),
            "location": row.get("location", "unspecified"),
            "features": features,
        })
    return rows


def score(rows):
    payload = "\n".join(",".join(f"{v:.6f}" for v in r["features"])
                        for r in rows)
    response = _runtime.invoke_endpoint(
        EndpointName=ENDPOINT_NAME,
        ContentType="text/csv",
        Accept="application/json",
        Body=payload.encode("utf-8"),
    )
    body = json.loads(response["Body"].read())
    return [float(s["score"]) for s in body["scores"]]


def write_back(rows, scores):
    """One line-protocol point per reading, same tags, new field."""
    lines = []
    for row, value in zip(rows, scores):
        ts = int(time.mktime(time.strptime(
            row["time"][:19], "%Y-%m-%dT%H:%M:%S")))
        device = row["device_id"].replace(" ", "\\ ")
        location = row["location"].replace(" ", "\\ ")
        lines.append(
            f"reading,device_id={device},location={location} "
            f"anomaly_score={value:.6f} {ts}")
    body = "\n".join(lines)
    _, status = _influx(
        f"/api/v2/write?org={INFLUX_ORG}&bucket={INFLUX_BUCKET}&precision=s",
        body, "text/plain; charset=utf-8")
    return status


def archive(rows, scores):
    buf = io.StringIO()
    writer = csv.writer(buf)
    writer.writerow(["time", "device_id", "location"] + FEATURES
                    + ["anomaly_score", "is_anomaly"])
    for row, value in zip(rows, scores):
        writer.writerow([row["time"], row["device_id"], row["location"]]
                        + [f"{v:.4f}" for v in row["features"]]
                        + [f"{value:.6f}", int(value > CUTOFF)])
    key = time.strftime("curated/scored/%Y/%m/%d/%H%M%S.csv", time.gmtime())
    _s3.put_object(Bucket=S3_BUCKET, Key=key,
                   Body=buf.getvalue().encode("utf-8"))
    return key


def lambda_handler(event, context):
    rows = read_recent()
    if not rows:
        print("[skip] no complete readings in window")
        return {"scored": 0}

    scores = score(rows)
    status = write_back(rows, scores)
    key = archive(rows, scores)

    flagged = sum(1 for s in scores if s > CUTOFF)
    by_location = defaultdict(int)
    for row, value in zip(rows, scores):
        if value > CUTOFF:
            by_location[row["location"]] += 1

    print(f"[ok] scored={len(rows)} flagged={flagged} "
          f"influx={status} s3={key} by_location={dict(by_location)}")
    return {"scored": len(rows), "flagged": flagged, "archive": key}
