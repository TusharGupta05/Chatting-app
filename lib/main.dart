import 'package:flutter/material.dart';

import 'Screens/Chat.dart';
import 'Screens/Login.dart';
import 'Screens/Register.dart';
import 'Screens/UsersList.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        "/Login": (BuildContext context) => Login(),
        "/Register": (BuildContext context) => Register(),
        "/UsersList": (BuildContext context) => UsersList(),
        "/Chat": (BuildContext context) => Chat(),
      },
      home: Login(),
    );
  }
}
