import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_web/firebase_auth_web.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

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