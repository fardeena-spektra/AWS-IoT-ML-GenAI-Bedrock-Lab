"""
psb-assistant  (Python 3.13, stdlib + boto3 only)

What this function does
-----------------------
A small "ask your sensors" assistant built on the Amazon Bedrock Converse API
with tool use.

1. Receives a question, either from API Gateway (POST /assistant, payload v2.0,
   body {"question": "..."}) or by direct invoke ({"question": "..."}).
2. Calls bedrock-runtime converse(MODEL_ID) with a system prompt that limits
   the assistant to the 3 lab locations (north-lab, south-lab, server-room)
   and 4 metrics (temperature_c, humidity_pct, co2_ppm, vibration_g) plus
   anomaly_score, and politely refuses anything else (for example "east wing").
3. Offers the model ONE tool, get_sensor_stats(metric, location?, window_minutes).
   When the model asks for it (stopReason == "tool_use"), this function invokes
   the psb-query-telemetry Lambda directly and returns the summary
   (count/min/max/mean/latest) as a toolResult.
4. Repeats up to MAX_TOOL_TURNS tool rounds, then returns the model's final text:
     {"answer": "...", "tool_calls": n}
   (wrapped in an API Gateway response with CORS headers when called through the API).

The default model is Amazon Nova Lite; any Converse-capable model, including
Anthropic Claude models, can be used by changing MODEL_ID (and the IAM policy).

Environment variables
---------------------
MODEL_ID             apac.amazon.nova-lite-v1:0  (APAC inference profile; Nova Lite has no in-Region endpoint in ap-southeast-1)
QUERY_FUNCTION_NAME  psb-query-telemetry
MAX_TOOL_TURNS       4
"""

import base64
import json
import os

import boto3

MODEL_ID = os.environ.get("MODEL_ID", "apac.amazon.nova-lite-v1:0")
QUERY_FUNCTION_NAME = os.environ.get("QUERY_FUNCTION_NAME", "psb-query-telemetry")
MAX_TOOL_TURNS = max(1, int(os.environ.get("MAX_TOOL_TURNS", "4")))

LOCATIONS = ["north-lab", "south-lab", "server-room"]
METRICS = ["temperature_c", "humidity_pct", "co2_ppm", "vibration_g", "anomaly_score"]

CORS_HEADERS = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "authorization,content-type",
    "Access-Control-Allow-Methods": "GET,POST,OPTIONS",
}

SYSTEM_PROMPT = (
    "You are the PSB lab sensor assistant. You answer questions ONLY about these three lab "
    "locations: north-lab, south-lab and server-room, and ONLY about these metrics: "
    "temperature_c (degrees Celsius), humidity_pct (percent), co2_ppm (parts per million), "
    "vibration_g (g) and anomaly_score (Random Cut Forest score, higher is more unusual). "
    "Always call the get_sensor_stats tool to get real numbers; never invent values. "
    "If the user asks about any other location (for example 'east wing'), any other metric, "
    "or an unrelated topic, politely say you can only help with the three lab locations and "
    "the listed metrics, and do not call the tool. If no location is given, query without a "
    "location (all locations). Convert time phrases to window_minutes (last hour = 60, "
    "last day = 1440, maximum 1440). Keep answers short: 1 to 4 sentences, include units "
    "and round to 2 decimals."
)

TOOL_CONFIG = {
    "tools": [{
        "toolSpec": {
            "name": "get_sensor_stats",
            "description": ("Get summary statistics (count, min, max, mean, latest) for one sensor metric "
                            "over the last window_minutes, optionally for one lab location."),
            "inputSchema": {"json": {
                "type": "object",
                "properties": {
                    "metric": {"type": "string", "enum": METRICS,
                               "description": "Metric to summarise."},
                    "location": {"type": "string", "enum": LOCATIONS,
                                 "description": "Optional lab location. Omit for all locations."},
                    "window_minutes": {"type": "integer", "minimum": 1, "maximum": 1440,
                                       "description": "How many minutes back to look (1-1440)."},
                },
                "required": ["metric", "window_minutes"],
            }},
        }
    }]
}

_bedrock = None
_lambda = None


