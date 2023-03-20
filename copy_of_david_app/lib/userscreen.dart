import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:david_app/size_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:david_app/backend_services/auth.dart';
import 'package:david_app/login/drawer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:david_app/shared/loading.dart';
import 'package:david_app/backend_services/auth.dart';
import 'package:david_app/shared/singleton.dart';

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

  Singleton _singleton = Singleton();

  TextEditingController goalcontroller = TextEditingController();
  int goal = 5;

  @override
  void initState() {
    _chartData = getData();
    super.initState();
  }

  List<UserStats> getData() {
    final List<UserStats> chartData = [
      UserStats(
          (_singleton.userData != null)
              ? _singleton.userData!["goal_for_running"].toDouble()
              : 5.0,
          (_singleton.userData != null)
              ? _singleton.userData!["progress_in_km"].toDouble()
              : 0.0,
          Colors.blue),
    ];
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    // print("HOME: ${Authentication().user_data}");
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
                  title: Text('Home Screen', style: GoogleFonts.comicNeue()),
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
                                style: TextStyle(
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
                                    //     width: 250,
                                    //     height: 75,
                                    //     child: ElevatedButton(
                                    //         onPressed: () {
                                    //           Navigator.pushNamed(
                                    //               context, '/healthTest');
                                    //         },
                                    //         child: const Text('HealthTest',
                                    //             style: TextStyle(fontSize: 30)))),
                                    Column(
                                      children: [
                                        Text("Calories",
                                            style: GoogleFonts.comicNeue()),
                                        Text("100",
                                            style: GoogleFonts.comicNeue(
                                                fontSize: 45,
                                                color: Colors.red))
                                      ],
                                    ),
                                    Column(children: [
                                      Text("Active Time",
                                          style: GoogleFonts.comicNeue()),
                                      Text("1m",
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
                                                  5) // minimum 5 km per day!
                                          ? _singleton.userData![
                                                  "goal_for_running"] +
                                              .0
                                          : 5.0)
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
                                        "Current: ${_singleton.userData!["progress_in_km"]}",
                                        style: const TextStyle(
                                            fontSize: 30, color: Colors.blue)),
                                    Text(
                                        "Goal: ${_singleton.userData!["goal_for_running"]}",
                                        style: const TextStyle(
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
                                Text("3:07 / km",
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
                                  "5km",
                                  style: GoogleFonts.comicNeue(
                                      fontSize: 45, color: Colors.amber),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text("Fastest Pace",
                                    style: GoogleFonts.comicNeue()),
                                Text("3:00 / km",
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
                            setState(() {
                              _buttonPressed = 'Start a run';
                            });
                            Navigator.pushNamed(context, "/runscreen");
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.people),
                          onPressed: () {
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
                            setState(() {
                              _buttonPressed = 'Crypto account';
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CryptoAccountScreen(),
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
        return AlertDialog(
          title: const Text(
              'What do you want to change your goal to?\n(5km is the minimum!)'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: SizeConfig.blockSizeHorizontal! * 50,
                height: 50,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: goalcontroller,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  onChanged: (text) {
                    goal = int.parse(text);
                  },
                  style: const TextStyle(fontSize: 32),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "km",
                style: TextStyle(fontSize: 32),
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
                    .update({"goal_for_running": (goal > 5) ? goal : 5}).then(
                        (value) => Navigator.of(context).pop());
              },
            ),
          ],
        );
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

class CryptoAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto account'),
      ),
      body: Center(
        child: Text('This is the crypto account screen'),
      ),
    );
  }
}
