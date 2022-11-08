// import 'dart:js';

import 'package:my_app/login/login.dart';
import 'package:my_app/login/signup.dart';
import 'package:my_app/checker.dart';

var RouteHolder = {
  '/': (context) => Checker(),
  '/login': (context) => Login(),
  '/signup': (context) => SignUp(),
};
