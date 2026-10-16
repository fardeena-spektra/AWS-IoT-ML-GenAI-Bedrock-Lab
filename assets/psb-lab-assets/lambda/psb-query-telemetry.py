"""
PSB Academy CloudLab - telemetry query API.

Two responsibilities:
  * HTTP entry point behind API Gateway  (GET /telemetry, GET /anomalies)
  * Direct invocation as a tool by the Bedrock assistant (Lab 08)
"""
import csv
import io
import json
import os
import urllib.parse
import urllib.request

import boto3

INFLUX_URL = os.environ["INFLUX_URL"]
INFLUX_ORG = os.environ["INFLUX_ORG"]
INFLUX_BUCKET = os.environ["INFLUX_BUCKET"]
SECRET_ID = os.environ["INFLUX_SECRET_ID"]

ALLOWED_METRICS = {
    "temperature_c", "humidity_pct", "co2_ppm",
    "vibration_g", "anomaly_score",
}
ALLOWED_LOCATIONS = {"north-lab", "south-lab", "server-room"}

_sm = boto3.client("secretsmanager")
_token_cache = None


def _token():
    global _token_cache
    if _token_cache is None:
        secret = _sm.get_secret_value(SecretId=SECRET_ID)["SecretString"]
        _token_cache = json.loads(secret)["token"]
    return _token_cache


def _flux(metric, minutes, every, location):
    """Build a Flux query. Inputs are allow-listed by the caller."""
    location_filter = ""
    if location:
        location_filter = (
            f'\n  |> filter(fn: (r) => r["location"] == "{location}")'
        )
    return f'''
from(bucket: "{INFLUX_BUCKET}")
  |> range(start: -{minutes}m)
  |> filter(fn: (r) => r["_measurement"] == "reading")
  |> filter(fn: (r) => r["_field"] == "{metric}"){location_filter}
  |> aggregateWindow(every: {every}, fn: mean, createEmpty: false)
  |> keep(columns: ["_time", "_value", "location"])
  |> sort(columns: ["_time"])
'''.strip()


def _parse_annotated_csv(body):
    """
    InfluxDB /api/v2/query returns ANNOTATED CSV: each result table is
    preceded by #datatype / #group / #default comment lines and its own
    header row. A plain csv.DictReader would read the first comment line
    as the header and silently return nothing, so parse it explicitly.
    """
    rows, header = [], None
    for line in body.splitlines():
        if not line.strip() or line.lstrip().startswith("#"):
            continue                       # annotation or blank line
        fields = next(csv.reader([line]))
        if "_time" in fields or "result" in fields:
            header = fields                # a new table's header row
            continue
        if header:
            rows.append(dict(zip(header, fields)))
    return rows


def _run_flux(query):
    url = f"{INFLUX_URL}/api/v2/query?org={urllib.parse.quote(INFLUX_ORG)}"
    request = urllib.request.Request(
        url=url,
        data=query.encode("utf-8"),
        method="POST",
        headers={
            "Authorization": f"Token {_token()}",
            "Content-Type": "application/vnd.flux",
            "Accept": "application/csv",
        },
    )
    with urllib.request.urlopen(request, timeout=12) as response:
        body = response.read().decode("utf-8")

    points = []
    for row in _parse_annotated_csv(body):
        if not row.get("_time"):
            continue
        try:
            value = float(row["_value"])
        except (TypeError, ValueError):
            continue
        points.append({
            "time": row["_time"],
            "location": row.get("location") or "all",
            "value": round(value, 4),
        })
    return points


def query_metric(metric="temperature_c", window_minutes=60,
                 location=None, bucket_seconds=60):
    """Core logic. Called by the HTTP handler and by the Lab 08 tool."""
    if metric not in ALLOWED_METRICS:
        raise ValueError(
            f"metric must be one of {sorted(ALLOWED_METRICS)}")
    if location and location not in ALLOWED_LOCATIONS:
        raise ValueError(
            f"location must be one of {sorted(ALLOWED_LOCATIONS)}")
    window_minutes = max(1, min(int(window_minutes), 1440))
    bucket_seconds = max(10, min(int(bucket_seconds), 3600))

    points = _run_flux(
        _flux(metric, window_minutes, f"{bucket_seconds}s", location))
    values = [p["value"] for p in points]
    summary = {
        "metric": metric,
        "location": location or "all",
        "window_minutes": window_minutes,
        "point_count": len(values),
        "min": round(min(values), 4) if values else None,
        "max": round(max(values), 4) if values else None,
        "mean": round(sum(values) / len(values), 4) if values else None,
        "latest": values[-1] if values else None,
    }
    return {"summary": summary, "points": points}


def _response(status, body):
    return {
        "statusCode": status,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
        "body": json.dumps(body),
    }


def lambda_handler(event, context):
    # Direct invocation (Lab 08 assistant tool) - no HTTP envelope.
    if "requestContext" not in event:
        try:
            return query_metric(**event)
        except ValueError as err:
            return {"error": str(err)}

    params = event.get("queryStringParameters") or {}
    path = event.get("rawPath", "/telemetry")
    metric = params.get("metric",
                        "anomaly_score" if path.endswith("/anomalies")
                        else "temperature_c")
    try:
        result = query_metric(
            metric=metric,
            window_minutes=params.get("window_minutes", 60),
            location=params.get("location"),
            bucket_seconds=params.get("bucket_seconds", 60),
        )
    except ValueError as err:
        return _response(400, {"error": str(err)})
    except Exception as err:                      # noqa: BLE001
        print(f"[error] {type(err).__name__}: {err}")
        return _response(502, {"error": "upstream query failed"})

    return _response(200, result)
