import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:last_task/Screens/MessageStream.dart';

import '../Toast.dart';

String email = "", s1 = "", s2 = "";

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.emailAddress,
              cursorColor: Colors.green,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.green[800])),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.green[800])),
                icon: Icon(
                  Icons.email,
                  color: Colors.green,
                ),
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.green[800], fontSize: 18),
              ),
              onChanged: (value) {
                email = value == null ? "" : value;
              },
              style: TextStyle(color: Colors.green[800], fontSize: 18),
            ),
            SizedBox(
              height: 5,
            ),
            PasswordTF(),
            RaisedButton(
              onPressed: () {
                if (email.contains("@") && !email.contains(" ")) {
                  if (s1 == s2 && s1.length >= 6) {
                    Firestore.instance
                        .collection("Users")
                        .document(email)
                        .get()
                        .then((value) {
                      if (value.exists) {
                        Toastit("User already registered...");
                      } else {
                        Firestore.instance
                            .collection("Users")
                            .document(email)
                            .setData({"password": s1}).then((value) {
                          Toastit("Registered Successfully!!",
                              color: Colors.blueGrey);
                          MessageStream.sender = email;
                          Navigator.pushReplacementNamed(context, "/UsersList",
                              arguments: email);
                        });
                      }
                    });
                  } else {
                    if (s1.length < 6)
                      Toastit(
                          "Password should contain atleast 6 characters...");
                    else
                      Toastit("Please confirm password...");
                  }
                } else {
                  Toastit("Email address should contain '@'");
                }
              },
              child: Text(
                "Register",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            RichText(
              text: TextSpan(
                  text: "Already have an account? ",
                  style: TextStyle(color: Colors.green, fontSize: 16),
                  children: <TextSpan>[
                    TextSpan(
                        text: "Login",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context)
                                .pushReplacementNamed("/Login");
                          },
                        style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline))
                  ]),
            )
          ],
        ),
      ),
    );
  }
}

class PasswordTF extends StatefulWidget {
  PasswordTF({Key key}) : super(key: key);

  @override
  _PasswordTFState createState() => _PasswordTFState();
}

class _PasswordTFState extends State<PasswordTF> {
  bool hidePass1 = true, hidePass2 = true;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      TextField(
        obscureText: hidePass1,
        keyboardType: TextInputType.visiblePassword,
        cursorColor: Colors.green,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.green[800])),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.green[800])),
          icon: Icon(
            Icons.lock,
            color: Colors.green,
          ),
          suffixIcon: IconButton(
            icon: Icon(hidePass1 ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                hidePass1 = !hidePass1;
              });
            },
          ),
          labelText: "Password",
          labelStyle: TextStyle(
            color: Colors.green[800],
            fontSize: 18,
          ),
        ),
        onChanged: (value) {
          s1 = value == null ? "" : value;
        },
        style: TextStyle(color: Colors.green[800], fontSize: 18),
      ),
      SizedBox(
        height: 5,
      ),
      TextField(
        obscureText: hidePass2,
        keyboardType: TextInputType.visiblePassword,
        cursorColor: Colors.green,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.green[800])),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.green[800])),
          icon: Icon(
            Icons.lock,
            color: Colors.green,
          ),
          suffixIcon: IconButton(
            icon: Icon(hidePass2 ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                hidePass2 = !hidePass2;
              });
            },
          ),
          labelText: "Confirm Password",
          labelStyle: TextStyle(
            color: Colors.green[800],
            fontSize: 18,
          ),
        ),
        onChanged: (value) {
          s2 = value == null ? "" : value;
        },
        style: TextStyle(color: Colors.green[800], fontSize: 18),
      ),
    ]));
  }
}
