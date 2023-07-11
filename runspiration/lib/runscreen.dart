import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:runspiration/backend_services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:runspiration/size_config.dart';
import 'healthAPI.dart';
import 'dart:async';
import 'dart:math';
import 'package:runspiration/shared/singleton.dart';
import 'package:runspiration/encouraging_quotes.dart';

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
  final _singleton = Singleton();

  late DateTime startTime;
  double startKM = 0.0;
  int startCal = 0;
  double kilometers = 0.0;
  int calories = 0;
  double totalDistance = 0.0;

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

  LocationData? prevLocation;

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

    // Listen the singleton's locationData variable
    _singleton.locationStreamController.stream.listen((locationData) {
      if (mounted) {
        setState(() {
          if (prevLocation != null) {
            kilometers += _calculateDistance(prevLocation!, locationData);
            totalDistance = startKM + kilometers;
            print(
                "TOTAL DISTANCE: $totalDistance km, New: $kilometers km, Old: $startKM km");
          }
          prevLocation = locationData;
        });
      }
    });
  }

  double _calculateDistance(LocationData start, LocationData end) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((end.latitude! - start.latitude!) * p) / 2 +
        cos(start.latitude! * p) *
            cos(end.latitude! * p) *
            (1 - cos((end.longitude! - start.longitude!) * p)) /
            2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
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
        color: const Color(0xFF14181B),
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
                    color: const Color.fromARGB(255, 254, 229, 153),
                    fontWeight: FontWeight.bold),
              ),
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
                          _singleton.currentRunKM = _distanceTraveled;
                          _singleton.avgPace = _paceList.isNotEmpty
                              ? (_paceList.reduce((a, b) => a + b) /
                                  _paceList.length)
                              : 0.0;
                          // log workout here too..
                          DocumentReference userData = FirebaseFirestore
                              .instance
                              .collection('user_data')
                              .doc(Authentication().user!.uid);

                          // check if field "fastest_pace" exists and if it does, compare it to the average pace and update if faster
                          userData.get().then((value) {
                            if (value.exists) {
                              final data = value.data() as Map<String, dynamic>;
                              if (data["fastest_pace"] != null) {
                                if (data["fastest_pace"] > _singleton.avgPace) {
                                  userData.update(
                                      {"fastest_pace": _singleton.avgPace});
                                }
                              } else {
                                userData.update(
                                    {"fastest_pace": _singleton.avgPace});
                              }
                            }
                          });

                          userData.update({
                            "total_time": FieldValue.increment(
                                DateTime.now().difference(startTime).inSeconds),
                            "sessions": FieldValue.increment(1),
                            "progress_in_km":
                                FieldValue.increment(_distanceTraveled),
                            "total_km": FieldValue.increment(_distanceTraveled)
                          });

                          Navigator.pushNamed(context, '/summaryScreen');
                        },
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

class SummaryScreen extends StatefulWidget {
  SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen>
    with TickerProviderStateMixin {
  final _singleton = Singleton();
  final HealthAPI _healthAPI = HealthAPI();
  late AnimationController _controller;
  late String chosenQuote;
  double goal = 2.0;
  double distance = 0.0;

  Map<int, String> dayNames = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thurday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday"
  };

