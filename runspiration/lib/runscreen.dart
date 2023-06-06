import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:runspiration/backend_services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:runspiration/size_config.dart';
import 'healthAPI.dart';
import 'dart:async';
import 'package:runspiration/shared/singleton.dart';

class SensorData {
  static const MethodChannel _channel = MethodChannel('com.example/sensor');

  static Future<void> startUpdates(
      Function stepsCallback, Function distanceCallback) async {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'stepsUpdate':
          stepsCallback(call.arguments);
          break;
        case 'distanceUpdate':
          distanceCallback(call.arguments);
          break;
      }
    });
    await _channel.invokeMethod('startUpdates');
  }

  static Future<void> stopUpdates() async {
    await _channel.invokeMethod('stopUpdates');
  }
}

class RunScreen extends StatelessWidget {
  const RunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Start a run',
          style: GoogleFonts.comicNeue(),
        ),
      ),
      body: Stack(children: <Widget>[
        const Image(
          image: AssetImage('assets/runner_image.jpg'),
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          colorBlendMode: BlendMode.darken,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Press start to begin tracking your running session! Your session details will be saved once you are done.",
                textAlign: TextAlign.center,
                style: GoogleFonts.comicNeue(fontSize: 36, color: Colors.white),
              ),
              const SizedBox(height: 200),
              SizedBox(
                  width: SizeConfig.blockSizeHorizontal! * 80,
                  height: 75,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Session(),
                        ),
                      );
                    },
                    // style: TextButton.styleFrom(
                    //     padding:
                    //         EdgeInsets.symmetric(horizontal: 150, vertical: 30)),
                    child: Text("Start",
                        style: GoogleFonts.comicNeue(
                            fontSize: 50, color: Colors.white)),
                  ))
            ],
          ),
        )
      ]),
    );
  }
}

class Session extends StatefulWidget {
  const Session({super.key});

  @override
  State<Session> createState() => _SessionState();
}

class _SessionState extends State<Session> {
  late DateTime startTime;
  double startKM = 0.0;
  int startCal = 0;
  double kilometers = 0.0;
  int calories = 0;

  final _healthAPI = HealthAPI();
  double _caloriesBurned = 0.0;
  int _stepsTaken = 0;
  double _distanceTraveled = 0.0;
  int _secondsElapsed = 0;
  double _weightInKg = 70.0;
  double _metValue = 7.0;
  late Timer _timer;

  double _accountedDistance = 0.0;
  List<double> _paceList = [];

  @override
  void initState() {
    super.initState();
    startTime = DateTime.now();
    startKM = _healthAPI.getDistance();
    startCal = _healthAPI.getCalories();
    startRun();
  }

