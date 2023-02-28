class Singleton {
  static final Singleton _instance = Singleton._internal();

  // passes the instantiation to the _instance object
  factory Singleton() => _instance;

  // initialize our variables
  Singleton._internal() {
    // _example = 0;
    _userData = null;
  }

//   int _example = 0;
  Map<String, dynamic>? _userData = null;

//   // getter
//   int get example => _example;

//   // setter
//   set example(int value) => _example = value;

  // getter
  Map<String, dynamic>? get userData => _userData;

  // setter
  set userData(Map<String, dynamic>? value) => _userData = value;
}



//// other file
//// Singleton instance = _instance;

/// print(instance.userData["sessions"]);
/// instance.example = 13;
