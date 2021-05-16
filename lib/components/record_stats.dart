import 'package:flutter/material.dart';

import '../constants.dart';

class RecordStats extends StatelessWidget {
  final String timeTaken;
  final String stepCount;
  final String averageSpeed;
  final String sessionDistance;

  RecordStats(
      {this.timeTaken,
      this.stepCount,
      this.averageSpeed,
      this.sessionDistance});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          timeTaken,
          style: TextStyle(fontSize: 70),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  stepCount,
                  style: kStatsNumStyle,
                ),
                Text(
                  'Steps',
                  style: kStatsTextStyle,
                ),
              ],
            ),
            Column(
              children: [
                Text("$sessionDistance km", style: kStatsNumStyle),
                Text('Distance', style: kStatsTextStyle),
              ],
            ),
            Column(
              children: [
                Text("$averageSpeed m/s", style: kStatsNumStyle),
                Text('Speed', style: kStatsTextStyle),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
