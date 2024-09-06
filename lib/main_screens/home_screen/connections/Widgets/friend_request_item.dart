import 'package:flutter/material.dart';
import '../models/user_model.dart';

class FriendRequestItem extends StatelessWidget {
  final UserModel user;
  final String status;

  const FriendRequestItem({super.key, required this.user, required this.status});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: user.photoUrl.isNotEmpty
          ? CircleAvatar(backgroundImage: NetworkImage(user.photoUrl))
          : const CircleAvatar(child: Icon(Icons.person)),
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: Text(
        _getStatusText(status),
        style: TextStyle(
          color: _getStatusColor(status),
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'Accepted':
        return 'Accepted';
      case 'Pending':
        return 'Pending';
      default:
        return 'Declined';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Accepted':
        return Colors.green;
      case 'Pending':
        return Colors.yellow;
      default:
        return Colors.red;
    }
  }
}
