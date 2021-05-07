import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants.dart';

class CardTile extends StatelessWidget {
  String dateTime;
  String sessionDistance;
  String timeTaken;
  String averageSpeed;
  String stepCount;
  List<LatLng> listLatLng;

  CardTile(
      {this.dateTime = "", this.sessionDistance = "", this.timeTaken = "", this.averageSpeed = "", this.stepCount = "", this.listLatLng});

@override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  dateTime,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                )
              ],
            ),
            Row(
              children: [Text("$sessionDistance km", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36))],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(timeTaken, style: kDashboardSmallTextStyle,),
                Text('$averageSpeed m/s', style: kDashboardSmallTextStyle,),
                Text('$stepCount steps', style: kDashboardSmallTextStyle,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
