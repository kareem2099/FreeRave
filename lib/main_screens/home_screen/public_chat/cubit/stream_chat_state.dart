
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

abstract class PublicChatState {}

class PublicChatInitial extends PublicChatState {}

class PublicChatConnecting extends PublicChatState {}

class PublicChatConnected extends PublicChatState {}

class PublicChatDisconnected extends PublicChatState {}

class PublicChatError extends PublicChatState {
  final String error;
  PublicChatError(this.error);
}

class PublicChatLoadingMessages extends PublicChatState {}

class PublicChatMessagesLoaded extends PublicChatState {
  final List<Message> messages;
  PublicChatMessagesLoaded(this.messages);
}

class PublicChatSendingMessage extends PublicChatState {}

class PublicChatMessageSent extends PublicChatState {}
