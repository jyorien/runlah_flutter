import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:environment_sensors/environment_sensors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runlah_flutter/constants.dart';

class TodayScreen extends StatefulWidget {
  static const id = 'today';

  @override
  _TodayScreenState createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  String _todayDistance = "0.00 km";
  String _todaySteps = "0 steps";
  final environmentSensors = EnvironmentSensors();
  Widget temperatureWidget = Container();
  var temperatureStream;
  String currentTemperature;

  void displayTemperature() async {
    await environmentSensors
        .getSensorAvailable(SensorType.AmbientTemperature)
        .then((isAvailable) {
      if (isAvailable) {
        initTemperatureStream();
      }
    });
  }

  void initTemperatureStream() {
    temperatureStream = environmentSensors.temperature.listen((temperature) {
      setState(() {
        currentTemperature = temperature.toStringAsFixed(1);
        temperatureWidget = Column(
          children: [
            Text('Temperature', style: kTodayTextStyle,),
            Text("$currentTemperature \u2103", style: kTodayNumStyle,),
          ],
        );
      } );
    });
  }

  @override
  void initState() {
    super.initState();
    displayTemperature();
    getData();
  }

  @override
  void dispose() {
    temperatureStream.dispose();
    super.dispose();
  }

  void getData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    DateTime today = DateTime.now();
    var totalDistance = 0.0;
    var totalSteps = 0;
    var result = await firestore
        .collection('users')
        .doc(auth.currentUser.uid)
        .collection('records')
        .orderBy('timestamp', descending: true)
        .get();
    result.docs.forEach((element) {
      Timestamp timestamp = element["timestamp"];
      var date = timestamp.toDate().toLocal();
      if (date.day == today.day &&
          date.month == today.month &&
          date.year == today.year) {
        totalDistance += element["distanceTravelled"];
        totalSteps += element["stepCount"];
      }
    });
    _todayDistance = "${(totalDistance / 1000).toStringAsFixed(2)} km";
    _todaySteps = "$totalSteps steps";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          temperatureWidget,
          Text(
            "Today's Distance",
            style: kTodayTextStyle,
          ),
          Text(_todayDistance, style: kTodayNumStyle),
          Text("Today's Step Count", style: kTodayTextStyle),
          Text(_todaySteps, style: kTodayNumStyle),
        ],
      ),
    );
  }
}
