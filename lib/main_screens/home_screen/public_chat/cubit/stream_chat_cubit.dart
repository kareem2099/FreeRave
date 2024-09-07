
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freerave/main_screens/home_screen/public_chat/cubit/stream_chat_state.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'stream_chat_service.dart';

class StreamChatCubit extends Cubit<PublicChatState> {
  final StreamChatService chatService;

  StreamChatCubit(this.chatService) : super(PublicChatInitial());

  Future<void> connectUser(User user, String token) async {
    try {
      emit(PublicChatConnecting());
      await chatService.connectUser(user, token);
      emit(PublicChatConnected());
    } catch (e) {
      emit(PublicChatError('Error connecting user: ${e.toString()}'));
    }
  }

  Future<void> disconnectUser() async {
    try {
      await chatService.disconnectUser();
      emit(PublicChatDisconnected());
    } catch (e) {
      emit(PublicChatError('Error disconnecting user'));
    }
  }

  Future<void> loadMessages(Channel channel) async {
    try {
      emit(PublicChatLoadingMessages());
      final messagesStream = chatService.getMessages(channel);
      messagesStream.listen((messages) {
        emit(PublicChatMessagesLoaded(messages));
      });
    } catch (e) {
      emit(PublicChatError('Error loading messages'));
    }
  }

  Future<void> sendMessage(Channel channel, String message) async {
    try {
      emit(PublicChatSendingMessage());
      await chatService.sendMessage(channel, message);
      emit(PublicChatMessageSent());
    } catch (e) {
      emit(PublicChatError('Error sending message'));
    }
  }
}
