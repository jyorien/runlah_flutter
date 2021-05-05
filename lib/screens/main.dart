import 'package:flutter/material.dart';
import 'package:runlah_flutter/screens/bottmnav_screen.dart';
import 'package:runlah_flutter/screens/result_screen.dart';
import 'package:runlah_flutter/screens/signup_screen.dart';
import 'package:runlah_flutter/screens/today_screen.dart';
import 'login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RunLah',
      home: LoginScreen(),
      theme: ThemeData(
          primaryColor: Colors.deepPurple,
          accentColor: Colors.green,
          bottomNavigationBarTheme: BottomNavigationBarThemeData()),
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        SignUpScreen.id: (context) => SignUpScreen(),
        TodayScreen.id: (context) => TodayScreen(),
        BottomNavigationScreen.id: (context) => BottomNavigationScreen(),
        ResultScreen.id: (context) => ResultScreen()
      },
    );
  }
}

