import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RunScreen extends StatelessWidget {
  const RunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start a run'),
      ),
      body: Stack(children: <Widget>[
        Image.asset(
          'runner_image.jpg',
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          colorBlendMode: BlendMode.darken,
        ),
        Center(
          child: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "asdf",
                style: GoogleFonts.comicNeue(fontSize: 50, color: Colors.white),
              ),
              SizedBox(height: 200),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Session(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 150, vertical: 30)),
                child: Text("Start",
                    style: GoogleFonts.comicNeue(
                        fontSize: 50, color: Colors.white)),
              ),
            ],
          )),
        )
      ]),
    );
  }
}

class Session extends StatefulWidget {
  const Session({super.key});

  @override
  State<Session> createState() => _SessionState();
}

class _SessionState extends State<Session> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
          Text("00:00:00",
              style: GoogleFonts.comicNeue(fontSize: 50, color: Colors.blue)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Km:",
                  style:
                      GoogleFonts.comicNeue(fontSize: 50, color: Colors.blue)),
              Text("Cal:",
                  style:
                      GoogleFonts.comicNeue(fontSize: 50, color: Colors.blue))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Current Pace:",
                style: GoogleFonts.comicNeue(fontSize: 30, color: Colors.blue),
              ),
              Text(
                "Average Pace:",
                style: GoogleFonts.comicNeue(fontSize: 30, color: Colors.blue),
              )
            ],
          ),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            style: GoogleFonts.comicNeue(fontSize: 25, color: Colors.blue),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 50, vertical: 30)),
                child:
                    Text("Pause", style: GoogleFonts.comicNeue(fontSize: 50)),
              ),
              SizedBox(
                width: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  // log workout here too...
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/homescreen', (route) => false);
                },
                style: TextButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 50, vertical: 30)),
                child:
                    Text(" End ", style: GoogleFonts.comicNeue(fontSize: 50)),
              ),
            ],
          )
        ])));
  }
}
