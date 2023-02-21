import 'package:my_app/login/login.dart';
import 'package:my_app/login/signup.dart';
import 'package:my_app/checker.dart';
import 'package:my_app/userscreen.dart';
import 'package:my_app/runscreen.dart';
import 'package:my_app/profile.dart';
import 'initialization.dart';
import 'customizationScreen.dart';

var routeHolder = {
  '/': (context) => const Checker(),
  '/login': (context) => Login(),
  '/signup': (context) => const SignUp(),
  '/homescreen': (context) => UserScreen(),
  '/runscreen': (context) => const RunScreen(),
  '/profilescreen': (context) => const ProfileScreen(),
  '/initScreen': (context) => InitScreen(),
  '/customScreen': (context) => CustomScreen(),
};
