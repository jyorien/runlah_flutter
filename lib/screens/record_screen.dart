import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runlah_flutter/constants.dart';
import 'package:geolocator/geolocator.dart';

class RecordScreen extends StatefulWidget {
  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  GoogleMapController _controller;
  Position _currentPosition;
  Polyline _polyline;
  List<LatLng> _latLngList = [];
  Set<Polyline> _polylineSet = {};

  String btnText = "START";
  bool _isStart = false;
  StreamSubscription<Position> _positionStream;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  void _requestPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    _currentPosition = await Geolocator.getCurrentPosition();
    print(_currentPosition);
    final currentLatLng =
        LatLng(_currentPosition.latitude, _currentPosition.longitude);
    _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: currentLatLng, zoom: zoomLevel)));
  }

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
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              polylines: _polylineSet,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
                setState(() {
                  _polyline = Polyline(
                      polylineId: PolylineId(
                        'p1',
                      ),
                      color: Colors.blue);
                  _polylineSet.add(_polyline);
                });
              },
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: MaterialButton(
                onPressed: () {
                  if (!_isStart) {
                    _isStart = true;
                    setState(() {
                      btnText = 'STOP';
                    });
                    _positionStream =
                        Geolocator.getPositionStream().listen((event) {
                      // subscribe to location updates
                      final currentLatLng = LatLng(_currentPosition.latitude,
                          _currentPosition.longitude);
                      final newLatLng = LatLng(event.latitude, event.longitude);
                      _latLngList.add(newLatLng);
                      setState(() {
                        Polyline _newLine = Polyline(
                            polylineId: PolylineId(event.timestamp.toString()),color: Colors.blue, points: _latLngList);
                        _polylineSet.add(_newLine);
                        _currentPosition = event;
                        _controller.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(target: newLatLng, zoom: zoomLevel),
                          ),
                        );
                      });
                    });
                  } else {
                    _isStart = false;
                    _positionStream.cancel();
                    setState(() {
                      btnText = 'START';
                    });
                  }
                },
                child: Text(
                  btnText,
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
