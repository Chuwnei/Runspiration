import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app/backend_services/auth.dart';

class UserDrawer extends StatelessWidget {
  final List<TextButton> elements;
  const UserDrawer({Key? key, required this.elements}) : super(key: key);
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
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Log out'),
            onTap: () async {
              await Authentication().signout();
              // Update the state of the app.
              // ...
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
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
