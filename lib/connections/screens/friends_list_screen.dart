import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../auth/services/friend_request_service.dart';
import '../models/user_model.dart';

class FriendsListScreen extends StatelessWidget {
  const FriendsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Friends'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('friends').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
                child: Text('Failed to load friends. Please try again later.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No friends found.'));
          }

          final friends = snapshot.data!.docs.map((doc) {
            return _buildFriendListItem(context, doc);
          }).toList();

          return ListView(children: friends);
        },
      ),
    );
  }

  Widget _buildFriendListItem(BuildContext context, DocumentSnapshot doc) {
    final user = UserModel.fromDocument(doc);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.photoUrl),
        ),
        title: Text(user.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.block, color: Colors.red),
              onPressed: () => _handleBlockUser(context, user.uid),
            ),
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () => _handleUnblockUser(context, user.uid),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleBlockUser(BuildContext context, String userId) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Block user logic
      await FriendRequestService().blockUser('currentUserId', userId);
      if(context.mounted) {
        // Close loading indicator
        Navigator.of(context).pop();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User blocked successfully')),
        );
      }
    } catch (e) {
      if(context.mounted) {
        // Close loading indicator
        Navigator.of(context).pop();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to block user: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _handleUnblockUser(BuildContext context, String userId) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Unblock user logic
      await FriendRequestService().unblockUser('currentUserId', userId);
      if(context.mounted) {
        // Close loading indicator
        Navigator.of(context).pop();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User unblocked successfully')),
        );
      }
    } catch (e) {
      if(context.mounted) {
        // Close loading indicator
        Navigator.of(context).pop();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to unblock user: ${e.toString()}')),
        );
      }
    }
  }
}
