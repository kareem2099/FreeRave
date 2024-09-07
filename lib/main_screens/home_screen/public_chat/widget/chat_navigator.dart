import 'package:flutter/material.dart';
import 'package:freerave/main_screens/home_screen/public_chat/page/chat_page.dart';

import '../cubit/stream_channel_service.dart';

class ChatNavigator {
  final StreamChannelService channelService;

  ChatNavigator(this.channelService);

  Future<void> navigateToChat(BuildContext context, String channelId) async {
    try {
      final channel = await channelService.initializeChannel(channelId);
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(channel: channel),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load chat channel.')),
        );
      }
    }
  }
}
