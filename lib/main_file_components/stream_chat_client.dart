import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../main_screens/home_screen/public_chat/const.dart';

final client = StreamChatClient(
  streamApiKey,
  logLevel: Level.INFO,
);
