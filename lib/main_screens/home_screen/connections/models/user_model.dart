import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final String bio;
  final String location;
  final List<Friend> friends;
  final List<String> blockedUsers;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.bio,
    required this.location,
    required this.friends,
    required this.blockedUsers,
  });

  // Factory constructor to create a UserModel from a Firestore document
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;  // Handle potential null here
    // print('data i want to know: $data');
    if (data == null) {
      // Handle the case where the document data is null
      // print('Document data is null for doc ID: ${doc.id}');
      return UserModel(
        uid: doc.id,
        name: '',
        email: '',
        photoUrl: '',
        bio: '',
        location: '',
        friends: [],
        blockedUsers: [],
      );
    }

    // print('UserModel.fromDocument data: $data');
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      bio: data['bio'] ?? '',
      location: data['location'] ?? '',
      friends: (data['friends'] as List<dynamic>? ?? []).map((friend) => Friend.fromMap(friend)).toList(),
      blockedUsers: List<String>.from(data['blockedUsers'] ?? []),
    );
  }

  // Method to convert a UserModel to a map for Firestore
  Map<String, dynamic> toMap() {
    final data = {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'bio': bio,
      'location': location,
      'friends': friends.map((friend) => friend.toMap()).toList(),
      'blockedUsers': blockedUsers,
    };
    // print('UserModel.toMap data: $data');
    return data;
  }

  // Method to update the profile picture
  UserModel updateProfilePicture(String newPhotoUrl) {
    return UserModel(
      uid: uid,
      name: name,
      email: email,
      photoUrl: newPhotoUrl,
      bio: bio,
      location: location,
      friends: friends,
      blockedUsers: blockedUsers,
    );
  }

  // Method to update the bio
  UserModel updateBio(String newBio) {
    return UserModel(
      uid: uid,
      name: name,
      email: email,
      photoUrl: photoUrl,
      bio: newBio,
      location: location,
      friends: friends,
      blockedUsers: blockedUsers,
    );
  }

  // Method to update the location
  UserModel updateLocation(String newLocation) {
    return UserModel(
      uid: uid,
      name: name,
      email: email,
      photoUrl: photoUrl,
      bio: bio,
      location: newLocation,
      friends: friends,
      blockedUsers: blockedUsers,
    );
  }
}

class Friend {
  final String name;
  final DateTime addedTime;
  final String status; // e.g., pending, accepted

  Friend({
    required this.name,
    required this.addedTime,
    this.status = 'pending',
  });

  // Factory constructor to create a Friend from a map
  factory Friend.fromMap(Map<String, dynamic> data) {
    return Friend(
      name: data['name'] ?? '',
      addedTime: (data['addedTime'] as Timestamp?)?.toDate() ?? DateTime.now(),  // Handle potential null here
      status: data['status'] ?? 'pending',
    );
  }

  // Method to convert a Friend to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'addedTime': Timestamp.fromDate(addedTime),
      'status': status,
    };
  }

  // Method to calculate the duration of the friendship
  Duration getFriendshipDuration() {
    return DateTime.now().difference(addedTime);
  }

  // Method to get a formatted string for the friendship duration
  String getFormattedFriendshipDuration() {
    final duration = getFriendshipDuration();
    final years = duration.inDays ~/ 365;
    final months = (duration.inDays % 365) ~/ 30;
    final days = (duration.inDays % 365) % 30;
    return '$years years, $months months, $days days';
  }
}
