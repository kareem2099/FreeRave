import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatMessageInput extends StatelessWidget {
  const ChatMessageInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamMessageInput(
        onMessageSent: (Message message) {
          print("Message sent: ${message.text}");
        },
        sendButtonLocation: SendButtonLocation.inside, // Send button inside the input field
        disableAttachments: true, // Disable attachments for public chat
      ),
    );
  }
}
