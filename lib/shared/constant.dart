import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
  focusedBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 2)),
);
const newtextInputDecoration = InputDecoration(
  fillColor: Colors.transparent,
  filled: true,
  enabledBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
  focusedBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 2)),
);
final btnStyle = ButtonStyle(
    shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    elevation: MaterialStateProperty.all<double>(30),
    shadowColor: MaterialStateProperty.all<Color>(Colors.lightBlue));
final mainbtnStyle = ButtonStyle(
    shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
    elevation: MaterialStateProperty.all<double>(30),
    shadowColor: MaterialStateProperty.all<Color>(Colors.lightBlue));
final greybtn = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
    elevation: MaterialStateProperty.all<double>(30),
    shadowColor: MaterialStateProperty.all<Color>(Colors.blueGrey));
