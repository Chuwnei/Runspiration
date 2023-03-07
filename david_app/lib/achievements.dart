import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  bool positive = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            setState(() => positive = b);
            return Future.delayed(Duration(seconds: 2));
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(children: [
              Image.asset(
                'default.png',
                fit: BoxFit.contain,
                scale: 10,
              ),
              Text("asdf"),
            ]),
            Column(children: [
              Image.asset(
                'default.png',
                fit: BoxFit.contain,
                scale: 10,
              ),
              Text("asdf"),
            ]),
            Column(children: [
              Image.asset(
                'default.png',
                fit: BoxFit.contain,
                scale: 10,
              ),
              Text("asdf"),
            ]),
          ],
        ),
      ]),
    );
  }
}
