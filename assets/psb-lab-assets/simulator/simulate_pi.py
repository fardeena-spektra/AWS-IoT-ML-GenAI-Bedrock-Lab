#!/usr/bin/env python3
"""
simulate_pi.py - PSB lab sensor simulator (AWS Demo || Bedrock with Claude)

What it does
------------
Pretends to be a Raspberry Pi sensor hub called psb-lab-sensor-01 and sends
environment readings to AWS IoT Core over MQTT (TLS, port 8883) using the
X.509 certificate from the IoT Core "Connect one device" kit.

* Publishes one JSON reading per --interval seconds (QoS 1) to
      psb/lab/<client-id>/telemetry
  The location cycles north-lab -> south-lab -> server-room.
* Each location has a realistic baseline with a daily cycle and random noise.
  About 2% of readings are injected anomalies (spikes) with
  "injected_anomaly": true so the ML model can be measured later.
* Subscribes to psb/lab/<client-id>/commands and prints any command received.
* --backfill-hours N publishes N hours of HISTORICAL readings (timestamps in
  the past, spaced by --interval) as fast as is safe (~50 msg/s), then exits.
  Used in Lab 06 to give SageMaker enough training data.

Message format:
  {"device":"psb-lab-sensor-01","location":"north-lab","timestamp":1760520000000,
   "temperature_c":22.41,"humidity_pct":45.2,"co2_ppm":612.0,"vibration_g":0.021,
   "injected_anomaly":false}

Usage (from C:\\psb-lab-assets\\simulator):
  pip install -r requirements.txt
  python simulate_pi.py --endpoint <IOT-ENDPOINT> --certs-dir certs --interval 10
  python simulate_pi.py --endpoint <IOT-ENDPOINT> --certs-dir certs --interval 10 --backfill-hours 24

Expected connect output: rc=0 (Connection Accepted.)
rc=5 (not authorised) usually means the certificate is inactive or the
psb-lab-device-policy is not attached to it. Press Ctrl+C to stop.

Requires paho-mqtt==1.6.1.
"""

import argparse
import glob
import json
import math
import os
import random
import ssl
import sys
import threading
import time
from datetime import datetime

try:
    import paho.mqtt.client as mqtt
except ImportError:  # pragma: no cover - friendly message for learners
    print("[error] paho-mqtt is not installed. Run: pip install -r requirements.txt")
    sys.exit(1)

LOCATIONS = ["north-lab", "south-lab", "server-room"]

# Per-location baselines: mean value and daily swing amplitude for each metric.
BASELINES = {
    "north-lab":   {"temperature_c": (22.0, 1.5), "humidity_pct": (45.0, 4.0),
                    "co2_ppm": (600.0, 120.0), "vibration_g": (0.020, 0.004)},
    "south-lab":   {"temperature_c": (24.0, 2.0), "humidity_pct": (52.0, 5.0),
                    "co2_ppm": (700.0, 150.0), "vibration_g": (0.025, 0.005)},
    "server-room": {"temperature_c": (19.0, 0.8), "humidity_pct": (38.0, 2.5),
                    "co2_ppm": (450.0, 40.0), "vibration_g": (0.060, 0.008)},
}
# Standard deviation of the random noise added to every reading.
NOISE = {"temperature_c": 0.25, "humidity_pct": 0.8, "co2_ppm": 15.0, "vibration_g": 0.002}
ANOMALY_RATE = 0.02
BACKFILL_RATE_PER_SEC = 50  # AWS IoT allows 100 publishes/s per connection; stay well below.

connected_event = threading.Event()


def find_certs(certs_dir):
    """Locate the device certificate, private key and Amazon root CA in certs_dir."""
    certs_dir = os.path.abspath(certs_dir)
    if not os.path.isdir(certs_dir):
        sys.exit(f"[error] certs folder not found: {certs_dir}")
    cert = sorted(glob.glob(os.path.join(certs_dir, "*.cert.pem")))
    key = sorted(glob.glob(os.path.join(certs_dir, "*.private.key")))
    root_ca = os.path.join(certs_dir, "root-CA.crt")
    if not os.path.isfile(root_ca):
        alt = os.path.join(certs_dir, "AmazonRootCA1.pem")
        root_ca = alt if os.path.isfile(alt) else None
    missing = []
    if not cert:
        missing.append("*.cert.pem (device certificate)")
    if not key:
        missing.append("*.private.key (device private key)")
    if not root_ca:
        missing.append("root-CA.crt (download https://www.amazontrust.com/repository/AmazonRootCA1.pem and save as root-CA.crt)")
    if missing:
        print(f"[error] missing files in {certs_dir}:")
        for m in missing:
            print(f"   - {m}")
        sys.exit(1)
    return root_ca, cert[0], key[0]


