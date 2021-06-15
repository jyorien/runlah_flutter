import 'package:flutter/foundation.dart';

class StopwatchProvider with ChangeNotifier {
  Stopwatch _stopwatch = Stopwatch();
  String get sessionTime => formatTime(_stopwatch.elapsedMilliseconds);

  void startStopwatch() => _stopwatch.start();
  void stopStopwatch() {
    _stopwatch.stop();
  }
  void resetStopwatch() {
    _stopwatch.reset();
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
}