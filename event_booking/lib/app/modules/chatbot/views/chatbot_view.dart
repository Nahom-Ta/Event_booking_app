import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chatbot_controller.dart';

class ChatbotView extends GetView<ChatbotController> {
  const ChatbotView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized if not already
    // (In case binding didn't fire yet or used as a nested widget)
    if (!Get.isRegistered<ChatbotController>()) {
      Get.put(ChatbotController());
    }

    return Obx(() {
      final isOpen = controller.isOpen.value;

      return AnimatedPositioned(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        bottom: 20, // Always 20px from bottom
        right: 20,  // Always 20px from right
        width: isOpen ? 350 : 60,  // Expand width
        height: isOpen ? 500 : 60, // Expand height
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(30), // Round when closed, slightly less when open? Keep round.
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: isOpen ? _buildChatWindow() : _buildFloatingButton(),
        ),
      );
    });
  }

  Widget _buildFloatingButton() {
    return InkWell(
      onTap: controller.toggleChat,
      child: Container(
        alignment: Alignment.center,
        color: const Color(0xFF5669FF),
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildChatWindow() {
    return Column(
      children: [
        // Header
        Container(
          color: const Color(0xFF5669FF),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.smart_toy, color: Colors.white),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  "Event Assistant",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: controller.toggleChat,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              )
            ],
          ),
        ),

        // Messages List
        Expanded(
          child: Container(
            color: const Color(0xFFF8F9FE),
            child: Obx(() {
               return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: controller.messages.length + (controller.isTyping.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.messages.length) {
                     return _buildTypingIndicator(); // Show typing bubble
                  }
                  return _buildMessageBubble(controller.messages[index]);
                },
              );
            }),
          ),
        ),

        // Input Area
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.black12)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.textController,
                  decoration: const InputDecoration(
                    hintText: "Ask something...",
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onSubmitted: (_) => controller.sendMessage(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Color(0xFF5669FF)),
                onPressed: controller.sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 260),
        decoration: BoxDecoration(
          color: msg.isUser ? const Color(0xFF5669FF) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: msg.isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: msg.isUser ? Radius.zero : const Radius.circular(16),
          ),
          boxShadow: [
             if (!msg.isUser)
               BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
          ],
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            color: msg.isUser ? Colors.white : Colors.black87,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.only(
             topLeft: Radius.circular(16),
             topRight: Radius.circular(16),
             bottomRight: Radius.circular(16),
           ),
        ),
        child: const Text(
          "Typing...", 
          style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic)
        ),
      ),
    );
  }
}
