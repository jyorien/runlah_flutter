import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runlah_flutter/components/record_stats.dart';
import 'package:runlah_flutter/constants.dart';
import 'package:runlah_flutter/screens/bottmnav_screen.dart';
import 'package:uuid/uuid.dart';

class ResultScreen extends StatefulWidget {
  static const id = 'results';

  // receive latlng list, time taken, session step count, average speed, session distance
  List<LatLng> latLngList;
  String timeTaken;
  int stepCount;
  double averageSpeed;
  double sessionDistance;
  String imagePath;

  ResultScreen(
      {this.latLngList,
      this.timeTaken,
      this.stepCount,
      this.averageSpeed,
      this.sessionDistance,
      this.imagePath});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Future<void> uploadFile(String filePath, String uuid) async {
    File file = File(filePath);
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await firebase_storage.FirebaseStorage.instance.ref("${auth.currentUser.uid}/$uuid")
      .putFile(file).whenComplete(() {
        Navigator.pushNamedAndRemoveUntil(
            context, BottomNavigationScreen.id, (route) => false);
      });

    } catch(e) {

    }
  }

  @override
  Widget build(BuildContext context) {
    List<LatLng> latLngList = widget.latLngList;
    String timeTaken = widget.timeTaken;
    int stepCount = widget.stepCount;
    double averageSpeed = widget.averageSpeed;
    double sessionDistance = widget.sessionDistance;
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
                    Marker(markerId: MarkerId("start"), position: latLngList.first),
                    Marker(markerId: MarkerId("end"), position: latLngList.last),
                  },
                  polylines: {
                    Polyline(
                        polylineId: PolylineId("record_line"),
                        points: latLngList,
                        color: Colors.blue)
                  },
                ),
                height: 400,
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
        children: [

                SizedBox(
                  height: 10,
                ),
                RecordStats(
                    sessionDistance: formatDistance(sessionDistance),
                    averageSpeed: averageSpeed.toStringAsFixed(2),
                    stepCount: stepCount.toString(),
                    timeTaken: timeTaken),
                SizedBox(height: 10,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  foregroundDecoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill,image: FileImage(File(widget.imagePath)))),
                )

        ],
      ),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward_ios),
        onPressed: () {
          final _firestore = FirebaseFirestore.instance;
          final uuid =  Uuid();
          final String uniqueKey = uuid.v4();
          final _auth = FirebaseAuth.instance;
          final coordinatesMap = getCoordinatesMap(latLngList);
          final Map<String, dynamic> sessionData = {
            "timestamp": FieldValue.serverTimestamp(),
            "timeTaken": timeTaken,
            "stepCount": stepCount,
            "averageSpeed": averageSpeed,
            "distanceTravelled": sessionDistance,
            "coordinatesArray": coordinatesMap,
            "uuid": uniqueKey
          };
          _firestore
              .collection('users')
              .doc(_auth.currentUser.uid)
              .collection('records')
              .doc(uniqueKey)
              .set(sessionData)
              .whenComplete(() => uploadFile(widget.imagePath, uniqueKey));
        },
      ),
    );
  }
}
