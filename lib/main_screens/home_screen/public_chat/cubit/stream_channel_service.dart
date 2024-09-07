import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class StreamChannelService {
  final StreamChatClient client;

  StreamChannelService(this.client);

  Future<Channel> initializeChannel(String channelId) async {
    final channel = client.channel('messaging', id: channelId);
    await channel.watch();
    return channel;
  }
}
