import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SpinningWheelScreen extends StatefulWidget {
  const SpinningWheelScreen({super.key});

  @override
  State<SpinningWheelScreen> createState() => _SpinningWheelScreenState();
}

class _SpinningWheelScreenState extends State<SpinningWheelScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
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
