import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/backend_services/auth.dart';
import 'package:my_app/shared/loading.dart';
import 'package:my_app/shared/singleton.dart';
import 'package:my_app/userscreen.dart';

class InitScreen extends StatelessWidget {
  InitScreen({super.key});

  final Singleton _singleton = Singleton();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user_data')
            .doc(Authentication().user?.uid)
            .snapshots(),
        builder:
            ((BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }

          print("Here is the data: ${snapshot.data}");
          if (snapshot.data!.data() != null) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            _singleton.userData = data;
            return UserScreen();
          }

          return Container();
        }));
  }
}
