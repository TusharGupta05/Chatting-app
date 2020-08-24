import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:last_task/NewAppBar.dart';
import 'package:last_task/Screens/MessageStream.dart';

final firestoreInstance = Firestore.instance.collection("Users");

class UsersList extends StatelessWidget {
  static String username = "";
  @override
  Widget build(BuildContext context) {
    debugPrint(ModalRoute.of(context).settings.arguments);
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
      body: UsersListView(),
    );
  }
}

class UsersListView extends StatefulWidget {
  UsersListView({Key key}) : super(key: key);

  @override
  _UsersListViewState createState() => _UsersListViewState();
}

class _UsersListViewState extends State<UsersListView> {
  List<Widget> list = List();

  @override
  Widget build(BuildContext context) {
    list = List();
    return StreamBuilder(
        stream: firestoreInstance.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            snapshot.data.documents
                .where((element) =>
                    element.documentID !=
                    ModalRoute.of(context).settings.arguments)
                .forEach((element) {
              //print(element.documentID);
              //print(list.length);
              list.add(ListTile(
                onTap: () {
                  setState(() {
                    UsersList.username = element.documentID;
                    MessageStream.receiver = element.documentID;
                  });
                  Navigator.pushNamed(
                    context,
                    "/Chat",
                    arguments: ModalRoute.of(context).settings.arguments,
                  );
                },
                title: Text(element.documentID,
                    style: TextStyle(color: Colors.green[800], fontSize: 20)),
              ));
              list.add(Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  color: Colors.green,
                  height: 1,
                  width: double.infinity,
                ),
              ));
            });
            return ListView(
              children: list,
            );
          } else {
            return Center(
              child: Container(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
