import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class FriendRequestsScreen extends StatefulWidget {
  const FriendRequestsScreen({super.key});

  @override
  FriendRequestsScreenState createState() => FriendRequestsScreenState();
}

class FriendRequestsScreenState extends State<FriendRequestsScreen> {
  List<DocumentSnapshot> _requests = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend Requests'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('friend_requests')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
                child: Text(
                    'Failed to load friend requests. Please try again later.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text('No friend requests at the moment.'));
          }

          _requests = snapshot.data!.docs;

          return ListView(
            children: _requests.map((doc) {
              return _buildFriendRequestItem(context, doc);
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildFriendRequestItem(BuildContext context, DocumentSnapshot doc) {
    final userData = doc.data() as Map<String, dynamic>;
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
            Text('Status: ${userData['status'] ?? 'unknown'}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () =>
                  _handleFriendRequest(context, doc.id, true, user),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () =>
                  _handleFriendRequest(context, doc.id, false, user),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleFriendRequest(BuildContext context, String docId,
      bool accept, UserModel user) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      if (accept) {
        // Move to friends collection
        await FirebaseFirestore.instance.collection('friends').add(
            user.toMap());

        // Update status in friend_requests
        await FirebaseFirestore.instance.collection('friend_requests').doc(
            docId).delete();
      } else {
        // Update status to declined in friend_requests
        await FirebaseFirestore.instance.collection('friend_requests').doc(
            docId).update({'status': 'declined'});
      }

      // Remove the request from the list
      setState(() {
        _requests.removeWhere((doc) => doc.id == docId);
      });
      if (context.mounted) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(accept
              ? 'You are now friends!'
              : 'You have rejected this friend request.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(
              'Failed to update friend request: ${e.toString()}')),
        );
      }
    }
  }
}