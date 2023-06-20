import 'package:runspiration/login/login.dart';
import 'package:runspiration/login/signup.dart';
import 'package:runspiration/checker.dart';
import 'package:runspiration/userscreen.dart';
import 'package:runspiration/runscreen.dart';
import 'package:runspiration/profile.dart';
import 'package:runspiration/account.dart';
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
  '/spinningWheelScreen': (context) => const SpinningWheelScreen(),
  '/initializationScreen': (context) => Initialization(),
  '/achievementScreen': (context) => const AchievementScreen(),
  '/summaryScreen': (context) => SummaryScreen(),
  '/accountScreen': (context) => const AccountScreen(),
};
