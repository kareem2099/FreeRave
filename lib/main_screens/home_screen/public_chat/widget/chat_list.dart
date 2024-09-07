import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'chat_bubble.dart';
import 'chat_loading_indicator.dart';

class ChatList extends StatelessWidget {
  final Function(String) onReaction;
  final Function(Message) onThreadReply;

  const ChatList({
    super.key,
    required this.onReaction,
    required this.onThreadReply,
  });

  @override
  Widget build(BuildContext context) {
    return StreamMessageListView(
      loadingBuilder: (context) {
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChatLoadingIndicator(),
            SizedBox(height: 10),
            Text('Loading Messages...'),
          ],
        );
      },
      messageBuilder: (context, messageDetails, messages, defaultMessageWidget) {
        return ChatBubble(
          message: messageDetails.message,
          onReaction: onReaction,
          onThreadReply: onThreadReply,
        );
      },
    );
  }
}
