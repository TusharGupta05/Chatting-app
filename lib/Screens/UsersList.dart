import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:last_task/MessageStream.dart';

final firestoreInstance = FirebaseFirestore.instance.collection("Users");

class UsersList extends StatelessWidget {
  static String username = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "Users",
          style: TextStyle(color: Colors.white),
        ),
        leading: null,
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
      body: StreamBuilder(
          stream: firestoreInstance.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              QuerySnapshot snap = snapshot.data;
              var list = snap.docs
                  .where((element) => element.id != MessageStream.sender);
              return ListView.separated(
                padding: EdgeInsets.all(8.0),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      MessageStream.receiver = list.elementAt(index).id;
                      Navigator.pushNamed(
                        context,
                        "/Chat",
                      );
                    },
                    title: Text(list.elementAt(index).id,
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 20)),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                ),
              );
            }
          }),
    );
  }
}
