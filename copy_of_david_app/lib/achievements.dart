import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class Pair<T1, T2> {
  final T1 a;
  final T2 b;

  Pair(this.a, this.b);
}

class _AchievementScreenState extends State<AchievementScreen> {
  bool positive = false;

  final achievements = [
    Pair("assets/default.png", "This is a test."),
    Pair("assets/default.png", "This is a test."),
    Pair("assets/default.png", "This is a test."),
    Pair("assets/default.png", "This is a test."),
    Pair("assets/default.png", "This is a test."),
  ];

  @override
  Widget build(BuildContext context) {
    return !positive
        ? Scaffold(
            appBar: AppBar(actions: [
              AnimatedToggleSwitch<bool>.dual(
                current: positive,
                first: false,
                second: true,
                dif: SizeConfig.blockSizeHorizontal! * 20,
                borderColor: Colors.transparent,
                borderWidth: 5.0,
                height: 55,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 1.5),
                  )
                ],
                onChanged: (b) {
                  print("NEW: $b");

                  setState(() => positive = b);
                  return Future.delayed(Duration(seconds: 1));
                },
                colorBuilder: (b) => b ? Colors.orange : Colors.green,
                iconBuilder: (value) => value
                    ? Icon(FontAwesomeIcons.user)
                    : Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                            color: Colors.green, shape: BoxShape.circle),
                        child: Icon(FontAwesomeIcons.trophy),
                      ),
                textBuilder: (value) => value
                    ? Center(
                        child: Text(
                        'Profile',
                        style: TextStyle(color: Colors.black),
                      ))
                    : Center(
                        child: Text('Achievements',
                            style: TextStyle(color: Colors.black))),
              ),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal! * 30,
              )
            ]),
            body: Column(children: [
              SizedBox(
                height: SizeConfig.blockSizeHorizontal! * 25,
                width: SizeConfig.blockSizeHorizontal! * 100,
                child: Container(
                    color: Color.fromARGB(255, 115, 182, 236),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                  image: AssetImage('assets/default.png'),
                                  fit: BoxFit.contain,
                                  width: 75,
                                  height: 75
                                  // scale: 10,
                                  ),
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                  image: AssetImage('assets/default.png'),
                                  fit: BoxFit.contain,
                                  width: 75,
                                  height: 75
                                  // scale: 10,
                                  ),
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                  image: AssetImage('assets/default.png'),
                                  fit: BoxFit.contain,
                                  width: 75,
                                  height: 75
                                  // scale: 10,
                                  ),
                            ]),
                      ],
                    )),
              ),
              Expanded(
                  child: ListView(
                children: achievements
                    .map((pair) => AchievementEntry(
                        imagePath: pair.a, description: pair.b))
                    .toList(),
              )),
              SizedBox(
                  height: SizeConfig.blockSizeVertical! * 20,
                  // width: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: SizeConfig.blockSizeHorizontal! * 40,
                          height: 75,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            // style: TextButton.styleFrom(
                            //     padding:
                            //         EdgeInsets.symmetric(horizontal: 50, vertical: 30)),
                            child: Text("Cancel",
                                style: GoogleFonts.comicNeue(fontSize: 36)),
                          )),
                      SizedBox(
                        width: 50,
                      ),
                      SizedBox(
                          width: SizeConfig.blockSizeHorizontal! * 40,
                          height: 75,
                          child: ElevatedButton(
                            onPressed: () {},
                            // style: TextButton.styleFrom(
                            //     padding:
                            //         EdgeInsets.symmetric(horizontal: 50, vertical: 30)),
                            child: Text(" Save ",
                                style: GoogleFonts.comicNeue(fontSize: 36)),
                          )),
                    ],
                  )),
            ]),
          )
        : Scaffold(
            appBar: AppBar(actions: [
              AnimatedToggleSwitch<bool>.dual(
                current: positive,
                first: false,
                second: true,
                dif: SizeConfig.blockSizeHorizontal! * 20,
                borderColor: Colors.transparent,
                borderWidth: 5.0,
                height: 55,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 1.5),
                  )
                ],
                onChanged: (b) {
                  print("NEW: $b");

                  setState(() => positive = b);
                  return Future.delayed(Duration(seconds: 1));
                },
                colorBuilder: (b) => b ? Colors.orange : Colors.green,
                iconBuilder: (value) => value
                    ? Icon(FontAwesomeIcons.user)
                    : const Icon(FontAwesomeIcons.trophy),
                textBuilder: (value) => value
                    ? Center(
                        child: Text('Profile',
                            style: TextStyle(color: Colors.black)))
                    : Center(
                        child: Text('Achievements',
                            style: TextStyle(color: Colors.black))),
              ),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal! * 30,
              )
            ]),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: SizeConfig.blockSizeVertical! * 20,
                  width: SizeConfig.blockSizeHorizontal! * 100,
                  child: Container(
                      color: Color.fromARGB(255, 115, 182, 236),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(alignment: Alignment.center, children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 45, 41, 43),
                                  shape: BoxShape.circle),
                            ),
                            Image(
                                image: AssetImage('assets/default.png'),
                                fit: BoxFit.contain,
                                width: 100,
                                height: 100
                                // scale: 10,
                                ),
                          ]),
                        ],
                      )),
                ),
                Text(
                  "100,000",
                  style: TextStyle(fontSize: 65, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal! * 100,
                  height: SizeConfig.blockSizeVertical! * 40,
                  child: GridView.count(
                    crossAxisCount: 3,
                    padding: const EdgeInsets.all(20.0),
                    crossAxisSpacing: 10.0,
                    children: [],
                  ),
                  // child: Container(color: Colors.green,),
                ),
                //
                SizedBox(
                    height: SizeConfig.blockSizeVertical! * 20,
                    // width: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: SizeConfig.blockSizeHorizontal! * 40,
                            height: 75,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              // style: TextButton.styleFrom(
                              //     padding:
                              //         EdgeInsets.symmetric(horizontal: 50, vertical: 30)),
                              child: Text("Cancel",
                                  style: GoogleFonts.comicNeue(fontSize: 36)),
                            )),
                        const SizedBox(
                          width: 50,
                        ),
                        SizedBox(
                            width: SizeConfig.blockSizeHorizontal! * 40,
                            height: 75,
                            child: ElevatedButton(
                              onPressed: () {},
                              // style: TextButton.styleFrom(
                              //     padding:
                              //         EdgeInsets.symmetric(horizontal: 50, vertical: 30)),
                              child: Text(" Save ",
                                  style: GoogleFonts.comicNeue(fontSize: 36)),
                            )),
                      ],
                    )),
              ],
            ),
          );
  }
}

