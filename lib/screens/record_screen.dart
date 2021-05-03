import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runlah_flutter/constants.dart';

class RecordScreen extends StatefulWidget {
  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 64.0, horizontal: 10),
          child: Column(
            children: [
              Text(
                '00:00',
                style: TextStyle(fontSize: 70),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        '0',
                        style: kRecordNumStyle,
                      ),
                      Text(
                        'Steps',
                        style: kRecordTextStyle,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text('0 km', style: kRecordNumStyle),
                      Text('Distance', style: kRecordTextStyle),
                    ],
                  ),
                  Column(
                    children: [
                      Text('0 km/h', style: kRecordNumStyle),
                      Text('Speed', style: kRecordTextStyle),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(children: [
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: LatLng(1.3521, 103.8198), zoom: 7),
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: MaterialButton(
                onPressed: () {},
                child: Text(
                  "START",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.deepPurple,
              ),
            )
          ]),
        ),
      ],
    );
  }
}
