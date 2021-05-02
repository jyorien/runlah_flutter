import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:runlah_flutter/constants.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              obscureText: true,
              decoration: kInputDecoration.copyWith(hintText: 'Password'),
            ),
            SizedBox(height: 20,),
            Material(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: Colors.lightBlueAccent,
              child: MaterialButton(
                minWidth: 200,
                child: Text('Login', style: TextStyle(color: Colors.white),),
                onPressed: (){},
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              child: Text('No account? Sign up here!'),
            )
          ],
        ),
      )),
    );
  }
}
