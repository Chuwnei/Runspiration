import 'package:flutter/material.dart';
import 'package:runspiration/size_config.dart';
import 'package:runspiration/backend_services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: SizeConfig.blockSizeHorizontal! * 95,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () async {
                        await Authentication().signout().then(
                              (value) => Navigator.of(context)
                                  .pushNamedAndRemoveUntil(
                                      '/', (route) => false),
                            );
                      },
                      child: const Text('Log Out',
                          style: TextStyle(fontSize: 30)))),
              const SizedBox(height: 10),
              SizedBox(
                  width: SizeConfig.blockSizeHorizontal! * 95,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        _dialogBuilder(context);
                      },
                      child: const Text('Delete Account',
                          style: TextStyle(fontSize: 30)))),
            ]),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete your account?'),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'No',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(
              width: 20,
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'Yes',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              onPressed: () async {
                // final ref = FirebaseDatabase.instance.ref();
                // ref.child("users/${AuthenticationHelper().user!.uid}").remove().then((value) => AuthenticationHelper().user!.delete().then((value) {
                //   AuthenticationHelper().signOut();
                //   print('Account Deleted');
                //   Navigator.of(context)
                //       .pushNamedAndRemoveUntil('/', (route) => false);
                // }).catchError((error) {
                //   print('Error: $error');
                // }));

                // Navigator.of(context).pop();

                // delete account data from firestore then delete account
                await FirebaseFirestore.instance
                    .collection('user_data')
                    .doc(Authentication().user!.uid)
                    .delete()
                    .then((value) => Authentication().user!.delete().then(
                        (value) => Authentication().signout().then((value) =>
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/', (route) => false))))
                    .catchError((error) => print('Error: $error'));
              },
            ),
          ],
        );
      },
    );
  }
}
