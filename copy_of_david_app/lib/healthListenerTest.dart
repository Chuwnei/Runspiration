import 'package:health/health.dart';
import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

class HealthListenTest extends StatelessWidget {
  HealthListenTest({super.key});

  StreamController<int> _caloriesController = StreamController<int>.broadcast();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
