import 'package:flutter/material.dart';
import 'package:runlah_flutter/screens/dashboard_screen.dart';
import 'package:runlah_flutter/screens/record_screen.dart';
import 'package:runlah_flutter/screens/today_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  static const id = 'main_screen';

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _currentIndex = 0;
  List<Widget> tabs = [TodayScreen(), RecordScreen(), DashboardScreen()];
  PageController _pageController = PageController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
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
            _pageController.jumpToPage(index);
          });
        },
      ),
      body: PageView(
        controller: _pageController,
        children: [TodayScreen(), RecordScreen(), DashboardScreen()],
        onPageChanged: (index) {
          _currentIndex = index;
        },
      ),
    );
  }
}