def make_reading(device, location, ts_ms, rng):
    """Build one telemetry reading for a location at epoch-ms ts_ms."""
    hour = datetime.fromtimestamp(ts_ms / 1000.0).hour + datetime.fromtimestamp(ts_ms / 1000.0).minute / 60.0
    # Daily cycle: peak mid-afternoon (~15:00), lowest early morning (~03:00).
    cycle = math.sin((hour - 9.0) / 24.0 * 2 * math.pi)
    values = {}
    for metric, (mean, amp) in BASELINES[location].items():
        values[metric] = mean + amp * cycle + rng.gauss(0, NOISE[metric])

    injected = rng.random() < ANOMALY_RATE
    if injected:
        # Spike one or more fields.
        fields = rng.sample(list(values.keys()), rng.randint(1, 3))
        for f in fields:
            if f == "temperature_c":
                values[f] += rng.uniform(8, 15)
            elif f == "humidity_pct":
                values[f] += rng.uniform(20, 35)
            elif f == "co2_ppm":
                values[f] += rng.uniform(800, 1500)
            elif f == "vibration_g":
                values[f] *= rng.uniform(8, 15)

    return {
        "device": device,
        "location": location,
        "timestamp": int(ts_ms),
        "temperature_c": round(values["temperature_c"], 2),
        "humidity_pct": round(min(max(values["humidity_pct"], 0.0), 100.0), 1),
        "co2_ppm": round(max(values["co2_ppm"], 350.0), 1),
        "vibration_g": round(max(values["vibration_g"], 0.0), 3),
        "injected_anomaly": injected,
    }


def on_connect(client, userdata, flags, rc):
    print(f"[mqtt] connect result rc={rc} ({mqtt.connack_string(rc)})", flush=True)
    if rc == 0:
        client.subscribe(userdata["command_topic"], qos=1)
        print(f"[mqtt] subscribed to {userdata['command_topic']}", flush=True)
        connected_event.set()
    elif rc == 5:
        print("[hint] rc=5: certificate inactive or psb-lab-device-policy not attached to the certificate.", flush=True)


def on_disconnect(client, userdata, rc):
    connected_event.clear()
    if rc != 0:
        print(f"[mqtt] unexpected disconnect rc={rc} ({mqtt.error_string(rc)}); paho will retry...", flush=True)


def on_message(client, userdata, msg):
    try:
        payload = msg.payload.decode("utf-8")
    except UnicodeDecodeError:
        payload = repr(msg.payload)
    print(f"[command] {msg.topic}: {payload}", flush=True)


def build_client(args, root_ca, cert, key):
    client = mqtt.Client(client_id=args.client_id, protocol=mqtt.MQTTv311)
    client.user_data_set({"command_topic": f"psb/lab/{args.client_id}/commands"})
    client.tls_set(ca_certs=root_ca, certfile=cert, keyfile=key,
                   cert_reqs=ssl.CERT_REQUIRED, tls_version=ssl.PROTOCOL_TLSv1_2)
    client.on_connect = on_connect
    client.on_disconnect = on_disconnect
    client.on_message = on_message
    client.max_inflight_messages_set(50)
    client.reconnect_delay_set(min_delay=1, max_delay=30)
    return client


def wait_connected(timeout=30):
    if not connected_event.wait(timeout):
        print(f"[error] not connected after {timeout}s. Check the endpoint, port 8883 outbound, certificate and policy.")
        return False
    return True


def run_live(client, args, topic, rng):
    print(f"[live] publishing every {args.interval}s to {topic} (Ctrl+C to stop)", flush=True)
    n = 0
    while True:
        if not connected_event.is_set():
            time.sleep(1)
            continue
        location = LOCATIONS[n % len(LOCATIONS)]
        reading = make_reading(args.client_id, location, time.time() * 1000, rng)
        info = client.publish(topic, json.dumps(reading), qos=1)
        n += 1
        flag = "  <-- injected anomaly" if reading["injected_anomaly"] else ""
        print(f"[pub #{n}] rc={info.rc} {location:<11} t={reading['temperature_c']:.2f}C "
              f"h={reading['humidity_pct']:.1f}% co2={reading['co2_ppm']:.0f}ppm "
              f"vib={reading['vibration_g']:.3f}g{flag}", flush=True)
        time.sleep(args.interval)


