import 'dart:async';
import 'dart:math';
import 'size_config.dart';
import 'package:flutter/material.dart';
import 'package:runspiration/shared/singleton.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class SpinningWheelScreen extends StatefulWidget {
  const SpinningWheelScreen({super.key});

  @override
  State<SpinningWheelScreen> createState() => _SpinningWheelScreenState();
}

class _SpinningWheelScreenState extends State<SpinningWheelScreen> {
  StreamController<int> controller = StreamController<int>();

  final _singleton = Singleton();
  int winnings = 0;

  @override
  Widget build(BuildContext context) {
    var rng = Random();
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "You won: $winnings points",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: SizeConfig.blockSizeHorizontal! * 90,
                width: SizeConfig.blockSizeHorizontal! * 90,
                child: FortuneWheel(
                  animateFirst: false,
                  indicators: <FortuneIndicator>[
                    FortuneIndicator(
                      alignment: Alignment
                          .topCenter, // <-- changing the position of the indicator
                      child: TriangleIndicator(
                        color: Color.fromARGB(255, 0, 255,
                            8), // <-- changing the color of the indicator
                      ),
                    ),
                  ],
                  physics: CircularPanPhysics(
                      duration: Duration(seconds: 5), curve: Curves.decelerate),
                  onFling: () {
                    if (_singleton.userData!["spins"] > 0) {
                      double rngResult = rng.nextDouble() * 100;
                      int choice = 0;

                      if (rngResult < 2.5) {
                        choice = 5;
                        winnings += 88;
                      } else if (rngResult < 15) {
                        choice = 4;
                        winnings += 30;
                      } else if (rngResult < 25) {
                        choice = 2;
                      } else if (rngResult < 45) {
                        choice = 3;
                        _singleton.userData!["spins"] += 1;
                      } else if (rngResult < 70) {
                        choice = 1;
                        winnings += 20;
                      } else {
                        choice = 0;
                        winnings += 10;
                      }

                      print("RNG: $rngResult, Choice: $choice");

                      controller.add(choice);

                      _singleton.userData!["spins"] -= 1;

                      setState(() {});
                    }
                  },
                  selected: controller.stream,
                  items: const [
                    FortuneItem(
                        child: Text('10',
                            style: TextStyle(
                              fontSize: 30,
                            ))), //30
                    FortuneItem(
                        child: Text('20',
                            style: TextStyle(
                              fontSize: 30,
                            ))), //25
                    FortuneItem(
                        child: Text('Thank you',
                            style: TextStyle(
                              fontSize: 20,
                            ))), //10
                    FortuneItem(
                        child: Text('One more time',
                            style: TextStyle(
                              fontSize: 20,
                            ))), //20
                    FortuneItem(
                        child: Text('30',
                            style: TextStyle(
                              fontSize: 30,
                            ))), //12.5
                    FortuneItem(
                        child: Text('88',
                            style: TextStyle(
                              fontSize: 30,
                            ))), //2.5
                  ],
                ),
              ),
              Text("${_singleton.userData!["spins"]}x spins left!",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ],
          ),
        ));
  }
}

// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinning_wheel/flutter_spinning_wheel.dart';

// class SpinningWheelScreen extends StatelessWidget {
//   SpinningWheelScreen({super.key});

//   final StreamController _dividerController = StreamController<int>();

//   dispose() {
//     _dividerController.close();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: Column(children: [
//       SpinningWheel(
//         Image.asset('assets/images/wheel-6-300.png'),
//         width: 310,
//         height: 310,
//         initialSpinAngle: _generateRandomAngle(),
//         spinResistance: 0.2,
//         dividers: 6,
//         onUpdate: _dividerController.add,
//         onEnd: _dividerController.add,
//       ),
//       StreamBuilder(
//         stream: _dividerController.stream,
//         builder: ((context, snapshot) =>
//             snapshot.hasData ? BasicScore(snapshot.data) : Container()),
//       )
//     ]));
//   }

//   double _generateRandomAngle() => Random().nextDouble() * pi * 2;
// }

// class BasicScore extends StatelessWidget {
//   final int selected;

//   final Map<int, String> labels = {
//     1: 'Purple',
//     2: 'Magenta',
//     3: 'Red',
//     4: 'Dark Orange',
//     5: 'Light Orange',
//     6: 'Yellow',
//   };

//   BasicScore(this.selected);

//   @override
//   Widget build(BuildContext context) {
//     return Text('${labels[selected]}',
//         style: TextStyle(fontStyle: FontStyle.italic));
//   }
// }
