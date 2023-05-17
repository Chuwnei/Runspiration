import 'package:runspiration/initialization.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:runspiration/backend_services/auth.dart';
import 'package:flutter/material.dart';
import 'package:runspiration/login/login.dart';
import 'package:runspiration/userscreen.dart';
import 'package:runspiration/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'size_config.dart';

class Checker extends StatelessWidget {
  const Checker({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    User? user = Authentication().user;
    if (user == null) {
      return Login();
    } else {
      // TODO: email verification
      // Authentication().verifyEmail().then((value) {
      //   if (value != null) {
      //     print("The user is verified!");
      //   } else {
      //     print("The user is not verified!");
      //   }
      // });

      return Initialization();
    }

    // return StreamBuilder(
    //     stream: Authentication().userstream,
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         // loading state
    //         return const LoadingScreen();
    //       }
    //       if (snapshot.hasError) {
    //         return Text(snapshot.error.toString());
    //       }
    //       if (snapshot.hasData) {
    //         // if the user is already logged in
    //         // return const Home();
    //         Authentication().updateData();
    //         return UserScreen(); // centual page
    //       } else {
    //         return Login();
    //       }
    //     });
    // return Login();
  }
}
