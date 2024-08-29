import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freerave/auth/cubit/auth_state.dart';
import 'package:freerave/auth/services/friend_request_service.dart';

class FriendRequestCubit extends Cubit<AuthState> {
  final FriendRequestService _authService;

  FriendRequestCubit(this._authService) : super(AuthInitial());

  Future<void> acceptFriendRequest(
      String currentUserId, String senderUserId) async {
    await _handleFriendRequest(
        () => _authService.acceptFriendRequest(currentUserId, senderUserId),
        'Friend request accepted successfully.',
        'Failed to accept friend request');
  }

  Future<void> declineFriendRequest(
      String currentUserId, String senderUserId) async {
    await _handleFriendRequest(
        () => _authService.declineFriendRequest(currentUserId, senderUserId),
        'Friend request declined successfully.',
        'Failed to decline friend request');
  }

  Future<void> sendFriendRequest(
      String currentUserId, String friendUserId) async {
    await _handleFriendRequest(
        () => _authService.sendFriendRequest(currentUserId, friendUserId),
        'Friend request sent successfully.',
        'Failed to send friend request');
  }

  Future<void> fetchPendingFriendRequests(String currentUserId) async {
    try {
      emit(AuthLoading());
      final pendingRequests =
          await _authService.getPendingFriendRequests(currentUserId);
      if (pendingRequests.isEmpty) {
        emit(AuthError('No pending friend requests.'));
      } else {
        emit(AuthPendingFriendRequestsLoaded(pendingRequests));
        emit(AuthFriendRequestCount(pendingRequests.length));
      }
    } catch (e) {
      emit(AuthError(
          'Failed to fetch pending friend requests: ${e.toString()}'));
    }
  }

  Future<void> fetchUserData() async {
    try {
      emit(AuthLoading());
      final user = await _authService.getUserData();
      emit(AuthLoaded(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> fetchFriendList(String currentUserId) async {
    try {
      emit(AuthLoading());
      final friends = await _authService.getFriendList(currentUserId);
      emit(AuthFriendListLoaded(friends));
    } catch (e) {
      emit(AuthError('Failed to fetch friend list: ${e.toString()}'));
    }
  }

  Future<void> _handleFriendRequest(Future<void> Function() action,
      String successMessage, String errorMessage) async {
    try {
      emit(AuthLoading());
      await action();
      emit(AuthSuccess(successMessage));
    } on NetworkException {
      emit(AuthNetworkError(
          'Network error: Please check your internet connection.'));
    } catch (e) {
      emit(AuthError('$errorMessage: ${e.toString()}'));
    }
  }

  Future<void> cancelFriendRequest(
      String currentUserId, String friendUserId) async {
    await _handleFriendRequest(
        () => _authService.cancelFriendRequest(currentUserId, friendUserId),
        'Friend request cancelled successfully.',
        'Failed to cancel friend request');
  }

  Future<void> blockUser(String currentUserId, String userId) async {
    await _handleFriendRequest(
        () => _authService.blockUser(currentUserId, userId),
        'User blocked successfully.',
        'Failed to block user');
  }

  Future<void> unblockUser(String currentUserId, String userId) async {
    await _handleFriendRequest(
        () => _authService.unblockUser(currentUserId, userId),
        'User unblocked successfully.',
        'Failed to unblock user');
  }

  Future<void> unfriend(String currentUserId, String friendUserId) async {
    await _handleFriendRequest(
        () => _authService.unfriend(currentUserId, friendUserId),
        'Unfriended successfully.',
        'Failed to unfriend');
  }

  Future<void> fetchFriendshipAnniversaries(String currentUserId) async {
    try {
      emit(AuthLoading());
      final anniversaries =
          await _authService.getFriendshipAnniversaries(currentUserId);
      emit(AuthFriendshipAnniversaryLoaded(anniversaries));
    } catch (e) {
      emit(AuthError(
          'Failed to fetch friendship anniversaries: ${e.toString()}'));
    }
  }

  Future<void> sendFriendRequestNotification(
      String currentUserId, String friendUserId) async {
    await _handleFriendRequest(
        () => _authService.sendFriendRequestNotification(
            currentUserId, friendUserId),
        'Friend request notification sent.',
        'Failed to send friend request notification');
  }

  Future<void> fetchFriendshipDuration(
      String currentUserId, String friendUserId) async {
    try {
      emit(AuthLoading());
      final duration =
          await _authService.getFriendshipDuration(currentUserId, friendUserId);
      emit(AuthFriendshipAnniversaryLoaded({friendUserId: duration}));
    } catch (e) {
      emit(AuthError('Failed to fetch friendship duration: ${e.toString()}'));
    }
  }
}
