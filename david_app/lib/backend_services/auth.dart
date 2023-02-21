import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:david_app/shared/singleton.dart';

class Authentication {
  final userstream = FirebaseAuth.instance
      .authStateChanges(); //Stream to listen for changes in the authentication state of the current user
  final user = FirebaseAuth
      .instance.currentUser; //Reference to the current user if signed in

  Singleton _singleton = Singleton();

  Future<void> updateData() async {
    var document = FirebaseFirestore.instance
        .collection("user_data")
        .doc(user!.uid)
        .get()
        .then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        print("Got the save data! Their info is $data");
        _singleton.userData = data;
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  Future<void> signin(email, password) async {
    try {
      //Attempt to sign in a user with provided email and password
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      //updateData();
    } on FirebaseAuthException catch (error) {
      //Catch and log any errors that occur during the sign-in process
      print(error.message);
    }
  }

  Future<void> signup(user_email, password) async {
    try {
      //Create a new user with the provided email and password
      final accountCreationAttempt = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user_email, password: password);
      User? user = accountCreationAttempt.user;
      FirebaseFirestore.instance.collection("user_data").doc(user?.uid).set({
        "currency": 0,
        "goal_for_running": 0,
        "progress_in_km": 0,
        "sessions": 0,
        "total_km": 0,
        //"total_time": 0,
      });
      //updateData();
    } on FirebaseAuthException catch (error) {
      //Catch and log any errors that occur during the sign-up process
      print(error.message);
    }
  }

  Future<void> signout() async {
    //Sign out the current user
    await FirebaseAuth.instance.signOut();
  }
}