  void startRun() {
    SensorData.startUpdates((steps) {
      if (mounted) {
        setState(() {
          print("STEPS: $steps");
          _stepsTaken = steps;
        });
      }
    }, (distance) {
      if (mounted) {
        setState(() {
          print("DISTANCE: $distance");
          _distanceTraveled = distance / 1000;
        });
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
          // check if a minute has passed
          if (_secondsElapsed % 60 == 0) {
            // calculate pace
            double pace = _distanceTraveled - _accountedDistance;
            _paceList.add(pace);
            _accountedDistance = _distanceTraveled;
          }
          _caloriesBurned = _calculateCaloriesBurned();
        });
      }
    });
  }

  double _calculateCaloriesBurned() {
    double caloriesPerSecond = 0.0175 * _metValue * _weightInKg / 60;
    return caloriesPerSecond * _secondsElapsed;
  }

  void endRun() async {
    SensorData.stopUpdates();
    _timer.cancel();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   startTime = DateTime.now();
  //   startKM = _healthAPI.getDistance();
  //   startCal = _healthAPI.getCalories();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        color: Color(0xFF14181B),
        image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.asset(
              'assets/images/pexels-pixabay-54326.jpg',
            ).image,
            opacity: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TimerBuilder.periodic(const Duration(seconds: 1),
                  builder: (context) {
                _healthAPI.fetchData();
                Duration diff = DateTime.now().difference(startTime);

                kilometers = _healthAPI.getDistance() - startKM;
                calories = _healthAPI.getCalories() - startCal;
                // print(HealthAPI().getCalories());

                return Text(
                    "${(diff.inHours > 9) ? "" : 0}${diff.inHours}:${((diff.inMinutes % 60) > 9) ? "" : 0}${diff.inMinutes % 60}:${((diff.inSeconds % 60) > 9) ? "" : 0}${diff.inSeconds % 60}",
                    style: GoogleFonts.comicNeue(
                        fontSize: 70,
                        color: Colors.white,
                        fontWeight: FontWeight.bold));
              }),
              // Text("00:00:00",
              //     style: GoogleFonts.comicNeue(fontSize: 50, color: Colors.blue)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Km: ${_distanceTraveled.toStringAsFixed(2)}",
                      style: GoogleFonts.comicNeue(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  Text("Cal: ${int.parse(_caloriesBurned.toStringAsFixed(0))}",
                      style: GoogleFonts.comicNeue(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold))
                ],
              ),
              Text(
                "Current Pace: \n${_paceList.isNotEmpty ? _paceList.last.toStringAsFixed(2) : 0.0} km/min",
                textAlign: TextAlign.center,
                style: GoogleFonts.comicNeue(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Average Pace: \n${_paceList.isNotEmpty ? (_paceList.reduce((a, b) => a + b) / _paceList.length).toStringAsFixed(2) : 0.0} km/min",
                textAlign: TextAlign.center,
                style: GoogleFonts.comicNeue(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Gold Earned: 1000",
                style: GoogleFonts.comicNeue(
                    fontSize: 30,
                    color: Color.fromARGB(255, 254, 229, 153),
                    fontWeight: FontWeight.bold),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     Text(
              //       "Current Pace: ${_paceList.length > 0 ? _paceList.last.toStringAsFixed(2) : 0.0} km/min",
              //       style:
              //           GoogleFonts.comicNeue(fontSize: 30, color: Colors.blue),
              //     ),
              //     Text(
              //       "Average Pace: ${_paceList.length > 0 ? (_paceList.reduce((a, b) => a + b) / _paceList.length).toStringAsFixed(2) : 0.0} km/min",
              //       style:
              //           GoogleFonts.comicNeue(fontSize: 30, color: Colors.blue),
              //     )
              //   ],
              // ),
              // Text(
              //   "For the sake of testing, we are going to have the end button automatically log a session as if the user ran 5km.",
              //   style: GoogleFonts.comicNeue(fontSize: 25, color: Colors.blue),
              //   textAlign: TextAlign.center,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: SizeConfig.blockSizeHorizontal! * 40,
                      height: 75,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        // style: TextButton.styleFrom(
                        //     padding:
                        //         EdgeInsets.symmetric(horizontal: 50, vertical: 30)),
                        child: Text("Cancel",
                            style: GoogleFonts.comicNeue(
                                fontSize: 40, fontWeight: FontWeight.bold)),
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                      width: SizeConfig.blockSizeHorizontal! * 40,
                      height: 75,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 5, 175, 11)),
                        onPressed: () {
                          // log workout here too...
                          DocumentReference userData = FirebaseFirestore
                              .instance
                              .collection('user_data')
                              .doc(Authentication().user!.uid);

                          userData.update({
                            "sessions": FieldValue.increment(1),
                            "progress_in_km":
                                FieldValue.increment(_distanceTraveled),
                            "total_km": FieldValue.increment(_distanceTraveled)
                          });

                          // Navigator.of(context)
                          //     .pushNamedAndRemoveUntil('/', (route) => false);
                          Navigator.pushNamed(context, '/summaryScreen');
                        },
                        // style: TextButton.styleFrom(
                        //     padding:
                        //         EdgeInsets.symmetric(horizontal: 50, vertical: 30)),
                        child: Text("Done",
                            style: GoogleFonts.comicNeue(
                                fontSize: 40, fontWeight: FontWeight.bold)),
                      )),
                ],
              )
            ]),
      ),
    ));
  }
}

class SummaryScreen extends StatelessWidget {
  SummaryScreen({super.key});

  final _singleton = Singleton();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        color: Color(0xFF14181B),
        image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.asset(
              'assets/images/pexels-gustavo-rodrigues-1748447.jpg',
            ).image,
            opacity: 0.5),
      ),
      child: Column(
        children: [
          Text("Monday.Jan.30",
              style: GoogleFonts.comicNeue(
                  fontSize: 40, fontWeight: FontWeight.bold)),
          Card(
              color: Color.fromARGB(139, 255, 255, 255),
              child: Column(children: [
                Row(children: [
                  Stack(alignment: Alignment.center, children: [
                    Container(
                      width: SizeConfig.blockSizeHorizontal! * 30 + 20,
                      height: SizeConfig.blockSizeHorizontal! * 30 + 20,
                      decoration: BoxDecoration(
                          color:
                              _singleton.borderColors[_singleton.currentBorder],
                          shape: BoxShape.circle),
                    ),
                    Image(
                      image: AssetImage(
                          'assets/profiles/${(_singleton.userData != null) ? _singleton.userData!["profile"].toString() : "default.png"}'),
                      fit: BoxFit.contain,
                      width: SizeConfig.blockSizeHorizontal! * 30,
                      height: SizeConfig.blockSizeHorizontal! * 30,
                      // scale: 10,
                    ),
                  ]),
                  Column(
                    children: [Text("email"), Text("quote")],
                  )
                ]),
                Row(
                  children: [Text("12\nKM ran"), Text("5:30/km \n avg pace")],
                )
              ])),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: SizeConfig.blockSizeHorizontal! * 40,
                    height: 75,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        // Navigator.of(context).pop();
                      },
                      // style: TextButton.styleFrom(
                      //     padding:
                      //         EdgeInsets.symmetric(horizontal: 50, vertical: 30)),
                      child: Text("Cancel",
                          style: GoogleFonts.comicNeue(
                              fontSize: 40, fontWeight: FontWeight.bold)),
                    )),
                SizedBox(
                    width: SizeConfig.blockSizeHorizontal! * 40,
                    height: 75,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        // Navigator.of(context).pop();
                      },
                      // style: TextButton.styleFrom(
                      //     padding:
                      //         EdgeInsets.symmetric(horizontal: 50, vertical: 30)),
                      child: Text("Cancel",
                          style: GoogleFonts.comicNeue(
                              fontSize: 40, fontWeight: FontWeight.bold)),
                    )),
              ])
        ],
      ),
    ));
  }
}
