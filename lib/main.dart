import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freerave/auth/cubit/auth_cubit.dart';
import 'package:freerave/auth/cubit/friend_request_cubit.dart';
import 'package:freerave/auth/cubit/phone_number_cubit.dart';
import 'package:freerave/cut_loose/auth/cut_loose_cubit.dart';
import 'package:freerave/note/auth/note_cubit.dart';
import 'package:freerave/note/auth/note_service.dart';
import 'package:freerave/quiz/cubit/quiz_cubit.dart';
import 'package:freerave/quiz/services/quiz_service.dart';
import 'package:freerave/screens/login_screen.dart';
import 'package:freerave/firebase_options.dart';
import 'package:freerave/screens/main_navigation.dart';
import 'package:freerave/screens/register_screen.dart';

import 'auth/services/auth_service.dart';
import 'auth/services/friend_request_service.dart';
import 'auth/services/phone_auth_service.dart';
import 'cut_loose/auth/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(AuthService()),
        ),
        BlocProvider(
          create: (context) => FriendRequestCubit(FriendRequestService()),
        ),
        BlocProvider(
          create: (context) => PhoneNumberCubit(PhoneAuthService()),
        ),
        BlocProvider(
          create: (context) => NoteCubit(NoteService()),
        ),
        BlocProvider(
          create: (context) => CutLooseCubit(FirebaseService()),
        ),
        BlocProvider(
          create: (context) => QuizCubit(quizService: QuizService()),
        ),
      ],
      child: MaterialApp(
        home: const LoginScreen(),
        routes: {
          '/home': (context) => const MainNavigation(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
        },
      ),
    );
  }
}
