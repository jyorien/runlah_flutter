import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StopwatchProvider with ChangeNotifier {
  Stopwatch _stopwatch = Stopwatch();
  String get sessionTime => formatTime(_stopwatch.elapsedMilliseconds);

  void startStopwatch() => _stopwatch.start();
  void stopStopwatch() {
    _stopwatch.stop();
  }
  void resetStopwatch() {
    _stopwatch.reset();
    _sessionDistance = 0.0;
    _speedList = [];
    _stepCount = 0;
  }

  String formatTime(int milliseconds) {
    if (milliseconds == null || milliseconds == 0) {
      return "00:00";
    }
    var minutes = (milliseconds / 60000).round().toString().padLeft(2, '0');
    var seconds =
    ((milliseconds / 1000) % 60).round().toString().padLeft(2, '0');

    return "$minutes:$seconds";
  }

  List<LatLng> _latLngList = [];
  List<LatLng> get latLngList => _latLngList;
  void addToLatLngList(LatLng latLng) => _latLngList.add(latLng);

  double _sessionDistance = 0.0;
  double get sessionDistance => _sessionDistance;
  void addToTotalDistance(double distance) => _sessionDistance += distance;

  List<double> _speedList = [];
  List<double> get speedList => _speedList;
  void addToSpeedList(double speed) => _speedList.add(speed);

  int _stepCount = 0;
  int get stepCount => _stepCount;
  void setStepCount(int steps) => _stepCount = steps;
}