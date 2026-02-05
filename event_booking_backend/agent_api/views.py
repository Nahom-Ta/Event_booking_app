import json
from typing import Dict
from uuid import uuid4

from django.http import JsonResponse, StreamingHttpResponse, HttpRequest
from django.views.decorators.csrf import csrf_exempt

from src.chatbot import run_chat_stream

STREAM_ABORT: Dict[str, bool] = {}


def _sse_pack(event: dict) -> str:
    return f"data: {json.dumps(event, ensure_ascii=False)}\n\n"


@csrf_exempt
def chat_stream(request: HttpRequest):
    if request.method != "POST":
        return JsonResponse({"error": "POST required"}, status=405)

    try:
        payload = json.loads(request.body or "{}")
    except json.JSONDecodeError:
        return JsonResponse({"error": "Invalid JSON"}, status=400)

    user_message = (payload.get("message") or "").strip()
    model = payload.get("model")

    if not user_message:
        return JsonResponse({"error": "message is required"}, status=400)

    stream_id = payload.get("stream_id") or str(uuid4())
    STREAM_ABORT[stream_id] = False

    def stop_check() -> bool:
        return STREAM_ABORT.get(stream_id, False)

    def event_stream():
        yield _sse_pack({"type": "meta", "stream_id": stream_id})
        for event in run_chat_stream(
            user_input=user_message,
            model=model,
            stop_check=stop_check,
        ):
            yield _sse_pack(event)
            if stop_check():
                yield _sse_pack({"type": "stopped", "stream_id": stream_id})
                break
        STREAM_ABORT.pop(stream_id, None)

    response = StreamingHttpResponse(event_stream(), content_type="text/event-stream")
    response["Cache-Control"] = "no-cache"
    response["X-Accel-Buffering"] = "no"
    return response


@csrf_exempt
def chat_stop(request: HttpRequest):
    if request.method != "POST":
        return JsonResponse({"error": "POST required"}, status=405)

    try:
        payload = json.loads(request.body or "{}")
    except json.JSONDecodeError:
        return JsonResponse({"error": "Invalid JSON"}, status=400)

    stream_id = payload.get("stream_id")
    if not stream_id:
        return JsonResponse({"error": "stream_id is required"}, status=400)

    if stream_id not in STREAM_ABORT:
        return JsonResponse({"error": "stream_id not found"}, status=404)

    STREAM_ABORT[stream_id] = True
    return JsonResponse({"ok": True, "stream_id": stream_id})
