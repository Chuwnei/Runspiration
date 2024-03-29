import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runspiration/size_config.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:runspiration/backend_services/auth.dart';
import 'package:runspiration/login/drawer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runspiration/shared/loading.dart';
import 'package:runspiration/shared/singleton.dart';
import 'package:health/health.dart';
import 'healthAPI.dart';
import 'dart:async';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 1),
    () => 'Data Loaded',
  );

  late List<UserStats> _chartData;
  String _buttonPressed = 'Home';
  bool canEdit = true;

  final Singleton _singleton = Singleton();
  final HealthAPI _healthAPI = HealthAPI();

  TextEditingController goalcontroller = TextEditingController();
  int goal = 5;

  Future<void> _updateStats() async {
    // Define a start and end time to query the data.
    final endDate = DateTime.now();
    final startDate = DateTime(endDate.year, endDate.month, endDate.day);

    // Define the types of health data you want to get, in this case only ACTIVE_ENERGY_BURNED.
    final types = <HealthDataType>[
      HealthDataType.DISTANCE_WALKING_RUNNING,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.EXERCISE_TIME
    ];

    // Get the health data from the specified date range and types.
    final healthData =
        await HealthFactory().getHealthDataFromTypes(startDate, endDate, types);

    // Store the result in the state to update the UI.
    if (mounted) {
      setState(() {
        _singleton.healthDataList = healthData;
        for (var i = 0; i < _singleton.healthDataList.length; i++) {
          if (_singleton.healthDataList[i].type ==
              HealthDataType.ACTIVE_ENERGY_BURNED) {
            print(_singleton.healthDataList[i].dateFrom);
            break;
            // totalCalories +=
            //     double.parse(_singleton.healthDataList[i].value.toString());
          }
        }
      });
    }
  }

  @override
  void initState() {
    _chartData = getData();
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      // print("test");
      if (mounted) _updateStats();
      if (mounted) setState(() {});
    });
  }

  List<UserStats> getData() {
    final List<UserStats> chartData = [
      UserStats(
          (_singleton.userData != null)
              ? _singleton.userData!["goal_for_running"].toDouble()
              : 2.0,
          (_singleton.userData != null)
              ? _healthAPI.getDistance() / 1000.0
              : 0.0,
          const Color.fromARGB(255, 0, 217, 255)),
    ];
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    // print(Timestamp.now().seconds - _singleton.userData!["lastOnline"].seconds);
    // print(_singleton.userData!["lastOnline"].toDate().day);
    // print(Timestamp.now().toDate().day);

    // print(HealthAPI().getCalories());
    // print(HealthAPI().getDistance());
    CheckAchievements();

    // if the user's currency is greater than 999, set it to 999
    if (_singleton.userData != null && _singleton.userData!["currency"] > 999) {
      FirebaseFirestore.instance
          .collection("user_data")
          .doc(Authentication().user?.uid)
          .update({"currency": 999});
    }

    if (_singleton.userData != null &&
        _singleton.userData!["lastOnline"].toDate().day !=
            Timestamp.now().toDate().day) {
      FirebaseFirestore.instance
          .collection("user_data")
          .doc(Authentication().user?.uid)
          .update({"progress_in_km": 0, "lastOnline": Timestamp.now()});
    }

    if (_singleton.userData != null &&
        _singleton.userData!["lastReward"].toDate().day !=
            Timestamp.now().toDate().day) {
      // check if the user already has 999 currency before giving them the daily reward
      // if (_singleton.userData!["currency"] < 999) {
      //   FirebaseFirestore.instance
      //       .collection("user_data")
      //       .doc(Authentication().user?.uid)
      //       .update({
      //     "currency": (_singleton.userData!["currency"] + 100 < 999)
      //         ? FieldValue.increment(100)
      //         : 999,
      //     "lastReward": Timestamp.now()
      //   });
      // }

      // check if the user reached their goal for the day and give them the reward if they did
      if (_singleton.userData!["progress_in_km"] >=
          _singleton.userData!["goal_for_running"]) {
        FirebaseFirestore.instance
            .collection("user_data")
            .doc(Authentication().user?.uid)
            .update({
          "spins": FieldValue.increment(5),
          "lastReward": Timestamp.now()
        });
      }

      // ACHIEVEMENT CHECKING BELOW

      // check if a user ran 20 total km and give them the achievement if they did
      if (_singleton.userData!["total_km"] >= 20 &&
          !_singleton.userData!["achievements"]["unlocked"].contains("ID1")) {
        FirebaseFirestore.instance
            .collection("user_data")
            .doc(Authentication().user?.uid)
            .update({
          "achievements.unlocked": FieldValue.arrayUnion(["ID1"])
        });

        // _singleton.userData!["achievements"].add("20km");
        // _singleton.userData!["achievements"].sort();
        // _singleton.userData!["achievements"].forEach((element) {
        //   print(element);
        // });
      }

      // check if the user has 5 or more run_streaks and give them the achievement if they did
      if (_singleton.userData!["run_streak"] >= 5 &&
          !_singleton.userData!["achievements"]["unlocked"].contains("ID2")) {
        FirebaseFirestore.instance
            .collection("user_data")
            .doc(Authentication().user?.uid)
            .update({
          "achievements.unlocked": FieldValue.arrayUnion(["ID2"])
        });
        // _singleton.userData!["achievements"].add("5streaks");
        // _singleton.userData!["achievements"].sort();
        // _singleton.userData!["achievements"].forEach((element) {
        //   print(element);
        // });
      }

      // check if the user has a fastest pace of 5km/min or less and give them the achievement if they did
      if (_singleton.userData!["fastest_pace"] != null &&
          _singleton.userData!["fastest_pace"] <= 5 &&
          !_singleton.userData!["achievements"]["unlocked"].contains("ID3")) {
        FirebaseFirestore.instance
            .collection("user_data")
            .doc(Authentication().user?.uid)
            .update({
          "achievements.unlocked": FieldValue.arrayUnion(["ID3"])
        });
        // _singleton.userData!["achievements"].add("5pace");
        // _singleton.userData!["achievements"].sort();
        // _singleton.userData!["achievements"].forEach((element) {
        //   print(element);
        // });
      }

      // BORDER CHECKING BELOW

      // check if the user has completed their 5th session and give them the border if they did
      if (_singleton.userData!["sessions"] >= 5 &&
          !_singleton.userData!["borders"]["unlocked"].contains("ID7")) {
        FirebaseFirestore.instance
            .collection("user_data")
            .doc(Authentication().user?.uid)
            .update({
          "borders.unlocked": FieldValue.arrayUnion(["ID7"])
        });
        // _singleton.userData!["borders"].add("5sessions");
        // _singleton.userData!["borders"].sort();
        // _singleton.userData!["borders"].forEach((element) {
        //   print(element);
        // });
      }

      // check if the user has reached 1000 total km and give them the border if they did
      if (_singleton.userData!["total_km"] >= 1000 &&
          !_singleton.userData!["borders"]["unlocked"].contains("ID8")) {
        FirebaseFirestore.instance
            .collection("user_data")
            .doc(Authentication().user?.uid)
            .update({
          "borders.unlocked": FieldValue.arrayUnion(["ID8"])
        });
        // _singleton.userData!["borders"].add("1000km");
        // _singleton.userData!["borders"].sort();
        // _singleton.userData!["borders"].forEach((element) {
        //   print(element);
        // });
      }

      // check if the user has a 7 day run streak and give them the border if they did
      if (_singleton.userData!["run_streak"] >= 7 &&
          !_singleton.userData!["borders"]["unlocked"].contains("ID9")) {
        FirebaseFirestore.instance
            .collection("user_data")
            .doc(Authentication().user?.uid)
            .update({
          "borders.unlocked": FieldValue.arrayUnion(["ID9"])
        });
        // _singleton.userData!["borders"].add("7streaks");
        // _singleton.userData!["borders"].sort();
        // _singleton.userData!["borders"].forEach((element) {
        //   print(element);
        // });
      }
    }

    _chartData = getData();
    return FutureBuilder<String>(
        future: _calculation,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<TextButton> btnList = [];

            btnList
                .add(TextButton(onPressed: () {}, child: const Text("Logout")));

            return Scaffold(
                //home screen goes here
                appBar: AppBar(
                  title: Text('Home', style: GoogleFonts.comicNeue()),
                ),
                drawer: UserDrawer(elements: btnList),
                body: Stack(children: [
                  const Image(
                    image: AssetImage('assets/images/runhome.png'),
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                    colorBlendMode: BlendMode.darken,
                  ),
                  SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  // SizedBox(
                                  //     width: 200,
                                  //     height: 75,
                                  //     child: ElevatedButton(
                                  //         onPressed: () {
                                  //           Navigator.pushNamed(
                                  //               context, '/healthTest');
                                  //         },
                                  //         child: const Text('HealthTest',
                                  //             style:
                                  //                 TextStyle(fontSize: 25)))),
                                  Column(
                                    children: [
                                      Text("Calories",
                                          style: GoogleFonts.comicNeue(
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255))),
                                      Text(HealthAPI().getCalories().toString(),
                                          style: GoogleFonts.comicNeue(
                                              fontSize: 45,
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255)))
                                    ],
                                  ),
                                  Column(children: [
                                    Text("Active Time",
                                        style: GoogleFonts.comicNeue(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255))),
                                    Text("${_healthAPI.getExerciseTime()}m",
                                        style: GoogleFonts.comicNeue(
                                            fontSize: 45,
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255)))
                                  ]),
                                ]),
                            Stack(
                              children: <Widget>[
                                SfCircularChart(series: <CircularSeries>[
                                  // Renders radial bar chart
                                  RadialBarSeries<UserStats, double>(
                                      // useSeriesColor: true,
                                      trackColor: const Color.fromARGB(
                                          255, 0, 217, 255),
                                      trackOpacity: 0.5,
                                      innerRadius: '80%',
                                      cornerStyle: CornerStyle.bothCurve,
                                      dataSource: _chartData,
                                      xValueMapper: (UserStats data, _) =>
                                          data.distance,
                                      yValueMapper: (UserStats data, _) =>
                                          data.progress,
                                      pointColorMapper: (UserStats data, _) =>
                                          data.color,
                                      maximumValue: (_singleton.userData !=
                                                  null &&
                                              _singleton.userData![
                                                      "goal_for_running"] >
                                                  2) // minimum 2 km per day!
                                          ? _singleton.userData![
                                                  "goal_for_running"] +
                                              .0
                                          : 2.0)
                                ]),
                                Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 125,
                                    ),
                                    Text(
                                        "Current: ${(_healthAPI.getDistance() / 1000.0).toStringAsFixed(2)}",
                                        style: GoogleFonts.comicNeue(
                                          fontSize: 30,
                                          color: const Color.fromARGB(
                                              255, 17, 0, 255),
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Text(
                                        "Goal: ${(_singleton.userData != null) ? _singleton.userData!["goal_for_running"] : 2} km",
                                        style: GoogleFonts.comicNeue(
                                          fontSize: 20,
                                          color: const Color.fromARGB(
                                              255, 0, 217, 255),
                                          fontWeight: FontWeight.bold,
                                        )),
                                    TextButton(
                                        onPressed: () =>
                                            _dialogBuilder(context),
                                        child: Text("Edit",
                                            style: GoogleFonts.comicNeue(
                                                color: const Color.fromARGB(
                                                    255, 0, 217, 255)))),
                                  ],
                                ))
                              ],
                            ),
                          ]),
                          //const SizedBox(height: 100),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical! * 30,
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                color: const Color.fromARGB(0, 70, 70, 70),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              "Session Count",
                                              style: GoogleFonts.comicNeue(
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255)),
                                            ),
                                            Text(
                                              _singleton.userData!["sessions"]
                                                  .toString(),
                                              style: GoogleFonts.comicNeue(
                                                  fontSize: 35,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255)),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text("Average Pace",
                                                style: GoogleFonts.comicNeue(
                                                    color: const Color.fromARGB(
                                                        255, 255, 255, 255))),
                                            Text(
                                                (_singleton.userData![
                                                            "total_time"] >
                                                        0)
                                                    ? "${_singleton.userData!['total_time'] ~/ _singleton.userData!['total_km'] ~/ 60}:${(_singleton.userData!['total_time'] ~/ _singleton.userData!['total_km'] % 60).toString().padLeft(2, '0')}/km"
                                                    : "-:--/km",
                                                style: GoogleFonts.comicNeue(
                                                    fontSize: 35,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color.fromARGB(
                                                        255, 255, 255, 255)))
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 50),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          children: [
                                            Text("Average Distance",
                                                style: GoogleFonts.comicNeue(
                                                    color: const Color.fromARGB(
                                                        255, 255, 255, 255))),
                                            Text(
                                              (_singleton.userData![
                                                          'sessions'] >
                                                      0)
                                                  ? "${(_singleton.userData!['total_km'] / _singleton.userData!['sessions']).toStringAsFixed(2)} km"
                                                  : "0 km",
                                              style: GoogleFonts.comicNeue(
                                                  fontSize: 35,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255)),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text("Fastest Pace",
                                                style: GoogleFonts.comicNeue(
                                                    color: const Color.fromARGB(
                                                        255, 255, 255, 255))),
                                            Text(
                                                (_singleton.userData![
                                                            'fastest_pace'] !=
                                                        null)
                                                    ? "${_singleton.userData!['fastest_pace'].toStringAsFixed(2)} km/min"
                                                    : "0 km/min",
                                                style: GoogleFonts.comicNeue(
                                                    fontSize: 35,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color.fromARGB(
                                                        255, 255, 255, 255)))
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                )),
                          ),
                        ]),
                  ),
                ]),
                bottomNavigationBar: BottomAppBar(
                  color: Colors.blue,
                  shape: const CircularNotchedRectangle(),
                  child: SizedBox(
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.directions_run),
                          onPressed: () {
                            if (mounted) {
                              setState(() {
                                _buttonPressed = 'Start a run';
                              });
                            }
                            Navigator.pushNamed(context, "/runscreen");
                          },
                        ),
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.people),
                          onPressed: () {
                            if (mounted) {
                              setState(() {
                                _buttonPressed = 'Union';
                              });
                            }
                            Navigator.pushNamed(context, "/profilescreen");
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => ProfileScreen(),
                            //   ),
                            // );
                          },
                        ),
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.account_balance_wallet),
                          onPressed: () {
                            if (mounted) {
                              setState(() {
                                _buttonPressed = 'Crypto account';
                              });
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WalletScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ));
          } else if (snapshot.hasError) {
            return const Text("Something went wrong!");
          } else {
            return const LoadingScreen();
          }
        });
  }

  void CheckAchievements() {
    if (_singleton.userData == null) {
      return;
    }
    // check if a user ran 20 total km and give them the achievement if they did
    if (_singleton.userData!["total_km"] >= 20 &&
        !_singleton.userData!["achievements"]["unlocked"].contains("ID1")) {
      FirebaseFirestore.instance
          .collection("user_data")
          .doc(Authentication().user?.uid)
          .update({
        "achievements.unlocked": FieldValue.arrayUnion(["ID1"])
      });

      // _singleton.userData!["achievements"].add("20km");
      // _singleton.userData!["achievements"].sort();
      // _singleton.userData!["achievements"].forEach((element) {
      //   print(element);
      // });
    }

    // check if a user has 5 or more run_streaks and give them the achievement if they did
    if (_singleton.userData!["run_streak"] >= 5 &&
        !_singleton.userData!["achievements"]["unlocked"].contains("ID2")) {
      FirebaseFirestore.instance
          .collection("user_data")
          .doc(Authentication().user?.uid)
          .update({
        "achievements.unlocked": FieldValue.arrayUnion(["ID2"])
      });
      // _singleton.userData!["achievements"].add("5streaks");
      // _singleton.userData!["achievements"].sort();
      // _singleton.userData!["achievements"].forEach((element) {
      //   print(element);
      // });
    }
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        if (_singleton.userData!["lastEdit"].toDate().day !=
            Timestamp.now().toDate().day) {
          return AlertDialog(
            title: const Text(
                'What do you want to change your goal to?\n(2km is the minimum!)'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal! * 50,
                  height: 70,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: goalcontroller,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    onChanged: (text) {
                      goal = int.parse(text);
                    },
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "km",
                  style: TextStyle(fontSize: 35),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Confirm'),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('user_data')
                      .doc(Authentication().user!.uid)
                      .update({
                    "goal_for_running": (goal > 2 && goal < 100) ? goal : 2,
                    "lastEdit": Timestamp.now()
                  }).then((value) => Navigator.of(context).pop());
                },
              ),
            ],
          );
        } else {
          return AlertDialog(
            title:
                const Text('You are only allowed to change this once a day!'),
            // content: Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     SizedBox(
            //       width: SizeConfig.blockSizeHorizontal! * 50,
            //       height: 50,
            //       child: TextField(
            //         keyboardType: TextInputType.number,
            //         controller: goalcontroller,
            //         decoration:
            //             const InputDecoration(border: OutlineInputBorder()),
            //         onChanged: (text) {
            //           goal = int.parse(text);
            //         },
            //         style: const TextStyle(fontSize: 32),
            //       ),
            //     ),
            //     const SizedBox(width: 10),
            //     const Text(
            //       "km",
            //       style: TextStyle(fontSize: 32),
            //     ),
            //   ],
            // ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Dismiss'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      },
    );
  }
}

