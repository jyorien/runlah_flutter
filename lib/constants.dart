import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final kInputDecoration = InputDecoration(
    hintText: 'Email',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(color: Colors.deepPurple, width: 1)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(color: Colors.deepPurple, width: 2)));

final kWelcomeTextStyle = TextStyle(fontSize: 50);

final kRecordNumStyle = TextStyle(fontSize: 30);
final kRecordTextStyle = TextStyle(fontSize: 20);
final kDashboardSmallTextStyle = TextStyle(fontSize: 16);
final kTodayTextStyle = TextStyle(fontSize: 40);
final kTodayNumStyle = TextStyle(fontSize: 56);
const double zoomLevel = 20;

String formatDistance(double distance) => (distance/1000).toStringAsFixed(2);

Map<String, dynamic> getCoordinatesMap(List<LatLng> listLatLng) {
  Map<String, dynamic> map = {};
  String index = "0";
  listLatLng.forEach((element) {
    int currentIndex = int.parse(index);
    map[index] = {
      'latitude': listLatLng[currentIndex].latitude,
      'longitude': listLatLng[currentIndex].longitude
    };
    currentIndex+=1;
    index = currentIndex.toString();
    });
  return map;
}
