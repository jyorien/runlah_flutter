import 'package:flutter/material.dart';
import 'package:runlah_flutter/screens/dashboard_screen.dart';
import 'package:runlah_flutter/screens/record_screen.dart';
import 'package:runlah_flutter/screens/settings_screen.dart';
import 'package:runlah_flutter/screens/today_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  static const id = 'main_screen';

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _currentIndex = 0;
  List<Widget> tabs = [TodayScreen(), RecordScreen(), DashboardScreen()];
  AppBar appBar;
  void navigateToSettings() {
    Navigator.pushNamed(context, SettingsScreen.id);
  }
  bool isLandscape;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      setState(() => isLandscape = true);
    }

    else {
      setState(() => isLandscape = false);
    }
    AppBar todayAppBar = AppBar(
      title: Text("Today"),
      actions: [
        IconButton(
          icon: Icon(Icons.settings),
          padding: EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          onPressed: () {
            Navigator.pushNamed(context, SettingsScreen.id);
          },
        )
      ],
    );
    if (_currentIndex == 0 && MediaQuery.of(context).orientation == Orientation.portrait) appBar = todayAppBar;
    else appBar = null;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
    }
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: isLandscape ? null :BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Today",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_run), label: "Record"),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard")
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            setState(() {
              switch (_currentIndex) {
                case 0:
                  appBar = todayAppBar;
                  break;
                default:
                  appBar = null;
                  break;
              }
            });
          });
        },
      ),
      body: SafeArea(
        child: Container(
          child: tabs[_currentIndex],
          decoration: isLandscape ? BoxDecoration(border: Border.all(width: 200)) : BoxDecoration(),
        ),
      ),
    );
  }
}
