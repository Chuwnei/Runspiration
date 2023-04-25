import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCp-2EvI-zUWUS1ZU7lpW19kZFD7MGgKEE",
            authDomain: "runspiration-b81aa.firebaseapp.com",
            projectId: "runspiration-b81aa",
            storageBucket: "runspiration-b81aa.appspot.com",
            messagingSenderId: "743298458397",
            appId: "1:743298458397:web:9e55be537b8fcd99cfb7f4",
            measurementId: "G-S6MFC1JBQ1"));
  } else {
    await Firebase.initializeApp();
  }
}
