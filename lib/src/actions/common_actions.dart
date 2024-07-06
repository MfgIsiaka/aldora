import 'package:flutter/material.dart';

class commonActions {
  static void shiftPage(context, Widget nexPage) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => nexPage));
  }
}
