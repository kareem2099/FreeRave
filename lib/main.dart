import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freerave/main_screens/home_screen/home_screen.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:freerave/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'auth/cubit/auth_cubit.dart';
import 'auth/cubit/friend_request_cubit.dart';
import 'auth/screen/login_screen.dart';
import 'auth/services/auth_service.dart';
import 'auth/services/friend_request_service.dart';
import 'main_file_components/app_routes.dart';
import 'main_file_components/bloc_providers.dart';
import 'main_screens/home_screen/cut_loose/auth/cut_loose_cubit.dart';
import 'main_screens/home_screen/cut_loose/auth/firebase_service.dart';
import 'main_screens/home_screen/note/auth/note_cubit.dart';
import 'main_screens/home_screen/note/auth/note_service.dart';
import 'main_screens/home_screen/public_chat/const.dart';
import 'main_screens/home_screen/quiz/cubit/question_cubit.dart';
import 'main_screens/home_screen/quiz/cubit/quiz_cubit.dart';
import 'main_screens/home_screen/quiz/services/hint_service.dart';
import 'main_screens/home_screen/quiz/services/question_service.dart';
import 'main_screens/home_screen/quiz/services/quiz_service.dart';
import 'main_screens/home_screen/quiz/services/timer_service.dart';
import 'main_screens/profile/security/cubit/phone_auth_service.dart';
import 'main_screens/profile/security/cubit/phone_number_cubit.dart';
import 'main_screens/profile/security/cubit/two_factor_auth_cubit.dart';
import 'main_screens/profile/security/cubit/two_factor_auth_service.dart';
import 'main_screens/profile/security/password/cubit/password_management_cubit.dart';
import 'main_screens/profile/security/password/services/password_management_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );

  final client = StreamChatClient(
    streamApiKey,
    logLevel: Level.INFO,
  );

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final StreamChatClient client;

  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(AuthService())),
        BlocProvider(create: (context) => FriendRequestCubit(FriendRequestService())),
        BlocProvider(create: (context) => PhoneNumberCubit(PhoneAuthService())),
        BlocProvider(create: (context) => NoteCubit(NoteService())),
        BlocProvider(create: (context) => CutLooseCubit(FirebaseService())),
        BlocProvider(create: (context) => QuizCubit(quizService: QuizService())),
        BlocProvider(create: (context) => QuestionCubit(
          questionService: QuestionService(),
          hintService: HintService(),
          timerService: TimerService(),
        )),
        BlocProvider(create: (context) => TwoFactorAuthCubit(TwoFactorAuthService())),
        BlocProvider(create: (context) => PasswordManagementCubit(PasswordManagementService())),
      ],
      child: MaterialApp(
        title: 'FreeRave',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreenWrapper(client: client),
        routes: getAppRoutes(client),
        supportedLocales: const [
          Locale('en', 'US'), // Add any other supported locales
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}

// A wrapper for LoginScreen that provides StreamChat only when needed
class LoginScreenWrapper extends StatelessWidget {
  final StreamChatClient client;

  const LoginScreenWrapper({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return StreamChat(
      client: client,
      child: const LoginScreen(),
    );
  }
}
