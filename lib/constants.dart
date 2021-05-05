import 'package:flutter/material.dart';

final kInputDecoration = InputDecoration(
  hintText: 'Email',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30)),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30)),
    borderSide: BorderSide(color: Colors.deepPurple, width: 1)
  ),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide(color: Colors.deepPurple, width: 2)
  )

);

final kWelcomeTextStyle = TextStyle(fontSize: 50);

final kRecordNumStyle = TextStyle(fontSize: 30);
final kRecordTextStyle = TextStyle(fontSize: 20);
const double zoomLevel = 20;

String formatDistance(double distance) => distance.toStringAsFixed(2);

String formatSpeed(double speed) => speed.toStringAsFixed(2);

