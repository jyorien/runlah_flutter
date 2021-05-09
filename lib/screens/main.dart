import 'package:flutter/material.dart';
import 'package:light/light.dart';
import 'package:provider/provider.dart';
import 'package:runlah_flutter/components/DarkThemePreferences.dart';
import 'package:runlah_flutter/screens/bottmnav_screen.dart';
import 'package:runlah_flutter/screens/result_screen.dart';
import 'package:runlah_flutter/screens/settings_screen.dart';
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
  bool isDark = false;
  var lightStream;
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void dispose() {
    lightStream.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentAppTheme();
  }
  void getCurrentAppTheme() async {
    themeChangeProvider.isDark = await themeChangeProvider.darkThemePreferences.getTheme();
  }
  @override
  Widget build(BuildContext context) {
    lightStream = Light().lightSensorStream.listen((event) async {
      // if light unit > 30, increase brightness
      if (event > 30)
        setState(() {
          Screen.setBrightness(0.3);
        });
      // if light unit < 30, dim screen
      else
        setState(() {
          Screen.setBrightness(0);
        });
      double brightness = await Screen.brightness;
    });
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget child) {
          return MaterialApp(
            title: 'RunLah',
            home: LoginScreen(),
            theme: Styles.themeData(themeChangeProvider.isDark, context),
            // theme: ThemeData.light().copyWith(
            //     primaryColor: Colors.deepPurple,
            //     accentColor: Colors.green,
            //     bottomNavigationBarTheme: BottomNavigationBarThemeData()),
            // darkTheme: ThemeData.dark().copyWith(
            //     scaffoldBackgroundColor: Colors.black87,
            //     accentColor: Colors.black54,
            //     bottomNavigationBarTheme: BottomNavigationBarThemeData()),
            // themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            routes: {
              LoginScreen.id: (context) => LoginScreen(),
              SignUpScreen.id: (context) => SignUpScreen(),
              TodayScreen.id: (context) => TodayScreen(),
              BottomNavigationScreen.id: (context) => BottomNavigationScreen(),
              SettingsScreen.id: (context) => SettingsScreen()
            },
          );
        },
      ),
    );
  }
}
