import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:my_app/backend_services/auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/login/login.dart';
import 'package:my_app/userscreen.dart';
import 'package:my_app/shared/loading.dart';

class Checker extends StatelessWidget {
  const Checker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Authentication().userstream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // loading state
            return const LoadingScreen();
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.hasData) {
            // if the user is already logged in
            // return const Home();
            Authentication().updateData();
            return UserScreen(); // centual page
          } else {
            return Login();
          }
        });
    return Login();
  }
}
