import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'size_config.dart';
import 'package:google_fonts/google_fonts.dart';

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
        Pair("default.png", "This is a test."),
        Pair("default.png", "This is a test."),
        Pair("default.png", "This is a test."),
        Pair("default.png", "This is a test."),
        Pair("default.png", "This is a test."),
    ];




  @override
  Widget build(BuildContext context) {
    return !positive ? Scaffold(
      appBar: AppBar(actions: [
        AnimatedToggleSwitch<bool>.dual(
          current: positive,
          first: false,
          second: true,
          dif: 50.0,
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
          colorBuilder: (b) => b ? Colors.red : Colors.green,
          iconBuilder: (value) => value
              ? Icon(Icons.coronavirus_rounded)
              : Icon(Icons.tag_faces_rounded),
          textBuilder: (value) => value
              ? Center(child: Text('Oh no...'))
              : Center(child: Text('Nice :)')),
        ),
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
              Image.asset(
                'default.png',
                fit: BoxFit.contain,
                scale: 10,
              ),
            ]),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Image.asset(
                'default.png',
                fit: BoxFit.contain,
                scale: 10,
              ),
            ]),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Image.asset(
                'default.png',
                fit: BoxFit.contain,
                scale: 10,
              ),
            ]),
          ],
        )),),
        Expanded(child:ListView(
            children: achievements.map((pair) => AchievementEntry(imagePath: pair.a, description: pair.b)).toList(),
        )),
        SizedBox(
            height: SizeConfig.blockSizeVertical! * 20,
            // width: 50,
            child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
            children: [
                SizedBox(
                width: SizeConfig.blockSizeHorizontal! * 40,
                height: 75,
                child: ElevatedButton(
                onPressed: () {},
                // style: TextButton.styleFrom(
                //     padding:
                //         EdgeInsets.symmetric(horizontal: 50, vertical: 30)),
                child:
                    Text("Cancel", style: GoogleFonts.comicNeue(fontSize: 50)),
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
                child:
                    Text(" Save ", style: GoogleFonts.comicNeue(fontSize: 50)),
              )),
            ],
        )),
        
      ]),
    ) : Scaffold(
        appBar: AppBar(actions: [
        AnimatedToggleSwitch<bool>.dual(
          current: positive,
          first: false,
          second: true,
          dif: 50.0,
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
          colorBuilder: (b) => b ? Colors.red : Colors.green,
          iconBuilder: (value) => value
              ? Icon(Icons.coronavirus_rounded)
              : Icon(Icons.tag_faces_rounded),
          textBuilder: (value) => value
              ? Center(child: Text('Oh no...'))
              : Center(child: Text('Nice :)')),
        ),
      ]),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            
        ],
      ),
    );
  }
}

class AchievementEntry extends StatelessWidget {
  const AchievementEntry({super.key, required this.imagePath, required this.description});
  final String imagePath;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: SizeConfig.blockSizeHorizontal! * 100,
        height: 150,
        child: Card(
            color: Colors.white,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    scale: 10,
                ),
                SizedBox(
                    width: 20,
                ),
                SizedBox(
                    width: 1,
                    height: 140,
                    child: Container(color: Color.fromARGB(125, 34, 34, 34),),
                ),
                SizedBox(
                    width: 20,
                ),
                Container(
                width: SizeConfig.blockSizeHorizontal! * 60,
                height: 250,
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                    description,
                    maxLines: 10,
                    style: TextStyle(
                        fontSize: 20
                    ),
                )))
            ],)
        )
    );
  }
}