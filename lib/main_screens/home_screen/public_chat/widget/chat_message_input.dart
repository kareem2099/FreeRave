import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../cubit/stream_chat_cubit.dart';

class ChatMessageInput extends StatelessWidget {
  final Channel channel;

  const ChatMessageInput({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamMessageInput(
        onMessageSent: (Message message) {
          // Make sure the message is sent properly
          context.read<StreamChatCubit>().sendMessage(channel, message.text!);
          // Log the message to ensure it's correctly sent
          print('Message sent: ${message.text}');
        },
        sendButtonLocation: SendButtonLocation.inside, // Keep the button inside
        disableAttachments: false, // No attachments allowed for now
      ),
    );
  }
}

