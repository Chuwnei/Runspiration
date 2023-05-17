import 'package:runspiration/userscreen.dart';
import 'package:flutter/material.dart';
import 'package:runspiration/shared/loading.dart';
import 'package:runspiration/backend_services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runspiration/shared/singleton.dart';

class Initialization extends StatelessWidget {
  Initialization({super.key});

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
            _singleton.achievementIDs = data['achievements']['active'];
            _singleton.currentBorder = data['borders']['active'];
          }

          return UserScreen();
        }));
  }
}
