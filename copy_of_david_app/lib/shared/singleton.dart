import 'package:flutter/material.dart';

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

  final achievements = [
    Triple("ID1", "assets/achievements/ID1.png", "This is a test."),
    Triple("ID2", "assets/achievements/ID2.png", "This is a test."),
    Triple("ID3", "assets/achievements/ID3.png", "This is a test."),
    Triple("ID4", "assets/achievements/ID4.png", "This is a test."),
    Triple("ID5", "assets/achievements/ID5.png", "This is a test."),
  ];

  // unlocked, puchase, pending
  final borders = [
    Triple("ID1", "This is a test.", "unlocked"),
    Triple("ID2", "100", "purchase"),
    Triple("ID3", "This is a test.", "pending"),
    Triple("ID4", "250", "purchase"),
  ];

  Map<String, String> achievementDescriptions = {
    "empty": "",
    "ID1": "Description 1",
    "ID2": "Description 2",
    "ID3": "Description 3",
    "ID4": "Description 4",
    "ID5": "Description 5",
  };

  Map<String, Color> borderColors = {
    "ID1": const Color.fromARGB(255, 45, 41, 43),
    "ID2": const Color.fromARGB(255, 135, 84, 230),
    "ID3": const Color.fromARGB(255, 223, 46, 134),
    "ID4": const Color.fromARGB(255, 230, 177, 64),
  };

  int achievementSelection = 0;
  List<dynamic> achievementIDs = ["empty", "empty", "empty"];
  String currentBorder = "ID1";

  // setter for achievementSelection with notifyListeners()
  void setAchievementSelection(int index) {
    achievementSelection = index;
    notifyListeners();
  }
}



//// other file
//// Singleton instance = _instance;

/// print(instance.userData["sessions"]);
/// instance.example = 13;
