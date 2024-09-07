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
  }

  @override
  Widget build(BuildContext context) {
    return StreamChat(
      client: widget.client,
      child: Portal(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Public Chat'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  _cubit.disconnectUser();
                },
              ),
            ],
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
                  ), // Chat message list
                ),
                BlocBuilder<StreamChatCubit, PublicChatState>(
                  builder: (context, state) {
                    if (state is PublicChatLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is PublicChatError) {
                      return Text('Error: ${state.error}');
                    } else if (state is PublicChatMessagesLoaded) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final message = state.messages[index];
                            return ListTile(
                              title: Text(message.text ?? ''),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.thumb_up),
                                    onPressed: () {
                                      _cubit.loadReactions(message.id);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.reply),
                                    onPressed: () {
                                      _cubit.sendThreadedReply(widget.channel, message, 'Reply text');
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is PublicChatTyping) {
                      return Text(state.isTyping ? 'Someone is typing...' : '');
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ChatMessageInput(
                            channel:widget.channel
                        ),
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
