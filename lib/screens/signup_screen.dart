import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runlah_flutter/components/circular_material_button.dart';
import 'package:runlah_flutter/constants.dart';
import 'package:runlah_flutter/screens/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const id = 'signup';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  FirebaseAuth _auth;
  String email;
  String password;
  String cfmPassword;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth = FirebaseAuth.instance;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // prevent keyb from pushing screen up
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Sign Up',
              style: kWelcomeTextStyle,
            ),
            SizedBox(height: 30),
            TextField(
              decoration: kInputDecoration.copyWith(hintText: 'Email'),
              onChanged: (value) => email = value,
            ),
            SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: kInputDecoration.copyWith(hintText: 'Password'),
              onChanged: (value) => password = value,
            ),
            SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: kInputDecoration.copyWith(hintText: 'Confirm Password'),
              onChanged: (value) => cfmPassword = value,
            ),
            SizedBox(
              height: 20,
            ),
            CircularMaterialButton(
              text: 'Sign Up',
              onPressed: () async {
                try {
                  if (password != cfmPassword) {
                    final snackBar = SnackBar(content: Text("Passwords do not match"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }
                  if (password.length < 6 || cfmPassword.length < 6) {
                    final snackBar = SnackBar(content: Text("Password must have 6 or more characters"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }

                  final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                  if (newUser != null) {
                    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => false);
                  }
                }  on FirebaseAuthException catch (e) {
                  final snackBar = SnackBar(content: Text(e.toString()));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              child: Text('Have an account? Log in here!'),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (Route<dynamic> route)=>false);
              },
            )
          ]),
        ),
      ),
    );
  }
}
