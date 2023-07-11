import 'dart:async';

import 'package:runspiration/userscreen.dart';
import 'package:flutter/material.dart';
import 'package:runspiration/shared/loading.dart';
import 'package:runspiration/backend_services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runspiration/shared/singleton.dart';
import 'package:location/location.dart';

class Initialization extends StatefulWidget {
  const Initialization({super.key});

  @override
  State<Initialization> createState() => _InitializationState();
}

class _InitializationState extends State<Initialization> {
  final Singleton _singleton = Singleton();

  Location location = Location();

  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    startLocationupdates();
  }

  @override
  void dispose() {
    stopLocationUpdates();
    super.dispose();
  }

  void startLocationupdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();

      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();

      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // _locationData = await location.getLocation();

    _locationSubscription ??=
        location.onLocationChanged.listen((LocationData currentLocation) {
      // _singleton.locationData = currentLocation;
      _singleton.updateLocationData(currentLocation);
    });

    // _singleton.locationData = _locationData;
  }

  void stopLocationUpdates() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

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
