import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options1.dart';
import 'package:runspiration/route.dart';
import 'firebase_options.dart';
// import 'package:google_fonts/google_fonts.dart';

/*
Runspiration
https://doc-hosting.flycricket.io/runspiration-privacy-policy/4b939298-94ff-4adf-bba2-a9dd76f32436/privacy
https://doc-hosting.flycricket.io/runspiration-terms-of-use/18f24006-a703-46df-b6cd-cc7bf92df123/terms


Promotional Text: 
Discover Runspiration, the game-changing running app that fuels your fitness journey! 
Set ambitious goals, unlock achievements, 
and flaunt your success with eye-catching profile pictures and borders. 
Crush your daily targets and indulge in our thrilling daily spin, 
earning exclusive rewards to keep you motivated. 
Transform your runs and find your inspiration with Runspiration today!

App Description:
Introducing Runspiration, your ultimate running companion! 
Set up personalized goals and track your achievements, while showcasing your progress with customizable profile pictures and borders.
Stay motivated with our daily spin feature, rewarding you with exciting prizes after completing your goals. 
Unleash your potential and get inspired with Runspiration!

 */

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> firebaseInitialization = Firebase.initializeApp(
    // name: "Runspiration",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebaseInitialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // return Text(snapshot.error.toString());
          print(snapshot.error);
          return Container();
        } else if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            routes: routeHolder,
            theme: ThemeData(
              textTheme: const TextTheme(
                  displayLarge: TextStyle(
                fontSize: 50,
                color: Colors.blue,
              )),
              scaffoldBackgroundColor: const Color.fromARGB(255, 245, 245, 245),
            ),
          );
        }
        return Container();
      },
    );
    // return MaterialApp(
    //   routes: RouteHolder,
    // );
  }
}
