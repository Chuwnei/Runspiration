import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:david_app/size_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:david_app/backend_services/auth.dart';
import 'package:david_app/login/drawer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:david_app/shared/loading.dart';
import 'package:david_app/shared/singleton.dart';
import 'package:health/health.dart';
import 'healthAPI.dart';
import 'dart:async';

class UserScreen extends StatefulWidget {
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

  Singleton _singleton = Singleton();
  HealthAPI _healthAPI = HealthAPI();

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

  @override
  void initState() {
    _chartData = getData();
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      print("test");
      _updateStats();
      setState(() {});
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
          Colors.blue),
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

    if (_singleton.userData!["lastOnline"].toDate().day !=
        Timestamp.now().toDate().day) {
      FirebaseFirestore.instance
          .collection("user_data")
          .doc(Authentication().user?.uid)
          .update({"progress_in_km": 0, "lastOnline": Timestamp.now()});
    }

    if (_singleton.userData!["lastReward"].toDate().day !=
        Timestamp.now().toDate().day) {
      FirebaseFirestore.instance
          .collection("user_data")
          .doc(Authentication().user?.uid)
          .update({
        "currency": FieldValue.increment(100),
        "lastReward": Timestamp.now()
      });
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
                body: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          color: Colors.grey.shade200,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(children: [
                              Text(
                                "Today",
                                style: GoogleFonts.comicNeue(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 50,
                                    color: Colors.grey.shade800),
                              ),
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
                                            style: GoogleFonts.comicNeue()),
                                        Text(
                                            HealthAPI()
                                                .getCalories()
                                                .toString(),
                                            style: GoogleFonts.comicNeue(
                                                fontSize: 45,
                                                color: Colors.red))
                                      ],
                                    ),
                                    Column(children: [
                                      Text("Active Time",
                                          style: GoogleFonts.comicNeue()),
                                      Text("${_healthAPI.getExerciseTime()}m",
                                          style: GoogleFonts.comicNeue(
                                              fontSize: 45,
                                              color: Colors.purple))
                                    ]),
                                  ]),
                              Stack(children: <Widget>[
                                SfCircularChart(series: <CircularSeries>[
                                  // Renders radial bar chart
                                  RadialBarSeries<UserStats, double>(
                                      useSeriesColor: true,
                                      trackOpacity: 0.3,
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
                                    child: Container(
                                        child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 125,
                                    ),
                                    Text(
                                        "Current: ${(_healthAPI.getDistance() / 1000.0).toStringAsFixed(2)}",
                                        style: GoogleFonts.comicNeue(
                                            fontSize: 30, color: Colors.blue)),
                                    Text(
                                        "Goal: ${_singleton.userData!["goal_for_running"]} km",
                                        style: GoogleFonts.comicNeue(
                                            fontSize: 20, color: Colors.green)),
                                    TextButton(
                                        onPressed: () =>
                                            _dialogBuilder(context),
                                        child: Text("Edit",
                                            style: GoogleFonts.comicNeue())),
                                  ],
                                )))
                              ]),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text("Session Count",
                                    style: GoogleFonts.comicNeue()),
                                Text(
                                  _singleton.userData!["sessions"].toString(),
                                  style: GoogleFonts.comicNeue(
                                      fontSize: 45, color: Colors.green),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text("Average Pace",
                                    style: GoogleFonts.comicNeue()),
                                Text("-:-- / km",
                                    style: GoogleFonts.comicNeue(
                                        fontSize: 45, color: Colors.blue))
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text("Average Distance",
                                    style: GoogleFonts.comicNeue()),
                                Text(
                                  "- km",
                                  style: GoogleFonts.comicNeue(
                                      fontSize: 45, color: Colors.amber),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text("Fastest Pace",
                                    style: GoogleFonts.comicNeue()),
                                Text("-:-- / km",
                                    style: GoogleFonts.comicNeue(
                                        fontSize: 45, color: Colors.orange))
                              ],
                            )
                          ],
                        )
                      ]),
                ),
                bottomNavigationBar: BottomAppBar(
                  shape: const CircularNotchedRectangle(),
                  child: Container(
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(Icons.directions_run),
                          onPressed: () {
                            if (mounted)
                              setState(() {
                                _buttonPressed = 'Start a run';
                              });
                            Navigator.pushNamed(context, "/runscreen");
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.people),
                          onPressed: () {
                            if (mounted)
                              setState(() {
                                _buttonPressed = 'Union';
                              });
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
                          icon: Icon(Icons.account_balance_wallet),
                          onPressed: () {
                            if (mounted)
                              setState(() {
                                _buttonPressed = 'Crypto account';
                              });
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: SizeConfig.blockSizeVertical! * 25,
            width: SizeConfig.blockSizeHorizontal! * 100,
            child: Container(
                color: const Color.fromARGB(255, 115, 182, 236),
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
                          color: Colors.white),
                    )
                  ],
                )),
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            (_singleton.userData != null)
                ? _singleton.userData!["currency"].toString()
                : "0",
            style: GoogleFonts.comicNeue(
                fontSize: 65, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 100,
          ),
          SizedBox(
              width: SizeConfig.blockSizeHorizontal! * 80,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/achievementScreen');
                  },
                  child: const Text('Purchase Cosmetics',
                      style: TextStyle(fontSize: 30)))),
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
    );
  }
}
