import 'package:runspiration/size_config.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runspiration/backend_services/auth.dart';
import 'package:runspiration/shared/singleton.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Singleton _singleton = Singleton();

  @override
  void initState() {
    super.initState();
    Singleton().addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.comicNeue(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(0, 214, 214, 214),
          image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset(
                'assets/images/profile_background.png',
              ).image,
              opacity: 1.0),
        ),
        child: Center(
            child: Column(
          children: [
            // SizedBox(height: 40),
            SizedBox(
              width: SizeConfig.blockSizeHorizontal! * 100,
              child: Card(
                color: Color.fromARGB(177, 115, 181, 236),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(children: [
                    Stack(alignment: Alignment.center, children: [
                      Container(
                        width: SizeConfig.blockSizeHorizontal! * 40 + 20,
                        height: SizeConfig.blockSizeHorizontal! * 40 + 20,
                        decoration: BoxDecoration(
                            color: _singleton
                                .borderColors[_singleton.currentBorder],
                            shape: BoxShape.circle),
                      ),
                      Image(
                        image: AssetImage(
                            'assets/profiles/${(_singleton.userData != null) ? _singleton.userData!["profile"].toString() : "default.png"}'),
                        fit: BoxFit.contain,
                        width: SizeConfig.blockSizeHorizontal! * 40,
                        height: SizeConfig.blockSizeHorizontal! * 40,
                        // scale: 10,
                      ),
                    ]),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${Authentication().user!.email}",
                      style: GoogleFonts.comicNeue(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ]),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical! * 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [
                  Image(
                    image: AssetImage(
                        'assets/achievements/${(_singleton.userData != null) ? _singleton.userData!["achievements"]["active"][0] : "empty"}.png'),
                    fit: BoxFit.contain,
                    width: SizeConfig.blockSizeHorizontal! * 20,
                    height: SizeConfig.blockSizeHorizontal! * 20,
                    // scale: 10,
                  ),
                  Text(
                    (_singleton.userData != null)
                        ? "${_singleton.achievementDescriptions[_singleton.userData!['achievements']['active'][0]]}"
                        : "",
                    style: GoogleFonts.comicNeue(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ]),
                Column(children: [
                  Image(
                    image: AssetImage(
                        'assets/achievements/${(_singleton.userData != null) ? _singleton.userData!["achievements"]["active"][1] : "empty"}.png'),
                    fit: BoxFit.contain,
                    width: SizeConfig.blockSizeHorizontal! * 20,
                    height: SizeConfig.blockSizeHorizontal! * 20,
                    // scale: 10,
                  ),
                  Text(
                      (_singleton.userData != null)
                          ? "${_singleton.achievementDescriptions[_singleton.userData!['achievements']['active'][1]]}"
                          : "",
                      style: GoogleFonts.comicNeue(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ]),
                Column(children: [
                  Image(
                    image: AssetImage(
                        'assets/achievements/${(_singleton.userData != null) ? _singleton.userData!["achievements"]["active"][2] : "empty"}.png'),
                    fit: BoxFit.contain,
                    width: SizeConfig.blockSizeHorizontal! * 20,
                    height: SizeConfig.blockSizeHorizontal! * 20,
                    // scale: 10,
                  ),
                  Text(
                    (_singleton.userData != null)
                        ? "${_singleton.achievementDescriptions[_singleton.userData!['achievements']['active'][2]]}"
                        : "",
                    style: GoogleFonts.comicNeue(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ]),
              ],
            ),
            SizedBox(height: SizeConfig.blockSizeVertical! * 30),
            // TextButton(
            //     onPressed: () {
            //       Navigator.pushNamed(context, '/achievementScreen');
            //     },
            //     child: Text("Edit", style: GoogleFonts.comicNeue(fontSize: 36))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                    width: SizeConfig.blockSizeHorizontal! * 40,
                    height: 65,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/achievementScreen');
                        },
                        child: Text('Edit',
                            style: GoogleFonts.comicNeue(fontSize: 30)))),
                // const SizedBox(height: 10),
                SizedBox(
                    width: SizeConfig.blockSizeHorizontal! * 40,
                    height: 65,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/accountScreen');
                        },
                        child: Text('Settings',
                            style: GoogleFonts.comicNeue(fontSize: 30)))),
              ],
            ), //general screen
          ],
        )),
      ),
    );
  }
}
