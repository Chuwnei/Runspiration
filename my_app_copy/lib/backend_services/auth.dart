import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final userstream = FirebaseAuth.instance.authStateChanges(); //listeners
  final user = FirebaseAuth.instance.currentUser;
}
