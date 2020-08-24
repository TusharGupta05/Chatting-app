import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:last_task/Screens/MessageStream.dart';
import 'package:last_task/Toast.dart';

String email = "", password = "";

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "Let's Chat",
          style: TextStyle(color: Colors.white),
        ),
      ),
      resizeToAvoidBottomPadding: false,
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      email = value == null ? "" : value;
                    },
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
                        color: Colors.green[300],
                      ),
                      labelText: "Email",
                      labelStyle:
                          TextStyle(color: Colors.green[800], fontSize: 18),
                    ),
                    style: TextStyle(color: Colors.green[800], fontSize: 18),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  PasswordTF(),
                  RaisedButton(
                    onPressed: () {
                      if (email != "" &&
                          email.contains("@") &&
                          password != null &&
                          password.length >= 6) {
                        Firestore.instance
                            .collection("Users")
                            .document(email)
                            .get()
                            .then((value) {
                          if (value.exists) {
                            if (value.data.containsValue(password)) {
                              Toastit("Login Successful!!",
                                  color: Colors.blueGrey);
                              MessageStream.sender = email;
                              Navigator.of(context).pushReplacementNamed(
                                  "/UsersList",
                                  arguments: email);
                            } else {
                              Toastit(
                                "Please check password...",
                              );
                            }
                          } else {
                            Toastit(
                              "User not registered...",
                            );
                          }
                        });
                      } else {
                        Toastit(
                          "Please enter correct details..",
                        );
                      }
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  RichText(
                      text: TextSpan(
                          text: "Don't have an account? ",
                          style:
                              TextStyle(color: Colors.green[500], fontSize: 16),
                          children: <TextSpan>[
                        TextSpan(
                            text: "Register",
                            style: TextStyle(
                                color: Colors.blue[800],
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context)
                                    .pushReplacementNamed("/Register");
                              })
                      ]))
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 60.0, right: 60.0, bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: () => null,
                color: Colors.green,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Image.asset(
                        'assets/images/googleicon.png',
                        color: Colors.green[200],
                        height: 22,
                        width: 22,
                      ),
                    ),
                    Text(
                      "Signin with Google",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: () => null,
                color: Colors.green,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Image.asset(
                        'assets/images/fbicon.png',
                        color: Colors.green[200],
                        height: 18,
                        width: 18,
                      ),
                    ),
                    Text(
                      "Signin with Facebook",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}

class PasswordTF extends StatefulWidget {
  PasswordTF({Key key}) : super(key: key);

  @override
  _PasswordTFState createState() => _PasswordTFState();
}

class _PasswordTFState extends State<PasswordTF> {
  bool hidePass = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        obscureText: hidePass,
        onChanged: (value) {
          password = value == null ? "" : value;
        },
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
            icon: Icon(hidePass ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                hidePass = !hidePass;
              });
            },
          ),
          labelText: "Password",
          labelStyle: TextStyle(
            color: Colors.green[800],
            fontSize: 18,
          ),
        ),
        style: TextStyle(color: Colors.green[800], fontSize: 18),
      ),
    );
  }
}
