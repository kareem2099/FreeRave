import 'package:flutter/material.dart';
import '../models/user_model.dart';

class FriendListItem extends StatelessWidget {
  final UserModel user;

  const FriendListItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: user.photoUrl.isNotEmpty
          ? CircleAvatar(backgroundImage: NetworkImage(user.photoUrl))
          : const CircleAvatar(child: Icon(Icons.person)),
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: IconButton(
        icon: const Icon(Icons.chat),
        onPressed: () {
          // Logic to initiate chat with friend
        },
      ),
    );
  }
}
