import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class Toastit {
  Toastit(value, {color = Colors.red}) {
    Fluttertoast.showToast(
        msg: value,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
