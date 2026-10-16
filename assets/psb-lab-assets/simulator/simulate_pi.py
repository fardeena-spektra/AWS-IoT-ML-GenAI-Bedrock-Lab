#!/usr/bin/env python3
"""
PSB Academy CloudLab - Raspberry Pi sensor gateway simulator.

Publishes JSON telemetry to AWS IoT Core over MQTT with mutual TLS,
using the same X.509 certificate a physical Raspberry Pi would use.
"""
import argparse, json, math, random, signal, ssl, sys, time
import paho.mqtt.client as mqtt

TOPIC_TEMPLATE = "psb/lab/{device_id}/telemetry"
SENSORS = ["north-lab", "south-lab", "server-room"]


def build_client(device_id, endpoint, certs_dir):
    client = mqtt.Client(client_id=device_id, protocol=mqtt.MQTTv311)
    client.tls_set(
        ca_certs=f"{certs_dir}/root-CA.crt",
        certfile=f"{certs_dir}/{device_id}.cert.pem",
        keyfile=f"{certs_dir}/{device_id}.private.key",
        tls_version=ssl.PROTOCOL_TLSv1_2,
    )
    client.on_connect = lambda c, u, f, rc: print(
        f"[mqtt] connect rc={rc} ({mqtt.connack_string(rc)})"
    )
    client.connect(endpoint, 8883, keepalive=60)
    return client


def reading(location, t, anomaly_rate):
    """Diurnal baseline + noise, with occasional injected anomalies."""
    phase = (t % 86400) / 86400 * 2 * math.pi
    temp = 22.0 + 3.0 * math.sin(phase) + random.gauss(0, 0.35)
    hum = 55.0 - 6.0 * math.sin(phase) + random.gauss(0, 1.2)
    co2 = 480.0 + 120.0 * max(0.0, math.sin(phase)) + random.gauss(0, 25)
    vib = abs(random.gauss(0.02, 0.006))

    is_anomaly = random.random() < anomaly_rate
    if is_anomaly:
        kind = random.choice(["heat", "co2", "vibration"])
        if kind == "heat":
            temp += random.uniform(8, 14)
        elif kind == "co2":
            co2 += random.uniform(600, 1200)
        else:
            vib += random.uniform(0.12, 0.30)

    return {
        "device_id": "psb-lab-sensor-01",
        "location": location,
        "ts": int(t),
        "temperature_c": round(temp, 2),
        "humidity_pct": round(hum, 2),
        "co2_ppm": round(co2, 1),
        "vibration_g": round(vib, 4),
        "injected_anomaly": is_anomaly,
    }


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--endpoint", required=True)
    p.add_argument("--device-id", default="psb-lab-sensor-01")
    p.add_argument("--certs-dir", default="certs")
    p.add_argument("--interval", type=float, default=10.0)
    p.add_argument("--anomaly-rate", type=float, default=0.02)
    p.add_argument("--backfill-hours", type=float, default=0.0,
                   help="Publish this many hours of synthetic history, then stop.")
    a = p.parse_args()

    client = build_client(a.device_id, a.endpoint, a.certs_dir)
    topic = TOPIC_TEMPLATE.format(device_id=a.device_id)
    client.loop_start()

    running = {"go": True}
    signal.signal(signal.SIGINT, lambda *_: running.update(go=False))

    if a.backfill_hours > 0:
        now, step = time.time(), a.interval
        n = int(a.backfill_hours * 3600 / step)
        print(f"[sim] back-filling {n} readings over {a.backfill_hours} h ...")
        for i in range(n):
            t = now - (n - i) * step
            msg = reading(SENSORS[i % len(SENSORS)], t, a.anomaly_rate)
            client.publish(topic, json.dumps(msg), qos=1)
            if i % 100 == 0:
                print(f"[sim] {i}/{n}")
            time.sleep(0.02)
        print("[sim] back-fill complete.")
        client.loop_stop(); client.disconnect(); return

    print(f"[sim] publishing to {topic} every {a.interval}s. Ctrl+C to stop.")
    i = 0
    while running["go"]:
        msg = reading(SENSORS[i % len(SENSORS)], time.time(), a.anomaly_rate)
        client.publish(topic, json.dumps(msg), qos=1)
        print(f"[sim] {msg['location']:>12}  "
              f"{msg['temperature_c']:>6.2f} C  {msg['co2_ppm']:>7.1f} ppm"
              f"{'   <-- ANOMALY' if msg['injected_anomaly'] else ''}")
        i += 1
        time.sleep(a.interval)

    client.loop_stop(); client.disconnect()


if __name__ == "__main__":
    main()
