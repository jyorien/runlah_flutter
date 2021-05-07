import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runlah_flutter/components/record_stats.dart';
import 'package:runlah_flutter/constants.dart';

class HistoryScreen extends StatefulWidget {
  // receive latlng list, time taken, session step count, average speed, session distance
  List<LatLng> latLngList;
  String timeTaken;
  String stepCount;
  String averageSpeed;
  String sessionDistance;

  HistoryScreen(
      {this.stepCount = "0",
      this.averageSpeed = "0.0",
      this.timeTaken = "00:00",
      this.sessionDistance = "0.0",
      this.latLngList});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    List<LatLng> latLngList = widget.latLngList;
    String timeTaken = widget.timeTaken;
    String stepCount = widget.stepCount;
    String averageSpeed = widget.averageSpeed;
    String sessionDistance = widget.sessionDistance;
    print(latLngList.last);
    return Scaffold(
        body: Column(
      children: [
        Container(
          height: 400,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(target: latLngList.first, zoom: zoomLevel),
            markers: {
              Marker(markerId: MarkerId("start"), position: latLngList.first),
              Marker(markerId: MarkerId("end"), position: latLngList.last)
            },
            polylines: {
              Polyline(polylineId: PolylineId("route"), points: latLngList, color: Colors.blue)
            },
          ),
        ),
        SizedBox(height: 30,),
        RecordStats(
          averageSpeed: averageSpeed,
          sessionDistance: sessionDistance,
          timeTaken: timeTaken,
          stepCount: stepCount,
        ),
      ],
    ));
  }
}
