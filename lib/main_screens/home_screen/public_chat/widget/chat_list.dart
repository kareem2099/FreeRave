import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'chat_bubble.dart';
import 'chat_loading_indicator.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamMessageListView(
      loadingBuilder: (context) {
        return const ChatLoadingIndicator(); // Show loading indicator while messages are being fetched
      },
      messageBuilder: (context, messageDetails, messages, defaultMessageWidget) {
        return ChatBubble(message: messageDetails.message); // Use custom chat bubble for each message
      },
    );
  }
}
