import 'package:flutter/material.dart';
class CircularMaterialButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  CircularMaterialButton({this.text, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      color: Colors.deepPurpleAccent,
      child: MaterialButton(
        minWidth: 200,
        child: Text(text, style: TextStyle(color: Colors.white),),
        onPressed: onPressed,
      ),
    );
  }
}
