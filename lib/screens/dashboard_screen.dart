import 'dart:collection';import 'package:cloud_firestore/cloud_firestore.dart';import 'package:firebase_auth/firebase_auth.dart';import 'package:fl_chart/fl_chart.dart';import 'package:flutter/material.dart';import 'package:google_maps_flutter/google_maps_flutter.dart';import 'package:runlah_flutter/components/card_tile.dart';import 'package:runlah_flutter/constants.dart';import 'package:intl/intl.dart';import 'package:runlah_flutter/screens/history_screen.dart';class DashboardScreen extends StatefulWidget {  @override  _DashboardScreenState createState() => _DashboardScreenState();}class _DashboardScreenState extends State<DashboardScreen> {  var dataList = [];  DateTime today;  Map<int, double> chartData = {};  List<Record> listData = [];  Widget barChart = BarChart(BarChartData());  String formatMinutes(String minute) {    var min = minute;    if (int.parse(minute) < 10) min = "0$minute";    return min;  }  @override  void initState() {    getData();    super.initState();  }  void getData() async {    FirebaseFirestore firestore = FirebaseFirestore.instance;    FirebaseAuth auth = FirebaseAuth.instance;    var result = await firestore        .collection('users')        .doc(auth.currentUser.uid)        .collection('records')        .orderBy('timestamp', descending: true)        .get();    today = DateTime.now();    print("today's date: $today");    result.docs.forEach((element) {      final data = element.data();      dataList.add(data);    });    populateListData();    populateChart();    setState(() {});  }  void populateListData() {    dataList.forEach((currentIndex) {      String distance =          (currentIndex["distanceTravelled"] / 1000).toStringAsFixed(2);      String speed = (currentIndex["averageSpeed"]).toStringAsFixed(2);      Timestamp timestamp = currentIndex["timestamp"];      String timeTaken = currentIndex["timeTaken"];      String stepCount = currentIndex["stepCount"].toString();      // convert timestamp to datetime and format date      DateTime date = timestamp.toDate().toLocal();      var dayOfMonth = DateFormat.d().format(date);      var monthName = DateFormat.MMMM().format(date);      var year = DateFormat.y().format(date);      var hour = DateFormat.H().format(date);      var minute = DateFormat.m().format(date);      var displayDate =          "$dayOfMonth $monthName $year $hour:${formatMinutes(minute)}";      // get chart data      if (date.isAfter(today.subtract(Duration(days: 6)))) {        double sessionDistance = double.parse(distance);        if (chartData[dayOfMonth] == null)          chartData[int.parse(dayOfMonth)] = currentIndex["distanceTravelled"];        else          chartData[int.parse(dayOfMonth)] += currentIndex["distanceTravelled"];      }      // convert to map so it is iterable      Map<String, dynamic> map = {};      var givenList = currentIndex["coordinatesArray"];      // if data is from android kotlin app      if (givenList is List) {        int index = 0;        givenList.forEach((element) {          map[index.toString()] = {            'latitude': element["latitude"],            'longitude': element["longitude"]          };          index += 1;        });      } else        // if data is from flutter app        map = Map<String, dynamic>.from(givenList);      List<LatLng> listLatLng = [];      // get the latitude and longitude from the map to format into list of LatLng      map.forEach((key, value) {        var latitude = value["latitude"];        var longitude = value["longitude"];        listLatLng.add(LatLng(latitude, longitude));      });      listData.add(Record(          stepCount: stepCount,          timeTaken: timeTaken,          displayDate: displayDate,          distance: distance,          listLatLng: listLatLng,          speed: speed));    });  }  void populateChart() {    print(chartData);    int lastIndex = today.day;    for (var i = lastIndex; i>lastIndex-7; i--) {      if (chartData[i] == null )        chartData[i] = 0.0;      chartData[i] = double.parse(chartData[i].toStringAsFixed(2));    }    final sortedMap = SplayTreeMap<int,double>.from(chartData, (a,b) => a > b ? 1: -1);    print(sortedMap);    List<BarChartGroupData> bars = [];    sortedMap.forEach((key, value) {      bars.add(          BarChartGroupData(              x: key, barRods: [BarChartRodData(y: value)]));    });    barChart = BarChart(      BarChartData(          barGroups: bars,          alignment: BarChartAlignment.spaceEvenly,          titlesData: FlTitlesData(            leftTitles: SideTitles(              showTitles: true,              getTitles: (value) {                // populate y axis titles                if (value % 1000 == 0) {                  print("value: ${value}");                  print("value/1000: ${value/1000}");                   return "${(value/1000).truncate()}K";                } else return '';              }            ),          ),        axisTitleData: FlAxisTitleData(          leftTitle: AxisTitle(showTitle: true, titleText: 'Distance (m)'),          bottomTitle: AxisTitle(showTitle: true, titleText: 'Day of month'),        ),        barTouchData: BarTouchData(          enabled: true,          touchTooltipData: BarTouchTooltipData(          )        )    ));    setState(() {});  }  @override  Widget build(BuildContext context) {    return Column(      children: [        Container(margin: EdgeInsets.only(top: 64, left: 10, right: 10),height: 300, alignment: Alignment.center, child: barChart),        Expanded(          child: ListView.builder(              itemCount: dataList.length,              itemBuilder: (context, index) {                var dataRef = listData[index];                return CardTile(                  timeTaken: dataRef.timeTaken,                  sessionDistance: dataRef.distance,                  averageSpeed: dataRef.speed,                  stepCount: dataRef.stepCount,                  dateTime: dataRef.displayDate,                  listLatLng: dataRef.listLatLng,                );              }),        )      ],    );  }}class Record {  String timeTaken;  String distance;  String speed;  String stepCount;  String displayDate;  List<LatLng> listLatLng;  Record(      {this.distance,      this.listLatLng,      this.timeTaken,      this.stepCount,      this.speed,      this.displayDate});}