class UserStats {
  UserStats(this.distance, this.progress, this.color);
  final double distance;
  final double progress;
  final Color color;
}

// class RunScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Start a run'),
//       ),
//       body: Center(
//         child: Text('This is the run screen'),
//       ),
//     );
//   }
// }

// class ProfileScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Union'),
//       ),
//       body: Center(
//         child: Text('This is the union screen'),
//       ),
//     );
//   }
// }

class WalletScreen extends StatefulWidget {
  WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final Singleton _singleton = Singleton();

  @override
  void initState() {
    super.initState();
    Singleton().addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wallet',
          style: GoogleFonts.comicNeue(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(0, 20, 24, 27),
          image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset(
                'assets/images/wallet.png',
              ).image,
              opacity: 1.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: SizeConfig.blockSizeVertical! * 25,
              width: SizeConfig.blockSizeHorizontal! * 100,
              child: Container(
                  color: const Color.fromARGB(150, 255, 255, 255),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(alignment: Alignment.center, children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                              color: _singleton
                                  .borderColors[_singleton.currentBorder],
                              shape: BoxShape.circle),
                        ),
                        Image(
                            image: AssetImage(
                                'assets/profiles/${(_singleton.userData != null) ? _singleton.userData!["profile"].toString() : "default.png"}'),
                            fit: BoxFit.contain,
                            width: 100,
                            height: 100
                            // scale: 10,
                            ),
                      ]),
                      const SizedBox(height: 25),
                      Text(
                        // (Authentication().user?.displayName != null)
                        //     ? "${Authentication().user?.displayName}"
                        //     : "Hello!",
                        "${Authentication().user!.email}",
                        style: GoogleFonts.comicNeue(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )
                    ],
                  )),
            ),
            const SizedBox(
              height: 25,
            ),
            Stack(alignment: Alignment.center, children: [
              Container(
                width: 220,
                height: 220,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 206, 59),
                    shape: BoxShape.circle),
              ),
              Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 172, 133, 14),
                      shape: BoxShape.circle)
                  // scale: 10,
                  ),
              Container(
                  width: 180,
                  height: 180,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 206, 59),
                      shape: BoxShape.circle)
                  // scale: 10,
                  ),
              Text(
                (_singleton.userData != null)
                    ? _singleton.userData!["currency"].toString()
                    : "0",
                style: GoogleFonts.comicNeue(
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 172, 133, 14)),
              ),
            ]),

            const SizedBox(
              height: 100,
            ),
            SizedBox(
                width: SizeConfig.blockSizeHorizontal! * 80,
                height: 50,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(215, 33, 149, 243))),
                    onPressed: () {
                      Navigator.pushNamed(context, '/achievementScreen');
                    },
                    child: Text('Purchase Cosmetics',
                        style: GoogleFonts.comicNeue(fontSize: 30)))),
            SizedBox(
              height: SizeConfig.blockSizeVertical! * 3,
            )
            // SizedBox(
            //   width: SizeConfig.blockSizeHorizontal! * 100,
            //   height: SizeConfig.blockSizeVertical! * 40,
            //   child: GridView.count(
            //     crossAxisCount: 3,
            //     padding: const EdgeInsets.all(20.0),
            //     crossAxisSpacing: 10.0,
            //     children: [],
            //   ),
            //   // child: Container(color: Colors.green,),
            // ),
          ],
        ),
      ),
    );
  }
}
