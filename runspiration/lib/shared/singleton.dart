import 'package:flutter/material.dart';
import 'package:health/health.dart';

class Pair<T1, T2> {
  final T1 a;
  final T2 b;

  Pair(this.a, this.b);
}

class Triple<T1, T2, T3> {
  final T1 a;
  final T2 b;
  final T3 c;

  Triple(this.a, this.b, this.c);
}

class Singleton extends ChangeNotifier {
  static final Singleton _instance = Singleton._internal();

  // passes the instantiation to the _instance object
  factory Singleton() => _instance;

  // initialize our variables
  Singleton._internal() {
    // _example = 0;
  }

//   int _example = 0;
  Map<String, dynamic>? userData;

  List<HealthDataPoint> healthDataList = [];

  final achievements = [
    Triple("ID0", "assets/achievements/ID0.png",
        "Welcome! You signed up for runspiration."),
    Triple("ID1", "assets/achievements/ID1.png", "Run 20 kilometers in total."),
    Triple("ID2", "assets/achievements/ID2.png", "Run 5 consecutive days."),
    Triple("ID3", "assets/achievements/ID3.png",
        "Achieve a fastest pace that's less than 5 minutes in a run"),
    Triple("ID4", "assets/achievements/ID4.png",
        "Improve for 30 seconds since the first run"),
  ];

  // unlocked, puchase, pending
  final borders = [
    Triple("ID1", "0", "purchase"),
    Triple("ID2", "200", "purchase"),
    Triple("ID3", "100", "purchase"),
    Triple("ID4", "250", "purchase"),
    Triple("ID5", "500", "purchase"),
    Triple("ID6", "300", "purchase"),
    Triple("ID7", "This is a test.", "pending"),
    Triple("ID8", "This is a test.", "pending"),
    Triple("ID9", "This is a test.", "pending"),
  ];

  Map<String, String> achievementDescriptions = {
    "empty": "",
    "ID0": "Description 1",
    "ID1": "Description 2",
    "ID2": "Description 3",
    "ID3": "Description 4",
    "ID4": "Description 5",
  };

  Map<String, Color> borderColors = {
    "ID1": const Color.fromARGB(255, 45, 41, 43),
    "ID2": const Color.fromARGB(255, 135, 84, 230),
    "ID3": Color.fromARGB(255, 247, 143, 195),
    "ID4": Color.fromARGB(255, 64, 75, 230),
    "ID5": Color.fromARGB(255, 0, 242, 255),
    "ID6": Color.fromARGB(255, 4, 0, 255),
    "ID7": Color.fromARGB(255, 230, 166, 64),
    "ID8": Color.fromARGB(255, 0, 255, 0),
    "ID9": Color.fromARGB(255, 255, 0, 204),
  };

  int achievementSelection = 0;
  List<dynamic> achievementIDs = ["empty", "empty", "empty"];
  String currentBorder = "ID1";

  // setter for achievementSelection with notifyListeners()
  void setAchievementSelection(int index) {
    achievementSelection = index;
    notifyListeners();
  }

  void setCurrentBorder(String id) {
    currentBorder = id;
    notifyListeners();
  }
}



//// other file
//// Singleton instance = _instance;

/// print(instance.userData["sessions"]);
/// instance.example = 13;
