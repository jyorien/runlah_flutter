import 'package:flutter/material.dart';
import 'package:light/light.dart';
import 'package:runlah_flutter/screens/bottmnav_screen.dart';
import 'package:runlah_flutter/screens/result_screen.dart';
import 'package:runlah_flutter/screens/signup_screen.dart';
import 'package:runlah_flutter/screens/today_screen.dart';
import 'package:screen/screen.dart';
import 'login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData themeData = ThemeData(
      primaryColor: Colors.deepPurple,
      accentColor: Colors.green,
      bottomNavigationBarTheme: BottomNavigationBarThemeData());

  ThemeData darkThemeData = ThemeData(
      primaryColor: Colors.black,
      accentColor: Colors.black54,
      bottomNavigationBarTheme: BottomNavigationBarThemeData());
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    Light().lightSensorStream.listen((event) async {
      if (event > 20)
        // setState(() => isDark = false);
        setState(() {
          Screen.setBrightness(0.5);
        });
      else
        setState(() {
          Screen.setBrightness(0);
        });
      double brightness = await Screen.brightness;
      print("light: $event");
      print("brightness: $brightness");
        // setState(() => isDark = true);
    });
    return MaterialApp(
      title: 'RunLah',
      home: LoginScreen(),
      theme: themeData,
      darkTheme: darkThemeData,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        SignUpScreen.id: (context) => SignUpScreen(),
        TodayScreen.id: (context) => TodayScreen(),
        BottomNavigationScreen.id: (context) => BottomNavigationScreen(),
      },
    );
  }
}

