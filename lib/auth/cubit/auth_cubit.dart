import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial()) {
    _authService.user.listen((user) {
      if (user != null) {
        // print('User data received: $user');
        emit(AuthAuthenticated(user, {}));
      } else {
        // print('No user data received');
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      emit(AuthLoading());
      await _authService.signInWithEmail(email, password);
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> registerWithEmail(String email, String password) async {
    try {
      emit(AuthLoading());
      await _authService.registerWithEmail(email, password);
      await Future.delayed(const Duration(seconds: 3));
      emit(AuthRegistrationSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(AuthLoading());
      final userData = await _authService.signInWithGoogle();
      // print('Google sign-in user data: $userData');
      emit(AuthAuthenticated(_authService.currentUser!,
          userData)); // Or pass userData to the state
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      emit(AuthLoading());
      final userData = await _authService.signInWithFacebook();
      // print('Facebook sign-in user data: $userData');
      emit(AuthAuthenticated(_authService.currentUser!,
          userData)); // Or pass userData to the state
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    emit(AuthUnauthenticated());
  }
}