class AchievementEntry extends StatelessWidget {
  const AchievementEntry(
      {super.key, required this.imagePath, required this.description});
  final String imagePath;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: SizeConfig.blockSizeHorizontal! * 100,
        height: 150,
        child: Card(
            color: const Color.fromARGB(255, 219, 219, 219),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                    image: AssetImage(imagePath),
                    fit: BoxFit.contain,
                    width: 75,
                    height: 75
                    // scale: 10,
                    ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 1,
                  height: 140,
                  child: Container(
                    color: Color.fromARGB(125, 34, 34, 34),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                    width: SizeConfig.blockSizeHorizontal! * 60,
                    height: 250,
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          description,
                          maxLines: 10,
                          style: TextStyle(fontSize: 20),
                        )))
              ],
            )));
  }
}

class BorderEntry extends StatelessWidget {
  const BorderEntry(
      {super.key,
      required this.imagePath,
      required this.description,
      required this.type});
  final String imagePath;
  final String description;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      child: Column(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 45, 41, 43), shape: BoxShape.circle),
          ),
          (type == "unlocked")
              ? ElevatedButton(
                  onPressed: () {},
                  child: const Text("Unlocked"),
                )
              : (type == "purchase")
                  ? ElevatedButton(
                      onPressed: () {},
                      child: Text(description),
                    )
                  : ElevatedButton(
                      onPressed: () {},
                      child: Text(description),
                    ),
        ],
      ),
    );
  }
}
