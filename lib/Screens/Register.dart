import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:last_task/MessageStream.dart';
import 'package:last_task/Screens/LoadingAlertDialog.dart';

import '../Toast.dart';

String email = "";
List<String> s = ["", ""];

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
            PasswordTF(
              show: "Password",
              i: 0,
            ),
            PasswordTF(
              show: "Confirm Password",
              i: 1,
            ),
            RaisedButton(
              onPressed: () {
                if (email.contains("@") && !email.contains(" ")) {
                  if (s.elementAt(0).compareTo(s.elementAt(1)) == 0 &&
                      s.elementAt(0).length >= 6) {
                    showLoaderDialog(context, "Please wait....");
                    FirebaseFirestore.instance
                        .collection("Users")
                        .doc(email)
                        .get()
                        .then((value) {
                      if (value.exists) {
                        Navigator.pop(context);
                        Toastit("User already registered...");
                      } else {
                        FirebaseFirestore.instance
                            .collection("Users")
                            .doc(email)
                            .set({"password": s.elementAt(0)}).then((value) {
                          Navigator.pop(context);
                          Toastit("Registered Successfully!!",
                              color: Colors.blueGrey);
                          MessageStream.sender = email;
                          Navigator.pushReplacementNamed(context, "/UsersList",
                              arguments: email);
                        });
                      }
                    });
                  } else {
                    if (s.elementAt(0).length < 6)
                      Toastit(
                          "Password should contain atleast 6 characters...");
                    else
                      Toastit("Please confirm password...");
                  }
                } else {
                  Toastit("Enter correct email address");
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
  final int i;
  final String show;

  const PasswordTF({Key key, this.i, this.show}) : super(key: key);

  @override
  _PasswordTFState createState() => _PasswordTFState();
}

class _PasswordTFState extends State<PasswordTF> {
  bool hidePass = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      TextField(
        obscureText: hidePass,
        keyboardType: TextInputType.visiblePassword,
        cursorColor: Colors.green,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.green[800])),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.green[800])),
          icon: ImageIcon(
            AssetImage("assets/images/lockicon.png"),
            size: 25,
            color: Colors.green[300],
          ),
          suffixIcon: IconButton(
            icon: Icon(hidePass ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                hidePass = !hidePass;
              });
            },
          ),
          labelText: widget.show,
          labelStyle: TextStyle(
            color: Colors.green[800],
            fontSize: 18,
          ),
        ),
        onChanged: (value) {
          s[widget.i] = value == null ? "" : value;
        },
        style: TextStyle(color: Colors.green[800], fontSize: 18),
      ),
      SizedBox(
        height: 5,
      ),
    ]));
  }
}
