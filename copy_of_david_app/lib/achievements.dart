import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:david_app/shared/singleton.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

// class Pair<T1, T2> {
//   final T1 a;
//   final T2 b;

//   Pair(this.a, this.b);
// }

// class Triple<T1, T2, T3> {
//   final T1 a;
//   final T2 b;
//   final T3 c;

//   Triple(this.a, this.b, this.c);
// }

class _AchievementScreenState extends State<AchievementScreen> {
  bool positive = false;
  int selection = 0;

  Singleton _singleton = Singleton();

  // final achievements = [
  //   Pair("assets/achievements/ID1.png", "This is a test."),
  //   Pair("assets/achievements/ID2.png", "This is a test."),
  //   Pair("assets/achievements/ID3.png", "This is a test."),
  //   Pair("assets/achievements/ID4.png", "This is a test."),
  //   Pair("assets/achievements/ID5.png", "This is a test."),
  // ];

  // // unlocked, puchase, pending
  // final borders = [
  //   Triple("ID1", "This is a test.", "unlocked"),
  //   Triple("ID2", "This is a test.", "purchase"),
  //   Triple("ID3", "This is a test.", "pending"),
  //   Triple("ID4", "This is a test.", "purchase"),
  // ];

  @override
  Widget build(BuildContext context) {
    print(_singleton.userData!["achievements"]);
    print(_singleton.userData!["achievements"]["active"].runtimeType);

    List<dynamic> active = _singleton.userData!["achievements"]["active"];

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
                        style: GoogleFonts.comicNeue(color: Colors.black),
                      ))
                    : Center(
                        child: Text('Achievements',
                            style: GoogleFonts.comicNeue(color: Colors.black))),
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
                    color: const Color.fromARGB(255, 115, 182, 236),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  selection = 0;
                                  print("Hello $selection");
                                  setState(() {});
                                },
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      (selection == 0)
                                          ? Container(
                                              width: 80,
                                              height: 80,
                                              decoration: const BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  shape: BoxShape.circle),
                                            )
                                          : Container(),
                                      Image(
                                          image: AssetImage(
                                              'assets/achievements/${(_singleton.userData != null) ? _singleton.userData!["achievements"]["active"][0] : "empty"}.png'),
                                          fit: BoxFit.contain,
                                          width: 75,
                                          height: 75
                                          // scale: 10,
                                          ),
                                    ]),
                              ),
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () {
                                    selection = 1;
                                    print("Hello $selection");
                                    setState(() {});
                                  },
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        (selection == 1)
                                            ? Container(
                                                width: 80,
                                                height: 80,
                                                decoration: const BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    shape: BoxShape.circle),
                                              )
                                            : Container(),
                                        Image(
                                            image: AssetImage(
                                                'assets/achievements/${(_singleton.userData != null) ? _singleton.userData!["achievements"]["active"][1] : "empty"}.png'),
                                            fit: BoxFit.contain,
                                            width: 75,
                                            height: 75
                                            // scale: 10,
                                            ),
                                      ])),
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () {
                                    selection = 2;
                                    print("Hello $selection");
                                    setState(() {});
                                  },
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        (selection == 2)
                                            ? Container(
                                                width: 80,
                                                height: 80,
                                                decoration: const BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    shape: BoxShape.circle),
                                              )
                                            : Container(),
                                        Image(
                                            image: AssetImage(
                                                'assets/achievements/${(_singleton.userData != null) ? _singleton.userData!["achievements"]["active"][2] : "empty"}.png'),
                                            fit: BoxFit.contain,
                                            width: 75,
                                            height: 75
                                            // scale: 10,
                                            ),
                                      ])),
                            ]),
                      ],
                    )),
              ),
              Expanded(
                  child: ListView(
                      children: _singleton.achievements
                          .map((triple) => AchievementEntry(
                              id: triple.a,
                              imagePath: triple.b,
                              description: triple.c))
                          .toList()
                      // children: _singleton.achievements
                      //     .map((triple) => AchievementEntry(
                      //         id: triple.a, imagePath: triple.b, description: triple.c))
                      //     .toList(),
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
                            style: GoogleFonts.comicNeue(color: Colors.black)))
                    : Center(
                        child: Text('Achievements',
                            style: GoogleFonts.comicNeue(color: Colors.black))),
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
                  height: SizeConfig.blockSizeVertical! * 15,
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
                                image: AssetImage(
                                    'assets/profiles/${(_singleton.userData != null) ? _singleton.userData!["profile"].toString() : "default.png"}'),
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
                  style: GoogleFonts.comicNeue(
                      fontSize: 65, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal! * 100,
                  height: SizeConfig.blockSizeVertical! * 40,
                  child: GridView.count(
                    crossAxisCount: 3,
                    padding: const EdgeInsets.all(20.0),
                    crossAxisSpacing: 10.0,
                    children: _singleton.borders
                        .map((triple) => BorderEntry(
                              color: triple.a,
                              description: triple.b,
                              type: triple.c,
                            ))
                        .toList(),
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
      {super.key,
      required this.id,
      required this.imagePath,
      required this.description});
  final String id;
  final String imagePath;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: SizeConfig.blockSizeHorizontal! * 100,
        height: 150,
        child: Card(
            color: const Color.fromARGB(255, 219, 219, 219),
            child: InkWell(
              onTap: () {},
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
                      color: const Color.fromARGB(125, 34, 34, 34),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                      width: SizeConfig.blockSizeHorizontal! * 60,
                      height: 250,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            description,
                            maxLines: 10,
                            style: GoogleFonts.comicNeue(fontSize: 20),
                          )))
                ],
              ),
            )));
  }
}

class BorderEntry extends StatelessWidget {
  BorderEntry(
      {super.key,
      required this.color,
      required this.description,
      required this.type});
  final String color;
  final String description;
  final String type;

  final _singleton = Singleton();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: SizeConfig.blockSizeHorizontal! * 10,
              height: SizeConfig.blockSizeHorizontal! * 10,
              decoration: BoxDecoration(
                  color: _singleton.borderColors[color],
                  shape: BoxShape.circle),
            ),
            (type == "unlocked")
                ? ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Select",
                      maxLines: 1,
                      style: GoogleFonts.comicNeue(),
                    ),
                  )
                : (type == "purchase")
                    ? ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          description,
                          maxLines: 1,
                          style: GoogleFonts.comicNeue(),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {},
                        child: Text(description,
                            maxLines: 1, style: GoogleFonts.comicNeue()),
                      ),
          ],
        ),
      ),
    );
  }
}
