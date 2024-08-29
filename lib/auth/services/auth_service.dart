import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get user => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  // Helper method to save user data in Firestore
  Future<void> _saveUserData(User user, Map<String, String?> userData) async {
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    await userRef.set({
      'uid': user.uid,
      'name': userData['name'],
      'email': userData['email'],
      'photoUrl': userData['photoUrl'],
      'friendRequests': [],
      'friends': [],
    });
  }

  Future<void> signInWithEmail(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    await _saveUserData(userCredential.user!, {
      'name': userCredential.user?.displayName,
      'email': userCredential.user?.email,
      'photoUrl': userCredential.user?.photoURL,
    });
  }

  Future<void> registerWithEmail(String email, String password) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _saveUserData(userCredential.user!, {
      'name': userCredential.user?.displayName,
      'email': userCredential.user?.email,
      'photoUrl': userCredential.user?.photoURL,
    });
    await userCredential.user?.sendEmailVerification();
  }

  Future<Map<String, String?>> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await _auth.signInWithCredential(credential);

    final user = userCredential.user;
    final userData = {
      'name': user?.displayName,
      'email': user?.email,
      'photoUrl': user?.photoURL,
    };
    // Save user data
    await _saveUserData(user!, userData);
    return userData;
  }

  Future<Map<String, String?>> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential credential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
    final userCredential = await _auth.signInWithCredential(credential);

    final user = userCredential.user;

    final dataToSave = {
      'name': user?.displayName,
      'email': user?.email,
      'photoUrl': user?.photoURL,
    };
    // Save user data
    await _saveUserData(user!, dataToSave);
    return dataToSave;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
  }

  Future<bool> isEmailVerified() async {
    final user = _auth.currentUser;
    await user?.reload();
    return user?.emailVerified ?? false;
  }


}