  // current datetime
  DateTime currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    chosenQuote = getQuote();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this)
      ..addListener(() {
        if (mounted) setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // (_healthAPI.getDistance() / 1000.0)
    goal = (_singleton.userData != null &&
            _singleton.userData!["goal_for_running"] > 2)
        ? _singleton.userData!["goal_for_running"] + .0
        : 2.0;
    distance = (_healthAPI.getDistance() / 1000.0);
    if (_controller.value >= 1.0 || _controller.value >= (distance / goal)) {
      _controller.stop();
    }

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
      child: SafeArea(
        child: Column(
          children: [
            Text(
                "${dayNames[currentTime.weekday]}.${currentTime.month}.${currentTime.day}",
                style: GoogleFonts.comicNeue(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
            SizedBox(height: 30),
            SizedBox(
              height: SizeConfig.blockSizeVertical! * 25,
              child: Card(
                  color: Color.fromARGB(139, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Stack(alignment: Alignment.center, children: [
                                  Container(
                                    width:
                                        SizeConfig.blockSizeHorizontal! * 15 +
                                            20,
                                    height:
                                        SizeConfig.blockSizeHorizontal! * 15 +
                                            20,
                                    decoration: BoxDecoration(
                                        color: _singleton.borderColors[
                                            _singleton.currentBorder],
                                        shape: BoxShape.circle),
                                  ),
                                  Image(
                                    image: AssetImage(
                                        'assets/profiles/${(_singleton.userData != null) ? _singleton.userData!["profile"].toString() : "default.png"}'),
                                    fit: BoxFit.contain,
                                    width: SizeConfig.blockSizeHorizontal! * 15,
                                    height:
                                        SizeConfig.blockSizeHorizontal! * 15,
                                    // scale: 10,
                                  ),
                                ]),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("${Authentication().user!.email}",
                                        style: GoogleFonts.comicNeue(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 30),
                                    Text("HAS JUST COMPLETED A RUN",
                                        style: GoogleFonts.comicNeue(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))
                                  ],
                                )
                              ]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                  "${(_singleton.currentRunKM).toStringAsFixed(2)}\nKM ran",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.comicNeue(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  "${_singleton.avgPace.toStringAsFixed(2)} km/min \n avg pace",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.comicNeue(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ],
                          )
                        ]),
                  )),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical! * 40,
              width: SizeConfig.blockSizeHorizontal! * 90,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // SizedBox(width: 10),
                        Text(
                            "PROGRESS BAR: ${((distance / goal) * 100).toInt()}%",
                            style: GoogleFonts.comicNeue(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 10),
                    // insert bar here
                    // Container(
                    //     color: Colors.blue,
                    //     width: SizeConfig.blockSizeHorizontal! * 90,
                    //     height: 20),
                    LinearProgressIndicator(
                      value: _controller.value,
                      backgroundColor: Colors.white,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                            "GOAL: ${(_singleton.userData != null && _singleton.userData!["goal_for_running"] > 2) ? _singleton.userData!["goal_for_running"] + .0 : 2.0} km",
                            style: GoogleFonts.comicNeue(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        // SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Text('"$chosenQuote"',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.comicNeue(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold))
                  ]),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(
                  //     width: SizeConfig.blockSizeHorizontal! * 40,
                  //     height: 75,
                  //     child: ElevatedButton(
                  //       style:
                  //           ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  //       onPressed: () {
                  //         // Navigator.of(context).pop();
                  //       },
                  //       // style: TextButton.styleFrom(
                  //       //     padding:
                  //       //         EdgeInsets.symmetric(horizontal: 50, vertical: 30)),
                  //       child: Text("Cancel",
                  //           style: GoogleFonts.comicNeue(
                  //               fontSize: 40, fontWeight: FontWeight.bold)),
                  //     )),
                  // SizedBox(
                  //     width: SizeConfig.blockSizeHorizontal! * 40,
                  //     height: 75,
                  //     child: ElevatedButton(
                  //       style:
                  //           ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  //       onPressed: () {
                  //         // Navigator.of(context).pop();
                  //       },
                  //       // style: TextButton.styleFrom(
                  //       //     padding:
                  //       //         EdgeInsets.symmetric(horizontal: 50, vertical: 30)),
                  //       child: Text("Cancel",
                  //           style: GoogleFonts.comicNeue(
                  //               fontSize: 40, fontWeight: FontWeight.bold)),
                  //     )),
                  SizedBox(
                      width: SizeConfig.blockSizeHorizontal! * 80,
                      height: 75,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: () {
                          // Navigator.of(context).pop();
                          // FirebaseFirestore.instance
                          //     .collection('user_data')
                          //     .doc(Authentication().user!.uid)
                          //     .update({
                          //   "sessions": FieldValue.increment(1),
                          //   "progress_in_km": FieldValue.increment(12),
                          //   "total_km": FieldValue.increment(12)
                          // });

                          Navigator.pushNamedAndRemoveUntil(
                              context, "/", (route) => false);
                        },
                        // style: TextButton.styleFrom(
                        //     padding:
                        //         EdgeInsets.symmetric(horizontal: 50, vertical: 30)),
                        child: Text("Done",
                            style: GoogleFonts.comicNeue(
                                fontSize: 40, fontWeight: FontWeight.bold)),
                      )),
                ])
          ],
        ),
      ),
    ));
  }
}
