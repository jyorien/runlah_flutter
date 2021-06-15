import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:runlah_flutter/providers/TipProvider.dart';
import 'package:runlah_flutter/screens/bottmnav_screen.dart';
import 'package:runlah_flutter/screens/login_screen.dart';

class InitialScreen extends StatelessWidget {
  static const id = "initial";
  const InitialScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TipProvider tipProvider = TipProvider();
    tipProvider.setTip();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null)
      return BottomNavigationScreen();
    else
      return LoginScreen();
  }
}
