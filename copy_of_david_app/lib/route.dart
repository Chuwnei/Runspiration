import 'package:david_app/login/login.dart';
import 'package:david_app/login/signup.dart';
import 'package:david_app/checker.dart';
import 'package:david_app/userscreen.dart';
import 'package:david_app/runscreen.dart';
import 'package:david_app/profile.dart';
import 'healthtest.dart';
import 'spinningWheel.dart';
import 'initialization.dart';
import 'achievements.dart';

var routeHolder = {
  '/': (context) => const Checker(),
  '/login': (context) => Login(),
  '/signup': (context) => const SignUp(),
  '/homescreen': (context) => UserScreen(),
  '/runscreen': (context) => const RunScreen(),
  '/profilescreen': (context) => ProfileScreen(),
  '/healthTest': (context) => const HealthTest(),
  // '/spinningWheelScreen': (context) => SpinningWheelScreen(),
  '/initializationScreen': (context) => Initialization(),
  '/achievementScreen': (context) => const AchievementScreen(),
};
