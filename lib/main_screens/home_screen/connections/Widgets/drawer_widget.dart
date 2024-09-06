import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/cubit/auth_state.dart';
import '../../auth/cubit/friend_request_cubit.dart';
import '../models/user_model.dart';
import 'friend_list_item.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<FriendRequestCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoaded) {
            final friends = state.userModel.friends;
            if (friends.isEmpty) {
              return const Center(child: Text('No friends found'));
            }
            return ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                final user = UserModel(
                  uid: '',
                  name: friend.name,
                  email: '',
                  bio: '',
                  location: '',
                  blockedUsers: [],
                  photoUrl: '',
                  friends: [],
                );
                return FriendListItem(user: user);
              },
            );
          } else if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuthError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('Error loading friends'));
          }
        },
      ),
    );
  }
}
