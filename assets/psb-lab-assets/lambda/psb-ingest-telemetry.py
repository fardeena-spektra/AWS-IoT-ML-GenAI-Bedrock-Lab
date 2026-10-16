"""
PSB Academy CloudLab - IoT telemetry ingestion.

Invoked by the AWS IoT rule `psb_telemetry_rule` for every inbound
MQTT message. Converts the JSON payload into InfluxDB line protocol
and writes it to Amazon Timestream for InfluxDB.
"""
import json
import os
import time
import urllib.error
import urllib.request

import boto3

INFLUX_URL = os.environ["INFLUX_URL"]          # https://<endpoint>:8086
INFLUX_ORG = os.environ["INFLUX_ORG"]          # psb
INFLUX_BUCKET = os.environ["INFLUX_BUCKET"]    # telemetry
SECRET_ID = os.environ["INFLUX_SECRET_ID"]     # psb/influxdb/admin-token

FIELDS = ("temperature_c", "humidity_pct", "co2_ppm", "vibration_g")

_sm = boto3.client("secretsmanager")
_token_cache = None


def _token():
    """Fetch the InfluxDB token once per execution environment."""
    global _token_cache
    if _token_cache is None:
        secret = _sm.get_secret_value(SecretId=SECRET_ID)["SecretString"]
        _token_cache = json.loads(secret)["token"]
    return _token_cache


def _escape_tag(value):
    """Line protocol tag values escape spaces, commas and equals signs."""
    return (str(value).replace("\\", "\\\\")
                      .replace(" ", "\\ ")
                      .replace(",", "\\,")
                      .replace("=", "\\="))


def _to_line_protocol(msg):
    """
    reading,device_id=psb-lab-sensor-01,location=north-lab
            temperature_c=22.84,humidity_pct=53.11 1789012345
    """
    tags = [
        f"device_id={_escape_tag(msg.get('device_id', 'unknown'))}",
        f"location={_escape_tag(msg.get('location', 'unspecified'))}",
    ]
    fields = []
    for name in FIELDS:
        value = msg.get(name)
        if value is not None:
            fields.append(f"{name}={float(value)}")
    if not fields:
        return None
    ts = int(msg.get("ts") or time.time())
    return f"reading,{','.join(tags)} {','.join(fields)} {ts}"


def lambda_handler(event, context):
    line = _to_line_protocol(event)
    if line is None:
        print(f"[skip] no numeric fields in payload: {json.dumps(event)[:200]}")
        return {"written": 0, "reason": "no-fields"}

    url = (f"{INFLUX_URL}/api/v2/write"
           f"?org={INFLUX_ORG}&bucket={INFLUX_BUCKET}&precision=s")
    request = urllib.request.Request(
        url=url,
        data=line.encode("utf-8"),
        method="POST",
        headers={
            "Authorization": f"Token {_token()}",
            "Content-Type": "text/plain; charset=utf-8",
        },
    )
    try:
        with urllib.request.urlopen(request, timeout=8) as response:
            status = response.status
    except urllib.error.HTTPError as err:
        body = err.read().decode("utf-8", "replace")[:300]
        print(f"[error] InfluxDB returned {err.code}: {body}")
        raise

    print(f"[ok] wrote 1 point ({status}): {line}")
    return {"written": 1, "status": status}
