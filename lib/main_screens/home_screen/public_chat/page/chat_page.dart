import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../cubit/stream_chat_cubit.dart';
import '../cubit/stream_chat_state.dart';
import '../widget/chat_list.dart';
import '../widget/chat_message_input.dart';

class ChatPage extends StatefulWidget {
  final Channel channel;
  final StreamChatClient client;

  const ChatPage({super.key, required this.channel, required this.client});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  late StreamChatCubit _cubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit = context.read<StreamChatCubit>();
    _cubit.monitorUserPresence(widget.client.state.currentUser!);
    _cubit.monitorTypingIndicator(widget.channel);
    _cubit.connectUser();
  }

  @override
  Widget build(BuildContext context) {
    return StreamChat(
      client: widget.client,
      child: Portal(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Public Chat'),

          ),
          body: StreamChannel(
            channel: widget.channel,
            child: Column(
              children: [
                Expanded(
                  child: ChatList(
                    onReaction: (messageId) {
                      _cubit.loadReactions(messageId);
                    },
                    onThreadReply: (message) {
                      _cubit.sendThreadedReply(widget.channel, message, 'Reply text');
                    },
                  ),
                ),
                BlocBuilder<StreamChatCubit, PublicChatState>(
                  builder: (context, state) {
                    if (state is PublicChatLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is PublicChatError) {
                      return Text('Error: ${state.error}');
                    } else {
                      return Column(
                        children: [
                          if (state is PublicChatTyping && state.isTyping)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('Someone is typing...'),
                            ),
                          ChatMessageInput(channel: widget.channel),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }
}
