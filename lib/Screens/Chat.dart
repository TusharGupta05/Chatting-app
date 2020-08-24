import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:last_task/DatabaseHelper.dart';
import 'package:last_task/Screens/MessageStream.dart';
import 'package:last_task/Screens/UsersList.dart';
import 'package:last_task/Toast.dart';
import 'package:last_task/time-stringconverter.dart';

import '../Message.dart';

DatabaseHelper databaseHelper = DatabaseHelper();
List<Widget> list = List();
MessageStream stream = MessageStream();
List<Map<String, dynamic>> old = List<Map<String, dynamic>>();

class Chat extends StatelessWidget {
  static String sender;
  static String receiver = UsersList.username;

  @override
  Widget build(BuildContext context) {
    sender = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
            "Messages",
            style: TextStyle(color: Colors.white),
          ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (option) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/Login', (route) => false);
              },
              itemBuilder: (BuildContext context) {
                return {'Logout'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: SizedBox(
            // else list view is covering appbar space also
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              reverse: true,
              physics: NeverScrollableScrollPhysics(),
              child: MessageTextField(),
            )));
  }
}

class MessageTextField extends StatefulWidget {
  MessageTextField({Key key}) : super(key: key);

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  String msg;
  TextEditingController controller;
  List<Widget> oldList = List();
  void initState() {
    super.initState();
    msg = "";
    controller = TextEditingController(text: msg);
    stream.setStream();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Container(
          height: MediaQuery.of(context).size.height - 170,
          child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: MessageStream.controller.stream,
              builder: (context, snapshot) {
                List<Widget> tempList = List();

                if (snapshot.hasData) {
                  list = List<Widget>();
                  List<Map<String, dynamic>> newList = snapshot.data;
                  old = List<Map<String, dynamic>>.of(newList);
                  newList.forEach((element) {
                    //debugPrint("me " + element["message"]);
                    //debugPrint("me " + list.length.toString());
                    if (element["createdAt"] != null &&
                        element["mode"] == "outgoing") {
                      tempList.add(ListTile(
                        contentPadding: EdgeInsets.only(left: 30, right: 10),
                        title: Container(
                          child: Wrap(alignment: WrapAlignment.end, children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                color: Colors.green[200],
                              ),
                              padding: EdgeInsets.all(8),
                              child: Text(
                                element["message"],
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  decorationColor: Colors.green[200],
                                  backgroundColor: Colors.green[200],
                                ),
                              ),
                            ),
                          ]),
                        ),
                        subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.watch_later,
                                size: 12,
                                color: Colors.green,
                              ),
                              Text(
                                stringToTime(element["createdAt"]),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black87,
                                ),
                              )
                            ]),
                      ));
                    } else if (element["createdAt"] != null) {
                      tempList.add(ListTile(
                        contentPadding: EdgeInsets.only(left: 30, right: 10),
                        title: Container(
                          child:
                              Wrap(alignment: WrapAlignment.start, children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                color: Colors.green[200],
                              ),
                              padding: EdgeInsets.all(8),
                              child: Text(
                                element["message"],
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  decorationColor: Colors.green[200],
                                  backgroundColor: Colors.green[200],
                                ),
                              ),
                            ),
                          ]),
                        ),
                        subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.watch_later,
                                size: 12,
                                color: Colors.green,
                              ),
                              Text(
                                stringToTime(element["createdAt"]),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black87,
                                ),
                              )
                            ]),
                      ));
                    }
                  });
                  //MessageStream.controller = StreamController.broadcast();
                }
                oldList = tempList;
                print("tempList : " + tempList.length.toString());
                print("list: " + oldList.length.toString());
                return ListView(
                  children: tempList,
                );
              })),
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: TextField(
          keyboardType: TextInputType.multiline,
          maxLines: 2,
          minLines: 1,
          controller: controller,
          onChanged: (value) {
            msg = value;
            //print(msg);
          },
          decoration: InputDecoration(
            // focusedBorder: OutlineInputBorder(
            //     borderSide: BorderSide(color: Colors.green[700])),
            prefixIcon: IconButton(
              onPressed: () => null,
              icon: Icon(Icons.attach_file),
              color: Colors.green,
            ),
            suffixIcon: DecoratedBox(
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                child: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 25,
                  ),
                  onPressed: () {
                    var key = timeToString();
                    Firestore.instance
                        .collection("Chat")
                        .document(Chat.sender)
                        .collection(Chat.receiver)
                        .document(key)
                        .setData({Chat.receiver: msg}).then((value) async {
                      var message =
                          Message(MessageStream.receiver, "outgoing", msg, key);
                      int res = await databaseHelper.insertMessage(message);
                      print("res : $res");
                      //Toastit(message.toString());
                      old.add(message.toMap());
                      MessageStream.controller.add(old);
                      setState(() {
                        msg = "";
                        controller.text = "";
                        // MessageStream.controller = StreamController.broadcast();
                        // MessageStream.controller.add(message.toMap());
                      });
                    }).catchError((error) {
                      Toastit(error.toString());
                    });
                  },
                )),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(60),
                borderSide: BorderSide(color: Colors.green[800])),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(60),
                borderSide: BorderSide(color: Colors.green[800])),
          ),
          cursorColor: Colors.green[800],
        ),
      ),
    ]);
  }
}
