import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:last_task/MessageStream.dart';
import 'package:last_task/Toast.dart';

import '../MessageStream.dart';
import '../Toast.dart';

List<Widget> list = List();
MessageStream messageStream = MessageStream();
List<Map<String, dynamic>> old = List<Map<String, dynamic>>();
final firestoreInstance = FirebaseFirestore.instance.collection("Chat");
ScrollController scrollController = ScrollController();

class Chat extends StatelessWidget {
  String msg = "";
  TextEditingController controller = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
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
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              reverse: true,
              physics: NeverScrollableScrollPhysics(),
              controller: scrollController,
              child: Column(
                children: [
                  Container(
                    child: Container(
                        height: MediaQuery.of(context).size.height - 170,
                        child: Container(
                          child: StreamBuilder(
                              stream: getStream(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  scrollController.animateTo(0.0,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeOut);
                                  return ListView.builder(
                                    physics: RangeMaintainingScrollPhysics(),
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) =>
                                        messageStream.getListTile(
                                      snapshot.data
                                          .elementAt(
                                              snapshot.data.length - index - 1)
                                          .data(),
                                    ),
                                    reverse: true,
                                    controller: scrollController,
                                  );
                                }
                              }),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      minLines: 1,
                      controller: controller,
                      onChanged: (value) {
                        msg = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 25),
                        hintText: "Enter a message...",
                        suffixIcon: DecoratedBox(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.green),
                            child: IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                onPressed: () {
                                  if (msg.length > 0) {
                                    var key = timeToString();
                                    firestoreInstance
                                        .doc(MessageStream.sender)
                                        .collection(MessageStream.receiver)
                                        .doc(key)
                                        .set({
                                      "message": msg,
                                      "createdAt": key,
                                      "user": MessageStream.sender
                                    }).then((value) {
                                      msg = "";
                                      controller.text = "";
                                    }).catchError((error) {});
                                  } else {
                                    Toastit("Enter something...",
                                        color: Colors.grey[700]);
                                  }
                                })),
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
                ],
              ),
            )));
  }
}

getStream() {
  return Rx.combineLatest2(
      firestoreInstance
          .doc(MessageStream.sender)
          .collection(MessageStream.receiver)
          .snapshots(),
      firestoreInstance
          .doc(MessageStream.receiver)
          .collection(MessageStream.sender)
          .snapshots(),
      (a, b) => messageStream.merge(a, b));
}

String getDocumentId() {
  if (MessageStream.sender.compareTo(MessageStream.receiver) < 0) {
    return MessageStream.sender + " AND " + MessageStream.receiver;
  } else
    return MessageStream.receiver + " AND " + MessageStream.sender;
}
