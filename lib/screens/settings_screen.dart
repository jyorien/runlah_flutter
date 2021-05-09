import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runlah_flutter/components/DarkThemePreferences.dart';

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
     body: SafeArea(
       child: Padding(
         padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
         child: Column(
           children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text('Dark mode'),
                 Switch(value: themeChange.isDark, onChanged: (bool newValue) {
                  themeChange.isDark = newValue;
                 }),
               ],
             )
           ],
         ),
       ),
     ), 
    );
  }
}
