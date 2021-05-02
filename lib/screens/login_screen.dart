import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:runlah_flutter/components/circular_material_button.dart';
import 'package:runlah_flutter/constants.dart';
import 'package:runlah_flutter/screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth _auth;
  String email;
  String password;
  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // prevent keyb from pushing screen up
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: kWelcomeTextStyle,
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              decoration: kInputDecoration.copyWith(hintText: 'Email'),
              onChanged: (value) => email = value,
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              obscureText: true,
              decoration: kInputDecoration.copyWith(hintText: 'Password'),
              onChanged: (value) => password = value,
            ),
            SizedBox(height: 20,),
            CircularMaterialButton(text: 'Login',onPressed:() async {
              final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
              if (user != null) {
                print(user);
              }

            },),
            SizedBox(height: 20,),
            GestureDetector(
              child: Text('No account? Sign up here!'),
              onTap: () {
                Navigator.pushNamed(context, SignUpScreen.id);
              },
            )
          ],
        ),
      )),
    );
  }
}
