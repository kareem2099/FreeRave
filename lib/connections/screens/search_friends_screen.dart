import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgets/user_tile.dart';

class SearchFriendsScreen extends StatefulWidget {
  const SearchFriendsScreen({super.key});

  @override
  SearchFriendsScreenState createState() => SearchFriendsScreenState();
}

class SearchFriendsScreenState extends State<SearchFriendsScreen> {
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Friends'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('name', isGreaterThanOrEqualTo: searchQuery)
                  .where('name', isLessThanOrEqualTo: '$searchQuery\uf8ff')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching data. Please try again later.'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No users found.'));
                }

                // Filter out the current user and show only friends
                final users = snapshot.data!.docs.where((doc) {
                  final userData = doc.data() as Map<String, dynamic>;
                  return doc.id != currentUserId; // Exclude current user
                }).map((doc) {
                  final userData = doc.data() as Map<String, dynamic>;
                  return UserTile(
                    userData: userData,
                    userId: doc.id,
                    isCurrentUser: doc.id == currentUserId, // Check if it's the current user
                  );
                }).toList();

                return ListView(children: users);
              },
            ),
          ),
        ],
      ),
    );
  }
}
