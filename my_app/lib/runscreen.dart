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
                child:
                    Text("Start", style: GoogleFonts.comicNeue(fontSize: 50)),
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
    return Container(
        child: Column(children: [
      Text("Timer"),
      Row(
        children: [Text("Km"), Text("Cal")],
      ),
      Row(
        children: [Text("Current Pace:"), Text("Average Pace:")],
      ),
      Text("Random sentence"),
      Row(
        children: [
          ElevatedButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 150, vertical: 30)),
            child: Text("Start", style: GoogleFonts.comicNeue(fontSize: 50)),
          ),
          ElevatedButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 150, vertical: 30)),
            child: Text("Start", style: GoogleFonts.comicNeue(fontSize: 50)),
          ),
        ],
      )
    ]));
  }
}
