"""
psb-query-telemetry  (Python 3.13, stdlib + boto3 only)

What this function does
-----------------------
Reads sensor data from InfluxDB with a Flux query and returns JSON for the
dashboard (through API Gateway) and for the Bedrock assistant (direct invoke).

* GET /telemetry  -> aggregated values of ONE metric over a time window
    query params: metric (temperature_c | humidity_pct | co2_ppm | vibration_g | anomaly_score,
                  default temperature_c), window_minutes (1..1440, default 30),
                  bucket_seconds (10..3600, default 60), location (optional:
                  north-lab | south-lab | server-room)
    returns {"metric","window_minutes","bucket_seconds","location",
             "points":[{"time","location","value"}],
             "summary":{"count","min","max","mean","latest"}}
* GET /anomalies  -> rows from measurement "anomaly" written by psb-score-telemetry
    returns {"window_minutes","points":[{"time","location","anomaly_score","flagged",...}],
             "flagged_count"}

Security: every input is checked against an allow-list or an integer range
BEFORE it is placed in the Flux query, so a request like ?metric=DROP_TABLE
gets HTTP 400 and nothing user-controlled is ever injected into Flux.

Flux is sent to POST /api/v2/query with "Accept: application/csv"; the
annotated CSV response (several tables, '#' annotation rows, repeated
header rows, blank lines between tables) is parsed with the csv module.

Invocation styles
-----------------
* API Gateway HTTP API (payload v2.0): returns {statusCode, headers (CORS), body}.
* Direct invoke (no requestContext), e.g. from psb-assistant or the Lambda
  console test event: returns the raw dict ({"error": ...} for bad input).

Environment variables: INFLUX_URL, INFLUX_ORG, INFLUX_BUCKET, INFLUX_SECRET_ID
"""

import csv
import io
import json
import os
import urllib.error
import urllib.request

import boto3

INFLUX_URL = os.environ.get("INFLUX_URL", "").rstrip("/")
INFLUX_ORG = os.environ.get("INFLUX_ORG", "psb")
INFLUX_BUCKET = os.environ.get("INFLUX_BUCKET", "telemetry")
INFLUX_SECRET_ID = os.environ.get("INFLUX_SECRET_ID", "psb/influxdb/admin-token")

SENSOR_METRICS = ("temperature_c", "humidity_pct", "co2_ppm", "vibration_g")
METRICS = SENSOR_METRICS + ("anomaly_score",)
LOCATIONS = ("north-lab", "south-lab", "server-room")
WINDOW_RANGE = (1, 1440)
BUCKET_RANGE = (10, 3600)

CORS_HEADERS = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "authorization,content-type",
    "Access-Control-Allow-Methods": "GET,POST,OPTIONS",
}

_token_cache = None
_secrets = None


class BadRequest(ValueError):
    """Input failed validation -> HTTP 400."""


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
    """Convert one CSV cell using the #datatype annotation (or a best guess)."""
    if value == "" or value is None:
        return None
    if datatype == "double":
        return float(value)
    if datatype in ("long", "unsignedLong"):
        return int(value)
    if datatype == "boolean":
        return value.lower() == "true"
    if datatype and datatype.startswith("dateTime"):
        return value
    if datatype == "string":
        return value
    # No annotation: try number, then bool, else keep string.
    try:
        return float(value)
    except ValueError:
        if value.lower() in ("true", "false"):
            return value.lower() == "true"
        return value


def parse_annotated_csv(text):
    """
    Parse InfluxDB annotated CSV into a list of row dicts.
    Handles: multiple tables, '#datatype/#group/#default' annotation rows,
    header rows that repeat for each table, blank separator lines, and
    error tables (header 'error,reference') which raise RuntimeError.
    """
    rows = []
    header = None
    datatypes = None
    for record in csv.reader(io.StringIO(text)):
        if not record or all(c.strip() == "" for c in record):
            header, datatypes = None, None  # blank line = next table
            continue
        first = record[0]
        if first.startswith("#"):
            if first == "#datatype":
                datatypes = record
                header = None  # a new annotation block precedes a new header
            continue
        if header is None:
            header = record
            continue
        if record == header:
            continue  # repeated header row
        row = {}
        for i, col in enumerate(header):
            if col in ("", "result", "table") or i >= len(record):
                continue
            dt = datatypes[i] if datatypes and i < len(datatypes) else None
            row[col] = _convert(record[i], dt)
        if "error" in header and "_time" not in header:
            raise RuntimeError(f"Flux error: {row.get('error')}")
        rows.append(row)
    return rows


