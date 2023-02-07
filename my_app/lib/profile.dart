import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/backend_services/auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
          child: Column(
        children: [
          SizedBox(height: 40),
          Image.asset(
            'default.png',
            fit: BoxFit.contain,
            scale: 4,
          ),
          Text(
            "${Authentication().user!.email}",
            style: GoogleFonts.comicNeue(fontSize: 50),
          ),
          SizedBox(height: 80),
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
        ],
      )),
    );
  }
}
