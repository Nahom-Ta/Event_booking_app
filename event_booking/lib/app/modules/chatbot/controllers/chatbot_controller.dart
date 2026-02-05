import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:event_booking/app/data/api_constants.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  ChatMessage({required this.text, required this.isUser, required this.time});
}

class ChatbotController extends GetxController {
  var isOpen = false.obs;
  var isTyping = false.obs;
  var messages = <ChatMessage>[].obs;
  final scrollController = ScrollController();
  final textController = TextEditingController();
  final http.Client _client = http.Client();

  String? _activeStreamId;
  StreamSubscription<String>? _streamSub;
  int? _activeAssistantIndex;
  bool _isStreaming = false;

  @override
  void onInit() {
    super.onInit();
    // content of the chat bot initial message
    messages.add(
      ChatMessage(
        text: "Hi! I'm your Event Assistant. How can I help you today?",
        isUser: false,
        time: DateTime.now(),
      ),
    );
  }

  void toggleChat() {
    isOpen.value = !isOpen.value;
    if (!isOpen.value) {
      _stopStream();
    }
  }

  void sendMessage() {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    _stopStream();

    // Add User Message
    messages.add(ChatMessage(text: text, isUser: true, time: DateTime.now()));
    textController.clear();
    _scrollToBottom();

    _startStream(text);
  }

  Future<void> _startStream(String userText) async {
    isTyping.value = true;
    _scrollToBottom();

    final streamUrl = '${Apiconstants.baseUrl}/api/chat/stream/';
    final request = http.Request('POST', Uri.parse(streamUrl));
    request.headers['Content-Type'] = 'application/json';
    request.body = jsonEncode({'message': userText, 'model': 'gpt-4o-mini'});

    _activeAssistantIndex = messages.length;
    messages.add(ChatMessage(text: '', isUser: false, time: DateTime.now()));

    try {
      _isStreaming = true;
      final response = await _client.send(request);
      if (response.statusCode != 200) {
        final body = await response.stream.bytesToString();
        _appendAssistantText('Error: ${response.statusCode}');
        if (body.isNotEmpty) {
          _appendAssistantText('\n$body');
        }
        isTyping.value = false;
        _isStreaming = false;
        return;
      }

      String buffer = '';
      _streamSub = response.stream
          .transform(utf8.decoder)
          .listen(
            (chunk) {
              buffer += chunk;
              while (buffer.contains('\n\n')) {
                final parts = buffer.split('\n\n');
                buffer = parts.removeLast();
                for (final part in parts) {
                  final line = part.trim();
                  if (!line.startsWith('data:')) continue;
                  final jsonText = line.replaceFirst(RegExp(r'^data:\s*'), '');
                  _handleSseEvent(jsonText);
                }
              }
            },
            onDone: () {
              isTyping.value = false;
              _isStreaming = false;
            },
            onError: (_) {
              isTyping.value = false;
              _isStreaming = false;
            },
          );
    } catch (e) {
      _appendAssistantText('Error: $e');
      isTyping.value = false;
      _isStreaming = false;
    }
  }

  void _handleSseEvent(String jsonText) {
    try {
      final event = jsonDecode(jsonText);
      final type = event['type']?.toString();

      if (type == 'meta') {
        _activeStreamId = event['stream_id']?.toString();
        return;
      }
      if (type == 'token') {
        final delta = event['delta']?.toString() ?? '';
        if (delta.isNotEmpty) {
          _appendAssistantText(delta);
        }
        return;
      }
      if (type == 'done' || type == 'stopped') {
        isTyping.value = false;
        _isStreaming = false;
        return;
      }
    } catch (_) {
      // Ignore malformed events
    }
  }

  void _appendAssistantText(String delta) {
    if (_activeAssistantIndex == null ||
        _activeAssistantIndex! >= messages.length) {
      return;
    }
    final current = messages[_activeAssistantIndex!];
    messages[_activeAssistantIndex!] = ChatMessage(
      text: current.text + delta,
      isUser: false,
      time: current.time,
    );
    messages.refresh();
    _scrollToBottom();
  }

  Future<void> _stopStream() async {
    if (!_isStreaming) return;
    final streamId = _activeStreamId;
    if (streamId == null) return;

    _streamSub?.cancel();
    _streamSub = null;

    final stopUrl = '${Apiconstants.baseUrl}/api/chat/stop/';
    try {
      await _client.post(
        Uri.parse(stopUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'stream_id': streamId}),
      );
    } catch (_) {
      // Ignore stop errors
    } finally {
      _isStreaming = false;
      isTyping.value = false;
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    _stopStream();
    _client.close();
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
