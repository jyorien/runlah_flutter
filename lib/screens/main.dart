import 'package:flutter/material.dart';
import 'package:runlah_flutter/screens/signup_screen.dart';
import 'login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return MaterialApp(
      title: 'RunLah',
      home: LoginScreen(),
      theme: ThemeData(
          primaryColor: Colors.deepPurple,
          accentColor: Colors.green,
          bottomNavigationBarTheme: BottomNavigationBarThemeData()),
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        SignUpScreen.id: (context) => SignUpScreen()
      },
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
