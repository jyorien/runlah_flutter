import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
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
  List<double> _speedList = [];
  List<LatLng> _latLngList = [];
  Set<Polyline> _polylineSet = {};
  String _currentSpeed = '0.00 m/s';
  double _totalDistance = 0.00;

  int _totalStepCount = 0;
  int _startStepCount = 0;
  int _sessionStepCount = 0;

  String btnText = "START";
  bool _isStart = false;
  StreamSubscription<Position> _positionStream;

  @override
  void dispose() {
    if (_positionStream != null)  _positionStream.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _requestLocationPermissions();
    _requestActivityPermission();

  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  void _requestLocationPermissions() async {
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
    initPositionStream();
  }

  void _requestActivityPermission() async {
    var status = await Permission.activityRecognition.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      Permission.activityRecognition.request();
    }
    if (status.isGranted) initStepStream();
  }

  void initStepStream() async {
    Stream<StepCount> _stepCountStream = await Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
  }
  void initPositionStream() {
    _positionStream =
        Geolocator.getPositionStream().listen((event) {
          // subscribe to location updates
          final currentLatLng = LatLng(_currentPosition.latitude,
              _currentPosition.longitude);
          final newLatLng = LatLng(event.latitude, event.longitude);
          if (_isStart) {
            _latLngList.add(newLatLng);
            _speedList.add(event.speed);
            setState(() {
              _totalDistance+= Geolocator.distanceBetween(currentLatLng.latitude, currentLatLng.longitude, newLatLng.latitude, newLatLng.longitude);
              _currentSpeed = "${event.speed.toStringAsFixed(2)} m/s";
              Polyline _newLine = Polyline(
                  polylineId: PolylineId(event.timestamp.toString()),
                  color: Colors.blue,
                  points: _latLngList);
              _polylineSet.add(_newLine);
            });
          }
          _controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: newLatLng, zoom: zoomLevel),
            ),
          );
          _currentPosition = event;
        });
  }
  void onStepCount(StepCount event) {
    print("steps: ${event.steps}");
    _totalStepCount = event.steps;
    if (_isStart)
      setState(() {
        _sessionStepCount = _totalStepCount - _startStepCount;
      });
  }
  void onStepCountError(error) {
    print(error);
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
                        _sessionStepCount.toString(),
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
                      Text("${(_totalDistance/1000).toStringAsFixed(2)} km", style: kRecordNumStyle),
                      Text('Distance', style: kRecordTextStyle),
                    ],
                  ),
                  Column(
                    children: [
                      Text(_currentSpeed, style: kRecordNumStyle),
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
              },
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: MaterialButton(
                onPressed: () {
                  if (!_isStart) {
                    _isStart = true;
                    _startStepCount = _totalStepCount;
                    setState(() {
                      btnText = 'STOP';
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
