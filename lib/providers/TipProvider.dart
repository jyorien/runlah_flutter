import 'package:flutter/cupertino.dart';
import 'package:runlah_flutter/utils/Tips.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TipProvider {
  static final dailyTip = "DAILY_TIP";
  static final previousYear = "YEAR";
  static final previousMonth = "MONTH";
  static final previousDay = "DAY";

  void setTip() async {
    var now = DateTime.now();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(dailyTip)) {
      String tip = Tip.tipOfDay();
      prefs.setInt(previousYear, now.year);
      prefs.setInt(previousMonth, now.month);
      prefs.setInt(previousDay, now.day);
      prefs.setString(dailyTip, tip);
      return;
    }

    var prevYear = prefs.getInt(previousYear) ?? now.year;
    var prevMonth = prefs.getInt(previousMonth) ?? now.month;
    var prevDay = prefs.getInt(previousDay) ?? now.day;
    var prevTip = prefs.getString(dailyTip);
    if (prevYear != now.year || prevMonth != now.month || prevDay != now.day) {
      print("now ${now.day}");
      print("now $prevDay");
      var tip = Tip.tipOfDay();
      if (tip == prevTip)
        tip = Tip.tipOfDay();
      prefs.setInt(previousYear, now.year);
      prefs.setInt(previousMonth, now.month);
      prefs.setInt(previousDay, now.day);
      prefs.setString(dailyTip, tip);
      return;
    }
  }

  Future<String> getTip() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(dailyTip) ?? "Drink more water!";
  }
}
