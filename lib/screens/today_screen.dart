import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:environment_sensors/environment_sensors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runlah_flutter/providers/DarkThemePreferences.dart';
import 'package:runlah_flutter/constants.dart';
import 'package:runlah_flutter/providers/TipProvider.dart';
import 'package:runlah_flutter/utils/Tips.dart';

class TodayScreen extends StatefulWidget {
  static const id = 'today';

  @override
  _TodayScreenState createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  String _todayDistance = "0.00 km";
  String _todaySteps = "0 steps";
  String _tipOfDay = "Loading...";
  final environmentSensors = EnvironmentSensors();
  Widget temperatureWidget = Container();
  var temperatureStream;
  String currentTemperature;
  DarkThemeProvider themeChange;
  TipProvider tipProvider = TipProvider();

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
        temperatureWidget = Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(vertical: 30.0),
          decoration: BoxDecoration(
              color: themeChange.isDark
                  ? Color(0xDF232323)
                  : Color(0xEF7E57C2),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Temperature',
                style: kTodayTextStyle,
              ),
              SizedBox(width: 10,),
              Text(
                "$currentTemperature \u2103",
                style: kTodayNumStyle,
              ),
            ],
          ),
        );
      });
    });
  }

  @override
  void initState() {
    super.initState();
    displayTemperature();
    getData();
    tipProvider.getTip().then((value) {
      setState(() {
        _tipOfDay = value;
      });
    });
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
    var totalSteps = 0.0;
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

    setState(() {
      _todayDistance = "${(totalDistance / 1000).toStringAsFixed(2)} km";
      _todaySteps = "${totalSteps.toInt()} steps";
    });
  }

  @override
  Widget build(BuildContext context) {

    themeChange = Provider.of<DarkThemeProvider>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          temperatureWidget,
          SizedBox(height: 10,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
                color: themeChange.isDark
                    ? Color(0xDF232323)
                    : Color(0xEF7E57C2),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(child: Center(child: Text(_tipOfDay ?? "Stay hydrated!", style: kTodayTextStyle))),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: themeChange.isDark
                            ? Color(0xDF232323)
                            : Color(0xEF7E57C2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    padding:
                    EdgeInsets.symmetric(vertical: 80.0, horizontal: 10.0),
                    child: Column(
                      children: [
                        Text("Today's Distance", style: kTodayTextStyle),
                        Text(_todayDistance, style: kTodayNumStyle),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: themeChange.isDark
                            ? Color(0xDF232323)
                            : Color(0xEF7E57C2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    padding:
                    EdgeInsets.symmetric(vertical: 80.0, horizontal: 10.0),
                    child: Column(
                      children: [
                        Text("Today's Step Count", style: kTodayTextStyle),
                        Text(_todaySteps, style: kTodayNumStyle),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
