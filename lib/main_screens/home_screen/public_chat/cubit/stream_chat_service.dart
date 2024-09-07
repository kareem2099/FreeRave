import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class StreamChatService {
  final StreamChatClient client;

  StreamChatService(this.client);

  Future<void> connectUser(User user, String token) async {
    await client.connectUser(user, token);
  }

  Future<void> disconnectUser() async {
    await client.disconnectUser();
  }

  Future<Channel> createChannel(String channelId) async {
    final channel = client.channel('messaging', id: channelId);
    await channel.create();
    return channel;
  }

  Stream<List<Message>> getMessages(Channel channel) {
    return channel.state?.messagesStream ?? Stream.value([]);
  }

  Future<void> sendMessage(Channel channel, String text) async {
    final message = Message(text: text);
    await channel.sendMessage(message);
  }
}