def run_flux(flux):
    body = json.dumps({
        "query": flux,
        "type": "flux",
        "dialect": {"header": True, "delimiter": ",", "annotations": ["datatype", "group", "default"]},
    }).encode("utf-8")
    req = urllib.request.Request(
        f"{INFLUX_URL}/api/v2/query?org={INFLUX_ORG}",
        data=body,
        method="POST",
        headers={
            "Authorization": f"Token {get_token()}",
            "Content-Type": "application/json",
            "Accept": "application/csv",
        },
    )
    try:
        with urllib.request.urlopen(req, timeout=20) as resp:
            return parse_annotated_csv(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as err:
        print(f"[error] InfluxDB query failed: HTTP {err.code} {err.read().decode('utf-8', 'replace')}")
        raise


# ---------------------------------------------------------------- input validation
def _int_param(params, name, default, lo, hi):
    raw = params.get(name)
    if raw is None or str(raw).strip() == "":
        return default
    try:
        val = int(str(raw).strip())
    except ValueError:
        raise BadRequest(f"{name} must be an integer between {lo} and {hi}")
    if not lo <= val <= hi:
        raise BadRequest(f"{name} must be between {lo} and {hi}")
    return val


def validate(params, route="telemetry"):
    """Return a clean dict of validated inputs or raise BadRequest."""
    params = params or {}
    metric = str(params.get("metric") or "temperature_c").strip()
    if metric not in METRICS:
        raise BadRequest(f"metric must be one of {', '.join(METRICS)}")
    location = params.get("location")
    location = str(location).strip() if location not in (None, "") else None
    if location is not None and location not in LOCATIONS:
        raise BadRequest(f"location must be one of {', '.join(LOCATIONS)}")
    window = _int_param(params, "window_minutes", 30, *WINDOW_RANGE)
    bucket = _int_param(params, "bucket_seconds", 60, *BUCKET_RANGE)
    return {"metric": metric, "location": location, "window_minutes": window, "bucket_seconds": bucket}


# ---------------------------------------------------------------- queries
def _location_filter(location):
    # location is already allow-listed, so it is safe to embed.
    return f'\n  |> filter(fn: (r) => r.location == "{location}")' if location else ""


def query_telemetry(p):
    measurement = "anomaly" if p["metric"] == "anomaly_score" else "telemetry"
    flux = (
        f'from(bucket: "{INFLUX_BUCKET}")\n'
        f'  |> range(start: -{p["window_minutes"]}m)\n'
        f'  |> filter(fn: (r) => r._measurement == "{measurement}" and r._field == "{p["metric"]}")'
        f'{_location_filter(p["location"])}\n'
        f'  |> aggregateWindow(every: {p["bucket_seconds"]}s, fn: mean, createEmpty: false)\n'
        f'  |> keep(columns: ["_time", "_value", "location"])'
    )
    rows = run_flux(flux)
    points = [
        {"time": r.get("_time"), "location": r.get("location"), "value": round(float(r["_value"]), 4)}
        for r in rows if isinstance(r.get("_value"), (int, float))
    ]
    points.sort(key=lambda x: (x["time"] or "", x["location"] or ""))
    values = [pt["value"] for pt in points]
    summary = {"count": len(values), "min": None, "max": None, "mean": None, "latest": None}
    if values:
        summary.update({
            "min": round(min(values), 4),
            "max": round(max(values), 4),
            "mean": round(sum(values) / len(values), 4),
            "latest": points[-1]["value"],
        })
    return {
        "metric": p["metric"],
        "window_minutes": p["window_minutes"],
        "bucket_seconds": p["bucket_seconds"],
        "location": p["location"],
        "points": points,
        "summary": summary,
    }


def query_anomalies(p):
    flux = (
        f'from(bucket: "{INFLUX_BUCKET}")\n'
        f'  |> range(start: -{p["window_minutes"]}m)\n'
        f'  |> filter(fn: (r) => r._measurement == "anomaly")'
        f'{_location_filter(p["location"])}\n'
        f'  |> pivot(rowKey: ["_time"], columnKey: ["_field"], valueColumn: "_value")\n'
        f'  |> group()\n'
        f'  |> sort(columns: ["_time"])'
    )
    rows = run_flux(flux)
    points = []
    for r in rows:
        score = r.get("anomaly_score")
        if not isinstance(score, (int, float)):
            continue
        pt = {
            "time": r.get("_time"),
            "location": r.get("location"),
            "anomaly_score": round(float(score), 4),
            "flagged": bool(r.get("flagged")),
        }
        for m in SENSOR_METRICS:
            if isinstance(r.get(m), (int, float)):
                pt[m] = r[m]
        points.append(pt)
    return {
        "window_minutes": p["window_minutes"],
        "location": p["location"],
        "points": points,
        "flagged_count": sum(1 for pt in points if pt["flagged"]),
    }


# ---------------------------------------------------------------- handler
def _api_response(status, payload):
    return {"statusCode": status, "headers": CORS_HEADERS, "body": json.dumps(payload)}


def lambda_handler(event, context):
    event = event or {}
    from_api = isinstance(event, dict) and "requestContext" in event
    if from_api:
        params = event.get("queryStringParameters") or {}
        route_key = event.get("routeKey") or ""
        path = event.get("rawPath") or ""
        is_anomalies = route_key.endswith("/anomalies") or path.endswith("/anomalies")
        if (event.get("requestContext", {}).get("http", {}).get("method") == "OPTIONS"):
            return _api_response(204, {})
    else:
        params = event
        is_anomalies = event.get("route") == "anomalies"

    try:
        p = validate(params)
        result = query_anomalies(p) if is_anomalies else query_telemetry(p)
        print(f"[ok] {'anomalies' if is_anomalies else 'telemetry'} metric={p['metric']} "
              f"window={p['window_minutes']}m location={p['location']} points={len(result['points'])}")
        return _api_response(200, result) if from_api else result
    except BadRequest as exc:
        print(f"[bad-request] {exc}")
        err = {"error": str(exc)}
        return _api_response(400, err) if from_api else err
    except Exception as exc:  # InfluxDB / network errors
        print(f"[error] {type(exc).__name__}: {exc}")
        if from_api:
            return _api_response(502, {"error": "query failed, see CloudWatch logs"})
        raise
