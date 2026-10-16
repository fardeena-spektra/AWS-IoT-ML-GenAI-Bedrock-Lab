"""
PSB Academy CloudLab - natural-language telemetry assistant.

Amazon Bedrock Converse API with tool use. The model is given one
tool, get_sensor_stats, which is backed by the psb-query-telemetry
Lambda function built in Lab 03.
"""
import json
import os

import boto3

MODEL_ID = os.environ.get("MODEL_ID", "amazon.nova-lite-v1:0")
QUERY_FUNCTION = os.environ["QUERY_FUNCTION_NAME"]
MAX_TOOL_TURNS = int(os.environ.get("MAX_TOOL_TURNS", "4"))

_bedrock = boto3.client("bedrock-runtime")
_lambda = boto3.client("lambda")

SYSTEM_PROMPT = [{
    "text": (
        "You are the PSB Academy laboratory monitoring assistant. "
        "You answer questions about live sensor telemetry from three "
        "locations: north-lab, south-lab and server-room. "
        "Four metrics are available: temperature_c (degrees Celsius), "
        "humidity_pct (relative humidity), co2_ppm (carbon dioxide in "
        "parts per million) and anomaly_score (an unsupervised Random "
        "Cut Forest score; values above about 1.5 are unusual).\n\n"
        "Rules:\n"
        "1. Always call get_sensor_stats before making any claim about "
        "a number. Never guess or recall a value.\n"
        "2. If the tool returns point_count 0, say plainly that there "
        "is no data in that window. Do not invent a value.\n"
        "3. Quote units. Round to one decimal place.\n"
        "4. Be concise: two or three sentences unless asked for detail.\n"
        "5. If asked about a location or metric that is not in the "
        "lists above, say which ones are available."
    )
}]

TOOL_CONFIG = {
    "tools": [{
        "toolSpec": {
            "name": "get_sensor_stats",
            "description": (
                "Return aggregated statistics and a downsampled time "
                "series for one sensor metric over a recent time window. "
                "Use this for every question about sensor values, trends "
                "or anomalies."
            ),
            "inputSchema": {"json": {
                "type": "object",
                "properties": {
                    "metric": {
                        "type": "string",
                        "enum": ["temperature_c", "humidity_pct",
                                 "co2_ppm", "vibration_g",
                                 "anomaly_score"],
                        "description": "Which metric to retrieve.",
                    },
                    "window_minutes": {
                        "type": "integer",
                        "description": (
                            "How far back to look, in minutes. "
                            "Between 1 and 1440."),
                    },
                    "location": {
                        "type": "string",
                        "enum": ["north-lab", "south-lab", "server-room"],
                        "description": (
                            "Optional. Omit to cover all locations."),
                    },
                },
                "required": ["metric", "window_minutes"],
            }},
        }
    }]
}


def run_tool(name, arguments):
    if name != "get_sensor_stats":
        return {"error": f"unknown tool {name}"}
    response = _lambda.invoke(
        FunctionName=QUERY_FUNCTION,
        InvocationType="RequestResponse",
        Payload=json.dumps(arguments).encode("utf-8"),
    )
    result = json.loads(response["Payload"].read())
    # Send the model the summary plus a light sample of the series.
    # Handing it 300 raw points wastes tokens and helps nothing.
    return {
        "summary": result.get("summary", {}),
        "sample": result.get("points", [])[-12:],
    }


def converse(messages):
    return _bedrock.converse(
        modelId=MODEL_ID,
        system=SYSTEM_PROMPT,
        messages=messages,
        toolConfig=TOOL_CONFIG,
        inferenceConfig={"maxTokens": 600, "temperature": 0.2},
    )


def ask(question):
    messages = [{"role": "user", "content": [{"text": question}]}]
    trace = []

    for _ in range(MAX_TOOL_TURNS):
        response = converse(messages)
        output = response["output"]["message"]
        messages.append(output)

        if response.get("stopReason") != "tool_use":
            answer = "".join(block.get("text", "")
                             for block in output["content"])
            return {"answer": answer.strip(), "trace": trace,
                    "usage": response.get("usage", {})}

        # The model asked for one or more tools. Run them all.
        tool_results = []
        for block in output["content"]:
            if "toolUse" not in block:
                continue
            use = block["toolUse"]
            trace.append({"tool": use["name"], "input": use["input"]})
            result = run_tool(use["name"], use["input"])
            tool_results.append({"toolResult": {
                "toolUseId": use["toolUseId"],
                "content": [{"json": result}],
            }})
        messages.append({"role": "user", "content": tool_results})

    return {"answer": ("I could not answer that within the allowed "
                       "number of tool calls. Try a narrower question."),
            "trace": trace, "usage": {}}


def _response(status, body):
    return {
        "statusCode": status,
        "headers": {"Content-Type": "application/json",
                    "Access-Control-Allow-Origin": "*"},
        "body": json.dumps(body),
    }


def lambda_handler(event, context):
    try:
        body = json.loads(event.get("body") or "{}")
    except json.JSONDecodeError:
        return _response(400, {"error": "body must be valid JSON"})

    question = (body.get("question") or "").strip()
    if not question:
        return _response(400, {"error": "field 'question' is required"})
    if len(question) > 500:
        return _response(400, {"error": "question is too long"})

    try:
        result = ask(question)
    except Exception as err:                      # noqa: BLE001
        print(f"[error] {type(err).__name__}: {err}")
        return _response(502, {"error": "assistant unavailable"})

    print(f"[ok] q={question[:80]!r} tools={len(result['trace'])} "
          f"usage={result.get('usage')}")
    return _response(200, result)
