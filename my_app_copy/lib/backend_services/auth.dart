import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final userstream = FirebaseAuth.instance.authStateChanges(); //listeners
  final user = FirebaseAuth.instance.currentUser;

  Future<void> signin(email, password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      // TODO
    }
  }

  Future<void> signup(user_email, password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: user_email, password: password);
    } on FirebaseAuthException catch (error) {
      // TODO
    }
  }

  Future<void> signout() async {
    await FirebaseAuth.instance.signOut();
  }
}
