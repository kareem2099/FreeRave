import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../connections/models/user_model.dart';
import '../cubit/auth_state.dart';

class FriendRequestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<void> sendFriendRequest(
      String currentUserId, String friendUserId) async {
    try {
      final userRef = _firestore.collection('users').doc(currentUserId);
      final friendRef = _firestore.collection('users').doc(friendUserId);

      await _firestore.runTransaction((transaction) async {
        final userSnapshot = await transaction.get(userRef);
        final friendSnapshot = await transaction.get(friendRef);

        if (userSnapshot.exists && friendSnapshot.exists) {
          transaction.update(userRef, {
            'friendRequests': FieldValue.arrayUnion([friendUserId])
          });
          transaction.update(friendRef, {
            'friendRequests': FieldValue.arrayUnion([currentUserId])
          });
        }
      });
    } on SocketException {
      throw Exception('Network error: Please check your internet connection.');
    } catch (e) {
      throw Exception('Failed to send friend request: ${e.toString()}');
    }
  }

  Future<List<FriendRequest>> getPendingFriendRequests(String userId) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      final userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        final data = userSnapshot.data() as Map<String, dynamic>;
        final friendRequests = data['friendRequests'] as List<dynamic>;
        return friendRequests.map((id) => FriendRequest(id as String)).toList();
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      throw Exception('Failed to get pending friend requests: ${e.toString()}');
    }
  }

  Future<void> declineFriendRequest(
      String currentUserId, String senderUserId) async {
    try {
      final userRef = _firestore.collection('users').doc(currentUserId);
      await userRef.update({
        'friendRequests': FieldValue.arrayRemove([senderUserId]),
      });
    } catch (e) {
      throw Exception('Failed to decline friend request: ${e.toString()}');
    }
  }

  Future<void> acceptFriendRequest(
      String currentUserId, String senderUserId) async {
    try {
      final userRef = _firestore.collection('users').doc(currentUserId);
      final senderRef = _firestore.collection('users').doc(senderUserId);

      await _firestore.runTransaction((transaction) async {
        final userSnapshot = await transaction.get(userRef);
        final senderSnapshot = await transaction.get(senderRef);

        if (userSnapshot.exists && senderSnapshot.exists) {
          transaction.update(userRef, {
            'friendRequests': FieldValue.arrayRemove([senderUserId]),
            'friends': FieldValue.arrayUnion([senderUserId]),
            'friendSince': FieldValue.serverTimestamp()
          });
          transaction.update(senderRef, {
            'friends': FieldValue.arrayUnion([currentUserId]),
            'friendSince': FieldValue.serverTimestamp()
          });
        }
      });
    } catch (e) {
      throw Exception('Failed to accept friend request: ${e.toString()}');
    }
  }

  Future<List<UserModel>> getFriendList(String userId) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      final userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        final data = userSnapshot.data() as Map<String, dynamic>;
        final friends = data['friends'] as List<dynamic>;
        List<UserModel> friendList = [];
        for (var friendId in friends) {
          final friendSnapshot =
              await _firestore.collection('users').doc(friendId).get();
          if (friendSnapshot.exists) {
            friendList.add(UserModel.fromDocument(friendSnapshot));
          }
        }
        return friendList;
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      throw Exception('Failed to get friend list: ${e.toString()}');
    }
  }

  Future<UserModel> getUserData() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      final DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();
      return UserModel.fromDocument(doc);
    }
    throw Exception("User not logged in");
  }


  Future<Duration> getFriendshipDuration(
      String currentUserId, String friendUserId) async {
    try {
      final userRef = _firestore.collection('users').doc(currentUserId);
      final userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        final data = userSnapshot.data() as Map<String, dynamic>;
        final friendSince = data['friendSince'] as Timestamp;
        return DateTime.now().difference(friendSince.toDate());
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      throw Exception('Failed to get friendship duration: ${e.toString()}');
    }
  }

  Future<void> sendFriendRequestNotification(
      String currentUserId, String friendUserId) async {
    try {
      final userRef = _firestore.collection('users').doc(currentUserId);
      final friendRef = _firestore.collection('users').doc(friendUserId);

      await _firestore.runTransaction((transaction) async {
        final userSnapshot = await transaction.get(userRef);
        final friendSnapshot = await transaction.get(friendRef);

        if (userSnapshot.exists && friendSnapshot.exists) {
          // Assuming you have a notifications collection
          final notificationRef = _firestore.collection('notifications').doc();
          await notificationRef.set({
            'from': currentUserId,
            'to': friendUserId,
            'message': 'You have a new friend request',
            'timestamp': FieldValue.serverTimestamp(),
          });
        }
      });
    } catch (e) {
      throw Exception(
          'Failed to send friend request notification: ${e.toString()}');
    }
  }

  Future<List<UserModel>> searchFriends(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromDocument(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to search friends: ${e.toString()}');
    }
  }

  Future<DocumentSnapshot> _getUserSnapshot(String userId) async {
    final userRef = _firestore.collection('users').doc(userId);
    final userSnapshot = await userRef.get();
    if (!userSnapshot.exists) {
      throw UserNotFoundException("User not found");
    }
    return userSnapshot;
  }

  Future<void> cancelFriendRequest(
      String currentUserId, String friendUserId) async {
    try {
      final userRef = _firestore.collection('users').doc(currentUserId);
      final friendRef = _firestore.collection('users').doc(friendUserId);

      await _firestore.runTransaction((transaction) async {
        final userSnapshot = await transaction.get(userRef);
        final friendSnapshot = await transaction.get(friendRef);

        if (userSnapshot.exists && friendSnapshot.exists) {
          transaction.update(userRef, {
            'friendRequests': FieldValue.arrayRemove([friendUserId])
          });
          transaction.update(friendRef, {
            'friendRequests': FieldValue.arrayRemove([currentUserId])
          });
        }
      });
    } on SocketException {
      throw NetworkException(
          'Network error: Please check your internet connection.');
    } catch (e) {
      throw Exception('Failed to cancel friend request: ${e.toString()}');
    }
  }

  Future<void> blockUser(String currentUserId, String userId) async {
    try {
      final userRef = _firestore.collection('users').doc(currentUserId);
      await userRef.update({
        'blockedUsers': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      throw Exception('Failed to block user: ${e.toString()}');
    }
  }

  Future<void> unblockUser(String currentUserId, String userId) async {
    try {
      final userRef = _firestore.collection('users').doc(currentUserId);
      await userRef.update({
        'blockedUsers': FieldValue.arrayRemove([userId]),
      });
    } catch (e) {
      throw Exception('Failed to unblock user: ${e.toString()}');
    }
  }

  Future<Map<String, Duration>> getFriendshipAnniversaries(
      String userId) async {
    try {
      final userSnapshot = await _getUserSnapshot(userId);
      final data = userSnapshot.data() as Map<String, dynamic>;
      final friends = data['friends'] as List<dynamic>;
      final friendshipDurations = <String, Duration>{};

      for (var friendId in friends) {
        final friendSnapshot = await _getUserSnapshot(friendId as String);
        final friendData = friendSnapshot.data() as Map<String, dynamic>;
        final friendSince = friendData['friendSince'] as Timestamp;
        final duration = DateTime.now().difference(friendSince.toDate());
        friendshipDurations[friendId] = duration;
      }

      return friendshipDurations;
    } catch (e) {
      throw Exception(
          'Failed to get friendship anniversaries: ${e.toString()}');
    }
  }

  Future<void> unfriend(String currentUserId, String friendUserId) async {
    try {
      final userRef = _firestore.collection('users').doc(currentUserId);
      final friendRef = _firestore.collection('users').doc(friendUserId);

      await _firestore.runTransaction((transaction) async {
        final userSnapshot = await transaction.get(userRef);
        final friendSnapshot = await transaction.get(friendRef);

        if (userSnapshot.exists && friendSnapshot.exists) {
          transaction.update(userRef, {
            'friends': FieldValue.arrayRemove([friendUserId])
          });
          transaction.update(friendRef, {
            'friends': FieldValue.arrayRemove([currentUserId])
          });
        }
      });
    } on SocketException {
      throw NetworkException(
          'Network error: Please check your internet connection.');
    } catch (e) {
      throw Exception('Failed to unfriend: ${e.toString()}');
    }

    Future<Duration> getFriendshipDuration(
        String currentUserId, String friendUserId) async {
      try {
        final userRef = _firestore.collection('users').doc(currentUserId);
        final userSnapshot = await userRef.get();

        if (userSnapshot.exists) {
          final data = userSnapshot.data() as Map<String, dynamic>;
          final friends = data['friends'] as List<dynamic>;

          if (friends.contains(friendUserId)) {
            final friendSince = data['friendSince'] as Timestamp;
            return DateTime.now().difference(friendSince.toDate());
          } else {
            throw Exception("Friend not found in user's friend list");
          }
        } else {
          throw Exception("User not found");
        }
      } catch (e) {
        throw Exception('Failed to get friendship duration: ${e.toString()}');
      }
    }
  }
}