def get_sensor_stats(tool_input):
    """Run the tool: validate lightly, then invoke psb-query-telemetry directly."""
    global _lambda
    if _lambda is None:
        _lambda = boto3.client("lambda")
    metric = tool_input.get("metric")
    location = tool_input.get("location") or None
    if metric not in METRICS:
        return {"error": f"metric must be one of {METRICS}"}
    if location is not None and location not in LOCATIONS:
        return {"error": f"unknown location '{location}'. Only {LOCATIONS} exist."}
    try:
        window = int(tool_input.get("window_minutes") or 60)
    except (TypeError, ValueError):
        window = 60
    window = max(1, min(window, 1440))
    bucket = 60 if window <= 120 else max(60, (window * 60) // 120)  # ~120 buckets max
    payload = {"metric": metric, "window_minutes": window, "bucket_seconds": min(bucket, 3600)}
    if location:
        payload["location"] = location
    resp = _lambda.invoke(FunctionName=QUERY_FUNCTION_NAME, InvocationType="RequestResponse",
                          Payload=json.dumps(payload).encode("utf-8"))
    result = json.loads(resp["Payload"].read() or b"{}")
    if resp.get("FunctionError"):
        return {"error": f"query function failed: {result.get('errorMessage', 'unknown error')}"}
    if "error" in result:
        return {"error": result["error"]}
    return {"metric": metric, "location": location or "all", "window_minutes": window,
            "summary": result.get("summary", {})}


def ask(question):
    """Converse loop with tool use. Returns (answer_text, tool_call_count)."""
    global _bedrock
    if _bedrock is None:
        _bedrock = boto3.client("bedrock-runtime")
    messages = [{"role": "user", "content": [{"text": question}]}]
    tool_calls = 0
    for turn in range(MAX_TOOL_TURNS + 1):
        resp = _bedrock.converse(
            modelId=MODEL_ID,
            system=[{"text": SYSTEM_PROMPT}],
            messages=messages,
            toolConfig=TOOL_CONFIG,
            inferenceConfig={"maxTokens": 600, "temperature": 0},
        )
        message = resp["output"]["message"]
        messages.append(message)
        text = " ".join(b["text"] for b in message.get("content", []) if "text" in b).strip()
        if resp.get("stopReason") != "tool_use":
            return text or "I could not produce an answer.", tool_calls
        if turn == MAX_TOOL_TURNS:
            break  # tool budget used up
        results = []
        for block in message.get("content", []):
            if "toolUse" not in block:
                continue
            use = block["toolUse"]
            tool_calls += 1
            if use.get("name") == "get_sensor_stats":
                out = get_sensor_stats(use.get("input") or {})
            else:
                out = {"error": f"unknown tool {use.get('name')}"}
            print(f"[tool] #{tool_calls} {use.get('name')} input={json.dumps(use.get('input'))} -> {json.dumps(out)}")
            results.append({"toolResult": {
                "toolUseId": use["toolUseId"],
                "content": [{"json": out}],
                "status": "error" if "error" in out else "success",
            }})
        messages.append({"role": "user", "content": results})
    return ("I could not finish the analysis within the allowed number of tool calls. "
            "Please ask a more specific question."), tool_calls


def _parse_question(event):
    if not isinstance(event, dict):
        return None
    if "requestContext" in event or "body" in event:
        body = event.get("body") or "{}"
        if event.get("isBase64Encoded"):
            body = base64.b64decode(body).decode("utf-8")
        try:
            body = json.loads(body) if isinstance(body, str) else body
        except ValueError:
            return None
        return (body or {}).get("question")
    return event.get("question")


def lambda_handler(event, context):
    from_api = isinstance(event, dict) and "requestContext" in event

    def reply(status, payload):
        if from_api:
            return {"statusCode": status, "headers": CORS_HEADERS, "body": json.dumps(payload)}
        return payload

    question = _parse_question(event)
    if not isinstance(question, str) or not question.strip():
        return reply(400, {"error": 'send {"question": "..."}'})
    question = question.strip()[:1000]
    print(f"[question] {question}")
    try:
        answer, n = ask(question)
    except Exception as exc:
        print(f"[error] {type(exc).__name__}: {exc}")
        if from_api:
            return reply(502, {"error": "assistant failed, see CloudWatch logs"})
        raise
    print(f"[ok] tool_calls={n} answer={answer}")
    return reply(200, {"answer": answer, "tool_calls": n})
