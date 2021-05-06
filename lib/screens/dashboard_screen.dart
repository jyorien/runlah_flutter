import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:runlah_flutter/components/card_tile.dart';
import 'package:runlah_flutter/constants.dart';

class DashboardScreen extends StatelessWidget {
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
          child: ListView(
            children: [
              CardTile(dateTime: "6 May 2021 9:0 pm", sessionDistance: "0.01", averageSpeed: "3.00", stepCount: "0", timeTaken: "00:00",),
              CardTile(dateTime: "6 May 2021 9:0 pm", sessionDistance: "0.01", averageSpeed: "3.00", stepCount: "0", timeTaken: "00:00",),
              CardTile(dateTime: "6 May 2021 9:0 pm", sessionDistance: "0.01", averageSpeed: "3.00", stepCount: "0", timeTaken: "00:00",),
              CardTile(dateTime: "6 May 2021 9:0 pm", sessionDistance: "0.01", averageSpeed: "3.00", stepCount: "0", timeTaken: "00:00",),
              CardTile(dateTime: "6 May 2021 9:0 pm", sessionDistance: "0.01", averageSpeed: "3.00", stepCount: "0", timeTaken: "00:00",),
            ],
          ),
        )
      ],
    );
  }
}
