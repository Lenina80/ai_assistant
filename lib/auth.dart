import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

// Email Sign Up
Future<UserCredential?> signUpWithEmailAndPassword(String email, String password) async {
  try {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential;
  } catch (error) {
    print(error.toString());
    return null;
  }
}

// Email/Password Sign In
Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
  try {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential;
  } catch (error) {
    print(error.toString());
    return null;
  }
}

// Google Sign In
Future<UserCredential?> signInWithGoogle() async {
  final GoogleAuthProvider googleProvider = GoogleAuthProvider();
  final credential = await _auth.signInWithPopup(googleProvider);
  return credential;
}

// Check if user is signed in
bool isUserSignedIn() {
  return _auth.currentUser != null;
}

// Sign Out
Future<void> signOut() async {
  await _auth.signOut();
}