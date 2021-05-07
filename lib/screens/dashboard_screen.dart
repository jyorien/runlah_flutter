import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:runlah_flutter/components/card_tile.dart';
import 'package:runlah_flutter/constants.dart';

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
            double distance = currentIndex["distanceTravelled"];
            double speed = currentIndex["averageSpeed"];
            return CardTile(
              timeTaken: currentIndex["timeTaken"].toString(),
              sessionDistance: distance.toStringAsFixed(2),
              averageSpeed: speed.toStringAsFixed(2),
              stepCount: currentIndex["stepCount"].toString(),

            );
          })
        )
      ],
    );
  }
}
