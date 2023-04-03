// import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:david_app/shared/singleton.dart';
import 'dart:io' show Platform;
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// enum AppState {
//   DATA_NOT_FETCHED,
//   FETCHING_DATA,
//   DATA_READY,
//   NO_DATA,
//   AUTH_NOT_GRANTED,
//   DATA_ADDED,
//   DATA_DELETED,
//   DATA_NOT_ADDED,
//   DATA_NOT_DELETED,
//   STEPS_READY,
// }

/*
Note: a healthDataPoint looks like this:
flutter: HealthDataPoint - 
    value: 0.278,
    unit: HealthDataUnit.KILOCALORIE,
    dateFrom: 2023-04-03 00:18:25.877,
    dateTo: 2023-04-03 00:19:17.189,
    dataType: HealthDataType.ACTIVE_ENERGY_BURNED,
    platform: PlatformType.IOS,
    deviceId: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX,
    sourceId: com.apple.health.XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX,
    sourceName: Apple Watch
 */

class HealthAPI {
  // use the health.dart package to get the active calories for today
  List<HealthDataPoint> _healthDataList = [];
  final _singleton = Singleton();
  // AppState _state = AppState.DATA_NOT_FETCHED;
  // int _nofSteps = 10;
  // double _mgdl = 10.0;

  // create a HealthFactory for use in the app
  HealthFactory health = HealthFactory();

  /// Fetch data points from the health plugin and show them in the app.
  Future _fetchData() async {
    // setState(() => _state = AppState.FETCHING_DATA);

    // check if I am on android or ios
    if (Platform.isAndroid) {
      // Android-specific code
      // print("Android");
    } else if (Platform.isIOS) {
      // iOS-specific code
      // print("iOS");
    }

    // define the types to get
    final types = [
      // HealthDataType.STEPS,
      HealthDataType.DISTANCE_WALKING_RUNNING,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      // HealthDataType.WORKOUT,
      // Uncomment these lines on iOS - only available on iOS
      // HealthDataType.AUDIOGRAM
      HealthDataType.EXERCISE_TIME
    ];

    // with coresponsing permissions
    final permissions = [
      // HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      // HealthDataAccess.READ,
      // HealthDataAccess.READ,
      HealthDataAccess.READ
    ];

    // get data within the last 24 hours
    final now = DateTime.now();
    // final yesterday = now.subtract(Duration(hours: 24));

    // last midnight
    final lastMidnight = DateTime(now.year, now.month, now.day);
    // print(lastMidnight);
    // requesting access to the data types before reading them
    // note that strictly speaking, the [permissions] are not
    // needed, since we only want READ access.
    bool requested =
        await health.requestAuthorization(types, permissions: permissions);
    // print('requested: $requested');

    // If we are trying to read Step Count, Workout, Sleep or other data that requires
    // the ACTIVITY_RECOGNITION permission, we need to request the permission first.
    // This requires a special request authorization call.
    //
    // The location permission is requested for Workouts using the Distance information.
    await Permission.activityRecognition.request();
    await Permission.location.request();

    // Clear old data points
    _healthDataList.clear();

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(lastMidnight, now, types);
        // save all the new data points (only the first 200)
        _healthDataList.addAll(healthData);
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

      // print the results
      // _healthDataList.forEach((x) => print(x));

      // update the UI to display the results

      return _healthDataList;
      // setState(() {
      //   _state =
      //       _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
      // });
    } else {
      print("Authorization not granted");
      // setState(() => _state = AppState.DATA_NOT_FETCHED);
      return [];
    }
  }

  void fetchData() async {
    List<HealthDataPoint> healthDataList = await HealthAPI()._fetchData();
    _singleton.healthDataList = healthDataList;
  }

  // write a function that returns an int representing the total active caloris burned today using the healthdatapoints list in singleton
  int getCalories() {
    fetchData();
    double totalCalories = 0;
    for (var i = 0; i < _singleton.healthDataList.length; i++) {
      if (_singleton.healthDataList[i].type ==
          HealthDataType.ACTIVE_ENERGY_BURNED) {
        // print(_singleton.healthDataList[i].dateFrom);
        totalCalories +=
            double.parse(_singleton.healthDataList[i].value.toString());
      }
    }
    return totalCalories.toInt();
  }

  // write a function that returns an int representing the total distance walked today using the healthdatapoints list in singleton
  double getDistance() {
    fetchData();
    double totalDistance = 0;
    for (var i = 0; i < _singleton.healthDataList.length; i++) {
      if (_singleton.healthDataList[i].type ==
          HealthDataType.DISTANCE_WALKING_RUNNING) {
        // print(_singleton.healthDataList[i]);
        totalDistance +=
            double.parse(_singleton.healthDataList[i].value.toString());
      }
    }
    return totalDistance;
  }

  // write a function that returns an int representing the total exercise time today using the healthdatapoints list in singleton
  int getExerciseTime() {
    fetchData();
    double totalExerciseTime = 0;
    for (var i = 0; i < _singleton.healthDataList.length; i++) {
      if (_singleton.healthDataList[i].type == HealthDataType.EXERCISE_TIME) {
        // print(_singleton.healthDataList[i]);
        totalExerciseTime +=
            double.parse(_singleton.healthDataList[i].value.toString());
      }
    }
    return totalExerciseTime.toInt();
  }
}
