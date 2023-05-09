import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:david_app/backend_services/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDrawer extends StatelessWidget {
  final List<TextButton> elements;
  UserDrawer({Key? key, required this.elements}) : super(key: key);

  final Uri _url = Uri.parse('https://forms.gle/c7kJL2pfy8RqwQ6v9');
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // child: ListView.separated(
      //     shrinkWrap: true,
      //     itemBuilder: (BuildContext context, int idx) {
      //       print("Testing");
      //       TextButton button = elements[idx];
      //       return button;
      //     },
      //     separatorBuilder: (BuildContext context, int idx) => const Divider(),
      //     itemCount: 1),
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Options',
              style: GoogleFonts.comicNeue(color: Colors.white, fontSize: 36),
            ),
          ),
          ListTile(
            tileColor: Colors.blue.shade50,
            title: Text(
              'Logout',
              style: GoogleFonts.comicNeue(
                  fontSize: 28, color: Color.fromARGB(255, 34, 34, 34)),
            ),
            onTap: () async {
              await Authentication().signout().then(
                    (value) => Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false),
                  );
            },
          ),
          ListTile(
            tileColor: Colors.blue.shade50,
            title: Text(
              'Reward',
              style: GoogleFonts.comicNeue(
                  fontSize: 28, color: Color.fromARGB(255, 34, 34, 34)),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/spinningWheelScreen');
            },
          ),
          ListTile(
            tileColor: Colors.blue.shade50,
            title: Text(
              'Feedback',
              style: GoogleFonts.comicNeue(
                  fontSize: 28, color: Color.fromARGB(255, 34, 34, 34)),
            ),
            onTap: () {
              _launchUrl();
            },
          ),
          // ListTile(
          //   title: const Text('Item 2'),
          //   onTap: () {
          //     // Update the state of the app.
          //     // ...
          //   },
          // ),
        ],
      ),
    );
  }
}

// Drawer(
//           child: ListView(
//             children: [
//               ListTile(
//                 title: Text('Home'),
//                 onTap: () {
//                   // Navigate to the home screen
//                 },
//               ),
//               ListTile(
//                 title: Text('Settings'),
//                 onTap: () {
//                   // Navigate to the settings screen
//                 },
//               ),
//               ListTile(
//                 title: Text('About'),
//                 onTap: () {
//                   // Navigate to the about screen
//         },
//       ),
//     ],
//   ),
// )
