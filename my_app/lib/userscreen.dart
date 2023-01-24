import 'package:flutter/material.dart';
import 'package:my_app/backend_services/auth.dart';
import 'package:my_app/login/drawer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/shared/loading.dart';

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

  @override
  void initState() {
    _chartData = getData();
    super.initState();
  }

  List<UserStats> getData() {
    final List<UserStats> chartData = [
      UserStats(20, 10, Colors.blue),
    ];
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
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
                body: Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text("Calories",
                                    style: GoogleFonts.comicNeue()),
                                Text("100",
                                    style: GoogleFonts.comicNeue(
                                        fontSize: 45, color: Colors.red))
                              ],
                            ),
                            Column(children: [
                              Text("Active Time",
                                  style: GoogleFonts.comicNeue()),
                              Text("1m",
                                  style: GoogleFonts.comicNeue(
                                      fontSize: 45, color: Colors.purple))
                            ]),
                          ]),
                      Container(
                        child: Stack(children: <Widget>[
                          Container(
                              child: SfCircularChart(series: <CircularSeries>[
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
                                maximumValue: 20)
                          ])),
                          Center(
                              child: Container(
                                  child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 125,
                              ),
                              const Text("Current: 10",
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.blue)),
                              const Text("Goal: 20",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.green)),
                              TextButton(
                                  onPressed: () {},
                                  child: Text("Edit",
                                      style: GoogleFonts.comicNeue())),
                            ],
                          )))
                        ]),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text("Session Count",
                                  style: GoogleFonts.comicNeue()),
                              Text(
                                "250",
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
                      SizedBox(height: 70),
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
                    ])),
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
