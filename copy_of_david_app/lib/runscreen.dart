import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:david_app/backend_services/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:david_app/size_config.dart';

class RunScreen extends StatelessWidget {
  const RunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Start a run',
          style: GoogleFonts.comicNeue(),
        ),
      ),
      body: Stack(children: <Widget>[
        const Image(
          image: AssetImage('assets/runner_image.jpg'),
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
                "Press start to begin tracking your running session! Your session details will be saved once you are done.",
                textAlign: TextAlign.center,
                style: GoogleFonts.comicNeue(fontSize: 36, color: Colors.white),
              ),
              const SizedBox(height: 200),
              SizedBox(
                  width: SizeConfig.blockSizeHorizontal! * 80,
                  height: 75,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Session(),
                        ),
                      );
                    },
                    // style: TextButton.styleFrom(
                    //     padding:
                    //         EdgeInsets.symmetric(horizontal: 150, vertical: 30)),
                    child: Text("Start",
                        style: GoogleFonts.comicNeue(
                            fontSize: 50, color: Colors.white)),
                  ))
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
  late DateTime startTime;
  double kilometers = 5.0;
  int calories = 0;

  @override
  void initState() {
    super.initState();
    startTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TimerBuilder.periodic(const Duration(seconds: 1),
                builder: (context) {
              Duration diff = DateTime.now().difference(startTime);
              return Text(
                  "${(diff.inHours > 9) ? "" : 0}${diff.inHours}:${(diff.inMinutes > 9) ? "" : 0}${diff.inMinutes}:${(diff.inSeconds > 9) ? "" : 0}${diff.inSeconds}",
                  style: GoogleFonts.comicNeue(
                      fontSize: 50,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold));
            }),
            // Text("00:00:00",
            //     style: GoogleFonts.comicNeue(fontSize: 50, color: Colors.blue)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Km: $kilometers",
                    style: GoogleFonts.comicNeue(
                        fontSize: 50, color: Colors.blue)),
                Text("Cal: $calories",
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
                  style:
                      GoogleFonts.comicNeue(fontSize: 30, color: Colors.blue),
                ),
                Text(
                  "Average Pace:",
                  style:
                      GoogleFonts.comicNeue(fontSize: 30, color: Colors.blue),
                )
              ],
            ),
            Text(
              "For the sake of testing, we are going to have the end button automatically log a session as if the user ran 5km.",
              style: GoogleFonts.comicNeue(fontSize: 25, color: Colors.blue),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SizedBox(
                //     width: SizeConfig.blockSizeHorizontal! * 40,
                //     height: 75,
                //     child: ElevatedButton(
                //       onPressed: () {},
                //       // style: TextButton.styleFrom(
                //       //     padding:
                //       //         EdgeInsets.symmetric(horizontal: 50, vertical: 30)),
                //       child: Text("Pause",
                //           style: GoogleFonts.comicNeue(fontSize: 50)),
                //     )),
                // SizedBox(
                //   width: 50,
                // ),
                SizedBox(
                    width: SizeConfig.blockSizeHorizontal! * 40,
                    height: 75,
                    child: ElevatedButton(
                      onPressed: () {
                        // log workout here too...
                        DocumentReference userData = FirebaseFirestore.instance
                            .collection('user_data')
                            .doc(Authentication().user!.uid);

                        userData.update({
                          "sessions": FieldValue.increment(1),
                          "progress_in_km": FieldValue.increment(kilometers),
                          "total_km": FieldValue.increment(kilometers)
                        });

                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/', (route) => false);
                      },
                      // style: TextButton.styleFrom(
                      //     padding:
                      //         EdgeInsets.symmetric(horizontal: 50, vertical: 30)),
                      child: Text(" End ",
                          style: GoogleFonts.comicNeue(fontSize: 50)),
                    )),
              ],
            )
          ]),
    ));
  }
}
