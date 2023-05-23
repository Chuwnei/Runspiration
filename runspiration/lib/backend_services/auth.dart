import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runspiration/shared/singleton.dart';

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

  Future signin(email, password) async {
    try {
      //Attempt to sign in a user with provided email and password
      final accountLoginAttempt = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      //updateData();
      return accountLoginAttempt;
    } on FirebaseAuthException catch (error) {
      //Catch and log any errors that occur during the sign-in process
      print(error.message);
    }
  }

  Future signup(userEmail, password) async {
    try {
      //Create a new user with the provided email and password
      final accountCreationAttempt = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: userEmail, password: password);
      User? user = accountCreationAttempt.user;
      final docData = {
        "currency": 0,
        "spins": 0,
        "goal_for_running": 2,
        "progress_in_km": 0,
        "sessions": 0,
        "total_km": 0,
        "profile": "default.png",
        "lastOnline": Timestamp.now(),
        "lastEdit": DateTime.now().subtract(const Duration(hours: 24)),
        "lastReward": DateTime.now().subtract(const Duration(hours: 24)),
      };
      final achievements = {
        "active": ["ID0", "empty", "empty"],
        "unlocked": ["ID0"]
      };
      docData["achievements"] = achievements;
      final borders = {
        "active": "ID1",
        "unlocked": ["ID1"],
      };
      docData["borders"] = borders;
      FirebaseFirestore.instance
          .collection("user_data")
          .doc(user?.uid)
          .set(docData);
      return 1;
      //updateData();
    } on FirebaseAuthException catch (error) {
      //Catch and log any errors that occur during the sign-up process
      print(error.message);
    }
  }

  Future signout() async {
    //Sign out the current user
    await FirebaseAuth.instance.signOut();
    return null;
  }
}
