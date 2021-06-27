import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runlah_flutter/providers/DarkThemePreferences.dart';
import 'package:runlah_flutter/screens/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  static const id = 'settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Settings"),),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Dark mode'),
                  Switch(
                      value: themeChange.isDark,
                      onChanged: (bool newValue) {
                        themeChange.isDark = newValue;
                      }),
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    FirebaseAuth auth = FirebaseAuth.instance;
                    auth.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.id, (route) => false);
                  },
                  child: Text("LOG OUT"),style: ElevatedButton.styleFrom(primary: Colors.deepPurple),)
            ],
          ),
        ),
      ),
    );
  }
}
