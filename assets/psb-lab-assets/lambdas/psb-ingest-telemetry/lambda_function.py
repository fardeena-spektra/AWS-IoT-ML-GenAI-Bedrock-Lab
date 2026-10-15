"""
psb-ingest-telemetry  (Python 3.13, stdlib + boto3 only)

What this function does
-----------------------
1. Receives ONE telemetry reading from the AWS IoT rule psb_telemetry_rule
   (the rule's SELECT output, a single JSON object).
2. Converts it to InfluxDB line protocol:
     telemetry,device=<device>,location=<location> temperature_c=..,humidity_pct=..,co2_ppm=..,vibration_g=.. <timestamp-ms>
   (injected_anomaly and ingested_at are NOT written to InfluxDB.)
3. Reads the InfluxDB admin token from Secrets Manager (secret JSON {"token": "..."})
   and caches it in memory so warm invocations do not call Secrets Manager again.
4. POSTs the point to <INFLUX_URL>/api/v2/write?org=..&bucket=..&precision=ms
   with header "Authorization: Token <token>".
5. Logs "[ok] wrote 1 point (204)" and returns {"written": 1, "status": 204}.
   HTTP errors are printed (status + body) and re-raised so the failure is
   visible in CloudWatch Logs and in the Lambda test result.

Environment variables
---------------------
INFLUX_URL        https://<INFLUX-ENDPOINT>:8086
INFLUX_ORG        psb
INFLUX_BUCKET     telemetry
INFLUX_SECRET_ID  psb/influxdb/admin-token
"""

import json
import os
import urllib.error
import urllib.parse
import urllib.request

import boto3

INFLUX_URL = os.environ.get("INFLUX_URL", "").rstrip("/")
INFLUX_ORG = os.environ.get("INFLUX_ORG", "psb")
INFLUX_BUCKET = os.environ.get("INFLUX_BUCKET", "telemetry")
INFLUX_SECRET_ID = os.environ.get("INFLUX_SECRET_ID", "psb/influxdb/admin-token")

MEASUREMENT = "telemetry"
TAG_KEYS = ("device", "location")
FIELD_KEYS = ("temperature_c", "humidity_pct", "co2_ppm", "vibration_g")

_token_cache = None  # survives across warm invocations
_secrets = None


def get_token():
    """Return the InfluxDB token, reading Secrets Manager only on a cold start."""
    global _token_cache, _secrets
    if _token_cache is None:
        if _secrets is None:
            _secrets = boto3.client("secretsmanager")
        raw = _secrets.get_secret_value(SecretId=INFLUX_SECRET_ID)["SecretString"]
        try:
            _token_cache = json.loads(raw)["token"]
        except (ValueError, KeyError, TypeError):
            _token_cache = raw.strip()  # tolerate a plain-text secret
    return _token_cache


def _escape_tag(value):
    """Escape commas, equals signs and spaces in tag keys/values (line protocol rules)."""
    return str(value).replace("\\", "\\\\").replace(",", "\\,").replace("=", "\\=").replace(" ", "\\ ")


def to_line_protocol(reading):
    """Convert one reading dict to a line protocol string (precision ms)."""
    if not isinstance(reading, dict):
        raise ValueError("reading must be a JSON object")
    tags = []
    for k in TAG_KEYS:
        v = reading.get(k)
        if v is None or str(v) == "":
            raise ValueError(f"missing tag '{k}'")
        tags.append(f"{k}={_escape_tag(v)}")
    fields = []
    for k in FIELD_KEYS:
        v = reading.get(k)
        if v is None or isinstance(v, bool):
            continue
        fields.append(f"{k}={float(v)!r}")
    if not fields:
        raise ValueError("reading has no numeric fields")
    ts = reading.get("timestamp")
    if ts is None:
        raise ValueError("missing 'timestamp' (epoch milliseconds)")
    return f"{MEASUREMENT},{','.join(tags)} {','.join(fields)} {int(float(ts))}"


def write_lines(body, token):
    """POST line protocol to InfluxDB; returns the HTTP status (204 on success)."""
    qs = urllib.parse.urlencode({"org": INFLUX_ORG, "bucket": INFLUX_BUCKET, "precision": "ms"})
    req = urllib.request.Request(
        f"{INFLUX_URL}/api/v2/write?{qs}",
        data=body.encode("utf-8"),
        method="POST",
        headers={"Authorization": f"Token {token}", "Content-Type": "text/plain; charset=utf-8"},
    )
    try:
        with urllib.request.urlopen(req, timeout=10) as resp:
            return resp.status
    except urllib.error.HTTPError as err:
        detail = err.read().decode("utf-8", "replace")
        print(f"[error] InfluxDB write failed: HTTP {err.code} {detail}")
        raise


def lambda_handler(event, context):
    # The IoT rule sends the reading itself; tolerate a wrapped {"body": "..."} test event too.
    reading = event
    if isinstance(event, dict) and isinstance(event.get("body"), str):
        reading = json.loads(event["body"])
    line = to_line_protocol(reading)
    status = write_lines(line, get_token())
    print(f"[ok] wrote 1 point ({status})")
    return {"written": 1, "status": status}
