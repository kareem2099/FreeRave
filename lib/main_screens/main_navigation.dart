import 'package:flutter/material.dart';
import 'package:freerave/screens/chat_screen.dart';
import 'package:freerave/screens/home_screen.dart';
import 'package:freerave/screens/settings_screen.dart';

import '../profile/screen/profile_screen.dart';
import '../widget/bottom_navigation_bar.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  MainNavigationState createState() => MainNavigationState();
}

class MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    const ChatScreen(),
    const SettingsScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],  // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedFontSize: 14.0,
        unselectedFontSize: 14.0,
        onTap: _onItemTapped,
        items: bottomNavItems,  // Use the items from the separate file
      ),
    );
  }
}
