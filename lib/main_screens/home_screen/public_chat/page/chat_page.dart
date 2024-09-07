import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../cubit/stream_chat_cubit.dart';
import '../cubit/stream_chat_state.dart';
import '../widget/chat_list.dart';

class ChatPage extends StatelessWidget {
  final Channel channel;

  const ChatPage({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Public Chat'),
      ),
      body: StreamChannel(
        channel: channel,
        child: Column(
          children: [
            const Expanded(
              child: ChatList(), // Chat message list
            ),
            BlocBuilder<StreamChatCubit, PublicChatState>(
              builder: (context, state) {
                return StreamMessageInput(
                  onMessageSent: (Message message) {
                    context.read<StreamChatCubit>().sendMessage(channel, message.text!);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
