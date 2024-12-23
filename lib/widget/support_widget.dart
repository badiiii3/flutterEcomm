import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle boldTextFeildStyle() {
    return TextStyle(
        color: Colors.black, fontSize: 28.0, fontWeight: FontWeight.bold);
  }

  static TextStyle lightTextFeildStyle() {
    return TextStyle(
        color: Colors.black54, fontSize: 20.0, fontWeight: FontWeight.w500);
  }

  static TextStyle semiBoldTextFieldStyle() {
    return TextStyle(
        color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold);
  }

  static TextStyle orangeTextFieldStyle() {
    return TextStyle(
        color: Color(0xFFfd6f3e), fontSize: 20.0, fontWeight: FontWeight.bold);
  }
}
