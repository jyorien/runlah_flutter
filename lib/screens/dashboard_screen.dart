import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runlah_flutter/components/card_tile.dart';
import 'package:runlah_flutter/constants.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var dataList = [];
  void getData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    var result = await firestore.collection('users').doc(auth.currentUser.uid).collection('records').get();
    result.docs.forEach((element) {
      final data = element.data();
      dataList.add(data);
    });
    setState(() {

    });
    print(dataList);
  }

  @override
  void initState() {
    getData();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.amber,
          height: 300,
          alignment: Alignment.center,
          child: Text("Bar Graph PlaceHolder"),
        ),
        Expanded(
          child: ListView.builder(itemCount: dataList.length, itemBuilder: (context, index){
            var currentIndex = dataList[index];
            double distance = (currentIndex["distanceTravelled"] / 1000);
            double speed = currentIndex["averageSpeed"];
            Timestamp timestamp = currentIndex["timestamp"];
            // convert timestamp to datetime and format date
            DateTime date = timestamp.toDate().toLocal();
            var dayOfMonth = DateFormat.d().format(date);
            var monthName = DateFormat.MMMM().format(date);
            var year = DateFormat.y().format(date);
            var hour = DateFormat.H().format(date);
            var minute = DateFormat.m().format(date);
            var displayDate = "$dayOfMonth $monthName $year $hour:$minute";
            // convert to map so it is iterable
            var map = Map<String, dynamic>.from(currentIndex["coordinatesArray"]);
            List<LatLng> listLatLng = [];
            // get the latitude and longitude from the map to format into list of LatLng
            map.forEach((key, value) {
              var latitude = value["latitude"];
              var longitude = value["longitude"];
              listLatLng.add(LatLng(latitude, longitude));
            });

            return CardTile(
              timeTaken: currentIndex["timeTaken"].toString(),
              sessionDistance: distance.toStringAsFixed(2),
              averageSpeed: speed.toStringAsFixed(2),
              stepCount: currentIndex["stepCount"].toString(),
              dateTime: displayDate,
              listLatLng: listLatLng,


            );
          })
        )
      ],
    );
  }
}
