import 'package:flutter/material.dart';

Widget hiddenLetter(String char, bool visible, List atom) {
  if (atom.length <= 6) {
    return Container(
      height: 40,
      width: 40,
      color: Colors.black,
      child: Visibility(
          visible: !visible,
          child: Center(
              child: Text(char,
                  style: TextStyle(color: Colors.white, fontSize: 16)))),
    );
  }
  if (atom.length <= 8) {
    return Container(
      height: 30,
      width: 30,
      color: Colors.black,
      child: Visibility(
          visible: !visible,
          child: Center(
              child: Text(char,
                  style: TextStyle(color: Colors.white, fontSize: 16)))),
    );
  } else {
    return Container(
      height: 25,
      width: 25,
      color: Colors.black,
      child: Visibility(
          visible: !visible,
          child: Center(
              child: Text(char,
                  style: TextStyle(color: Colors.white, fontSize: 16)))),
    );
  }
}
