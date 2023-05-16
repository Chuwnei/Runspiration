import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:david_app/backend_services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:david_app/size_config.dart';
import 'healthAPI.dart';
import 'dart:async';

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
      setState(() {
        print("STEPS: $steps");
        _stepsTaken = steps;
      });
    }, (distance) {
      setState(() {
        print("DISTANCE: $distance");
        _distanceTraveled = distance;
      });
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
        _caloriesBurned = _calculateCaloriesBurned();
      });
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
        body: Padding(
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
                      fontSize: 50,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold));
            }),
            // Text("00:00:00",
            //     style: GoogleFonts.comicNeue(fontSize: 50, color: Colors.blue)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Km: $_distanceTraveled",
                    style: GoogleFonts.comicNeue(
                        fontSize: 50, color: Colors.blue)),
                Text("Cal: $calories",
                    style:
                        GoogleFonts.comicNeue(fontSize: 50, color: Colors.blue))
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     Text(
            //       "Current Pace:",
            //       style:
            //           GoogleFonts.comicNeue(fontSize: 30, color: Colors.blue),
            //     ),
            //     Text(
            //       "Average Pace:",
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
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      // style: TextButton.styleFrom(
                      //     padding:
                      //         EdgeInsets.symmetric(horizontal: 50, vertical: 30)),
                      child: Text("Cancel",
                          style: GoogleFonts.comicNeue(fontSize: 40)),
                    )),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                    width: SizeConfig.blockSizeHorizontal! * 40,
                    height: 75,
                    child: ElevatedButton(
                      onPressed: () {
                        // log workout here too...
                        DocumentReference userData = FirebaseFirestore.instance
                            .collection('user_data')
                            .doc(Authentication().user!.uid);

                        userData.update({
                          "sessions": FieldValue.increment(1),
                          "progress_in_km": FieldValue.increment(kilometers),
                          "total_km": FieldValue.increment(kilometers)
                        });

                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/', (route) => false);
                      },
                      // style: TextButton.styleFrom(
                      //     padding:
                      //         EdgeInsets.symmetric(horizontal: 50, vertical: 30)),
                      child: Text("Done",
                          style: GoogleFonts.comicNeue(fontSize: 40)),
                    )),
              ],
            )
          ]),
    ));
  }
}
