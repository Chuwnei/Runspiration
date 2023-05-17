import 'package:flutter/material.dart';

class LoadingWheel extends StatelessWidget {
  const LoadingWheel({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 100,
      height: 100,
      child: CircularProgressIndicator(),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: LoadingWheel(),
    ));
  }
}
