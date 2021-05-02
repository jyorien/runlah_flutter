import 'package:flutter/material.dart';
import 'login_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RunLah',
      home: LoginScreen(),
      theme: ThemeData(primaryColor: Colors.deepPurple, accentColor:Colors.green, bottomNavigationBarTheme: BottomNavigationBarThemeData()),
    );
  }
}


/*  BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "Today"),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_run), label: "Record"),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard")
        ],
      ),
* */
