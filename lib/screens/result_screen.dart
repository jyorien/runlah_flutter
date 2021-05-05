import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runlah_flutter/components/record_stats.dart';
import 'package:runlah_flutter/constants.dart';
import 'package:runlah_flutter/screens/bottmnav_screen.dart';

class ResultScreen extends StatefulWidget {
  static const id = 'results';

  // receive latlng list, time taken, session step count, average speed, session distance
  List<LatLng> latLngList;
  String timeTaken;
  String stepCount;
  String averageSpeed;
  String sessionDistance;

  ResultScreen(
      {this.latLngList,
      this.timeTaken,
      this.stepCount,
      this.averageSpeed,
      this.sessionDistance});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    List<LatLng> latLngList = widget.latLngList;
    String timeTaken = widget.timeTaken;
    String stepCount = widget.stepCount;
    String averageSpeed = widget.averageSpeed;
    String sessionDistance = widget.sessionDistance;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Container(
            child: GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: latLngList.last, zoom: zoomLevel),
              mapType: MapType.normal,
              markers: {
                Marker(
                    markerId: MarkerId("marker1"), position: latLngList.first),
                Marker(
                    markerId: MarkerId("marker2"), position: latLngList.last),
              },
              polylines: {Polyline(polylineId: PolylineId("record_line"),points: latLngList, color: Colors.blue)},
            ),
            height: 400,
          ),
          SizedBox(height: 10,),
          Expanded(
              child: RecordStats(
                  sessionDistance: sessionDistance,
                  averageSpeed: averageSpeed,
                  stepCount: stepCount,
                  timeTaken: timeTaken)),
        ],
      )),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.arrow_forward_ios), onPressed: () {
        Navigator.pushNamedAndRemoveUntil(context, BottomNavigationScreen.id, (route) => false);
      },),
    );
  }
}
