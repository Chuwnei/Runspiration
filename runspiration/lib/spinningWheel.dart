import 'dart:async';
import 'dart:math';
import 'size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 78, 75, 242),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(0, 20, 24, 27),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.asset(
                  'assets/images/wheel.png',
                ).image,
                opacity: 1.0),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "You won: $winnings points",
                  style: GoogleFonts.comicNeue(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                // const SizedBox(
                //   height: 20,
                // ),
                SizedBox(
                  height: SizeConfig.blockSizeHorizontal! * 90,
                  width: SizeConfig.blockSizeHorizontal! * 90,
                  child: FortuneWheel(
                    animateFirst: false,
                    indicators: const <FortuneIndicator>[
                      FortuneIndicator(
                        alignment: Alignment
                            .topCenter, // <-- changing the position of the indicator
                        child: TriangleIndicator(
                          color: Color.fromARGB(255, 255, 235,
                              123), // <-- changing the color of the indicator
                        ),
                      ),
                    ],
                    physics: CircularPanPhysics(
                        duration: const Duration(seconds: 5),
                        curve: Curves.decelerate),
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

                        if (mounted) setState(() {});
                      }
                    },
                    selected: controller.stream,
                    items: [
                      FortuneItem(
                          style: FortuneItemStyle(
                            color: Color.fromARGB(200, 78, 75, 242),
                            borderColor: Color.fromARGB(255, 56, 54, 177),
                            borderWidth: 5,
                          ),
                          child: Text('10',
                              style: GoogleFonts.comicNeue(
                                fontSize: 30,
                              ))), //30
                      FortuneItem(
                          style: FortuneItemStyle(
                            color: Color.fromARGB(200, 78, 75, 242),
                            borderColor: Color.fromARGB(255, 56, 54, 177),
                            borderWidth: 5,
                          ),
                          child: Text('20',
                              style: GoogleFonts.comicNeue(
                                fontSize: 30,
                              ))), //25
                      FortuneItem(
                          style: FortuneItemStyle(
                            color: Color.fromARGB(200, 78, 75, 242),
                            borderColor: Color.fromARGB(255, 56, 54, 177),
                            borderWidth: 5,
                          ),
                          child: Text('Thank you',
                              style: GoogleFonts.comicNeue(
                                fontSize: 20,
                              ))), //10
                      FortuneItem(
                          style: FortuneItemStyle(
                            color: Color.fromARGB(200, 78, 75, 242),
                            borderColor: Color.fromARGB(255, 56, 54, 177),
                            borderWidth: 5,
                          ),
                          child: Text('One more time',
                              style: GoogleFonts.comicNeue(
                                fontSize: 20,
                              ))), //20
                      FortuneItem(
                          style: FortuneItemStyle(
                            color: Color.fromARGB(200, 78, 75, 242),
                            borderColor: Color.fromARGB(255, 56, 54, 177),
                            borderWidth: 5,
                          ),
                          child: Text('30',
                              style: GoogleFonts.comicNeue(
                                fontSize: 30,
                              ))), //12.5
                      FortuneItem(
                          style: FortuneItemStyle(
                            color: Color.fromARGB(200, 78, 75, 242),
                            borderColor: Color.fromARGB(255, 56, 54, 177),
                            borderWidth: 5,
                          ),
                          child: Text('88',
                              style: GoogleFonts.comicNeue(
                                fontSize: 30,
                              ))), //2.5
                    ],
                  ),
                ),
                // const SizedBox(
                //   height: 20,
                // ),
                Text("${_singleton.userData!["spins"]}x spins left!",
                    style: GoogleFonts.comicNeue(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            ),
          ),
        ));
  }
}
