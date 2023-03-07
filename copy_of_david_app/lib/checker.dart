import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:david_app/backend_services/auth.dart';
import 'package:flutter/material.dart';
import 'package:david_app/login/login.dart';
import 'package:david_app/userscreen.dart';
import 'package:david_app/shared/loading.dart';
import 'size_config.dart';

class Checker extends StatelessWidget {
  const Checker({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