def run_backfill(client, args, topic, rng):
    total = int(args.backfill_hours * 3600 / args.interval)
    start_ms = (time.time() - args.backfill_hours * 3600) * 1000
    step_ms = args.interval * 1000
    print(f"[backfill] publishing {total} historical readings ({args.backfill_hours}h at {args.interval}s spacing) "
          f"at ~{BACKFILL_RATE_PER_SEC}/s to {topic}", flush=True)
    anomalies = 0
    last_info = None
    t0 = time.time()
    for i in range(total):
        while not connected_event.is_set():
            time.sleep(0.5)
        location = LOCATIONS[i % len(LOCATIONS)]
        reading = make_reading(args.client_id, location, start_ms + i * step_ms, rng)
        anomalies += reading["injected_anomaly"]
        last_info = client.publish(topic, json.dumps(reading), qos=1)
        # Throttle to BACKFILL_RATE_PER_SEC.
        expected = t0 + (i + 1) / BACKFILL_RATE_PER_SEC
        delay = expected - time.time()
        if delay > 0:
            time.sleep(delay)
        if (i + 1) % 500 == 0 or i + 1 == total:
            pct = 100.0 * (i + 1) / total
            print(f"[backfill] {i + 1}/{total} ({pct:.0f}%) published, injected anomalies so far: {anomalies}", flush=True)
    if last_info is not None:
        try:
            last_info.wait_for_publish(timeout=30)
        except TypeError:  # very old paho without timeout argument
            last_info.wait_for_publish()
    time.sleep(2)  # let remaining QoS1 acks arrive
    print(f"[backfill] done: {total} readings, {anomalies} injected anomalies, {time.time() - t0:.0f}s", flush=True)


def main():
    p = argparse.ArgumentParser(description="PSB lab sensor simulator: publishes telemetry to AWS IoT Core over MQTT/TLS.")
    p.add_argument("--endpoint", required=True, help="IoT device data endpoint (xxxx-ats.iot.ap-southeast-1.amazonaws.com)")
    p.add_argument("--certs-dir", default="certs", help="folder with *.cert.pem, *.private.key and root-CA.crt (default: certs)")
    p.add_argument("--interval", type=float, default=10.0, help="seconds between readings (default: 10)")
    p.add_argument("--backfill-hours", type=float, default=0.0,
                   help="publish this many hours of historical readings quickly, then exit (default: 0 = live mode)")
    p.add_argument("--client-id", default="psb-lab-sensor-01", help="MQTT client id / thing name (default: psb-lab-sensor-01)")
    p.add_argument("--port", type=int, default=8883, help="MQTT TLS port (default: 8883)")
    args = p.parse_args()

    if args.interval <= 0:
        sys.exit("[error] --interval must be greater than 0")
    if args.backfill_hours < 0:
        sys.exit("[error] --backfill-hours must be 0 or more")

    endpoint = args.endpoint.replace("https://", "").replace("mqtts://", "").strip().strip("/")
    root_ca, cert, key = find_certs(args.certs_dir)
    print(f"[init] client-id={args.client_id} endpoint={endpoint}:{args.port}")
    print(f"[init] root CA : {root_ca}")
    print(f"[init] cert    : {cert}")
    print(f"[init] key     : {key}")

    topic = f"psb/lab/{args.client_id}/telemetry"
    rng = random.Random()
    client = build_client(args, root_ca, cert, key)

    try:
        print("[mqtt] connecting...", flush=True)
        client.connect(endpoint, args.port, keepalive=60)
        client.loop_start()
        if not wait_connected():
            client.loop_stop()
            sys.exit(2)
        if args.backfill_hours > 0:
            run_backfill(client, args, topic, rng)
        else:
            run_live(client, args, topic, rng)
    except KeyboardInterrupt:
        print("\n[stop] Ctrl+C received, disconnecting...", flush=True)
    except (OSError, ssl.SSLError) as exc:
        print(f"[error] connection failed: {exc}", flush=True)
        sys.exit(2)
    finally:
        try:
            client.disconnect()
            client.loop_stop()
        except Exception:
            pass
    print("[stop] simulator stopped.")


if __name__ == "__main__":
    main()
