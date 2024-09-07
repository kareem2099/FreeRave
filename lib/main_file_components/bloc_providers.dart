import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freerave/auth/cubit/auth_cubit.dart';
import 'package:freerave/auth/cubit/friend_request_cubit.dart';
import 'package:freerave/main_screens/home_screen/cut_loose/auth/cut_loose_cubit.dart';
import 'package:freerave/main_screens/home_screen/note/auth/note_cubit.dart';
import 'package:freerave/main_screens/home_screen/quiz/cubit/question_cubit.dart';
import 'package:freerave/main_screens/home_screen/quiz/cubit/quiz_cubit.dart';
import 'package:freerave/main_screens/profile/security/cubit/phone_number_cubit.dart';
import 'package:freerave/main_screens/profile/security/cubit/two_factor_auth_cubit.dart';
import 'package:freerave/main_screens/profile/security/password/cubit/password_management_cubit.dart';

import '../auth/services/auth_service.dart';
import '../auth/services/friend_request_service.dart';
import '../main_screens/home_screen/cut_loose/auth/firebase_service.dart';
import '../main_screens/home_screen/note/auth/note_service.dart';
import '../main_screens/home_screen/quiz/services/hint_service.dart';
import '../main_screens/home_screen/quiz/services/question_service.dart';
import '../main_screens/home_screen/quiz/services/quiz_service.dart';
import '../main_screens/home_screen/quiz/services/timer_service.dart';
import '../main_screens/profile/security/cubit/phone_auth_service.dart';
import '../main_screens/profile/security/cubit/two_factor_auth_service.dart';
import '../main_screens/profile/security/password/services/password_management_service.dart';



List<BlocProvider> getBlocProviders() {
  return [
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
  ];
}
