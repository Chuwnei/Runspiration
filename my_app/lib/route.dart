// import 'dart:js';

import 'dart:js';

import 'package:my_app/login/login.dart';
import 'package:my_app/login/signup.dart';
import 'package:my_app/checker.dart';
import 'package:my_app/userscreen.dart';
import 'package:my_app/runscreen.dart';
import 'package:my_app/profile.dart';

var routeHolder = {
  '/': (context) => Checker(),
  '/login': (context) => Login(),
  '/signup': (context) => SignUp(),
  '/homescreen': (context) => UserScreen(),
  '/runscreen': (context) => RunScreen(),
  '/profilescreen': (context) => ProfileScreen()
};
