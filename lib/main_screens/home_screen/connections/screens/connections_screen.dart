import 'package:flutter/material.dart';
import '../Widgets/drawer_widget.dart';
import 'search_friends_screen.dart';
import 'friend_requests_screen.dart';
import 'friends_list_screen.dart';

class ConnectionsScreen extends StatelessWidget {
  const ConnectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connections'),
      ),
      drawer: const DrawerWidget(),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ConnectionButton(
                    text: 'Search Friends',
                    screen: SearchFriendsScreen(),
                    icon: Icons.search,
                  ),
                  ConnectionButton(
                    text: 'Friend Requests',
                    screen: FriendRequestsScreen(),
                    icon: Icons.person_add,
                    notificationCount: 5, // Example notification count
                  ),
                  ConnectionButton(
                    text: 'My Friends List',
                    screen: FriendsListScreen(),
                    icon: Icons.list,
                  ),
                ],
              ),
            ),
            // Additional content can be added here
          ],
        ),
      ),
    );
  }
}

class ConnectionButton extends StatelessWidget {
  final String text;
  final Widget screen;
  final IconData icon;
  final int? notificationCount;

  const ConnectionButton({
    super.key,
    required this.text,
    required this.screen,
    required this.icon,
    this.notificationCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => screen),
              );
            },
            icon: Icon(icon),
            label: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          if (notificationCount != null && notificationCount! > 0)
            Positioned(
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
                child: Text(
                  '$notificationCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
