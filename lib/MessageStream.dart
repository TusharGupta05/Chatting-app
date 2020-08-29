import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageStream {
  static String sender, receiver;

  List<DocumentSnapshot> merge(QuerySnapshot a, QuerySnapshot b) {
    // List<Map<String, Map<String, dynamic>>> map1 = List();
    // a.docs.toList().forEach((element) {
    //   map1.add({element.id: element.data()});
    // });
    // List<Map<String, Map<String, dynamic>>> map2 = List();
    // b.docs.toList().forEach((element) {
    //   map2.add({element.id: element.data()});
    // });
    // print(Rx.merge([, b]).toString());
    List<DocumentSnapshot> snap1 = a.docs ?? [];
    List<DocumentSnapshot> snap2 = b.docs ?? [];
    List<DocumentSnapshot> ret = List();
    int len1 = snap1.length, len2 = snap2.length, j = 0, k = 0;
    while (j < len1 && k < len2) {
      if (snap1.elementAt(j).id.compareTo(snap2.elementAt(k).id) < 0) {
        ret.add(snap1.elementAt(j));
        j++;
      } else {
        ret.add(snap2.elementAt(k));
        k++;
      }
    }
    while (j < len1) {
      ret.add(snap1.elementAt(j));
      j++;
    }
    while (k < len2) {
      ret.add(snap2.elementAt(k));
      k++;
    }
    return ret;
  }

  Widget getListTile(Map<String, dynamic> element, {bool focus = false}) {
    if (sender.compareTo(element["user"]) != 0) {
      return ListTile(
        autofocus: focus,
        contentPadding: EdgeInsets.only(left: 10, right: 60),
        title: Container(
          child: Wrap(alignment: WrapAlignment.start, children: [
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
                element["message"] ?? "",
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
        subtitle: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Icon(
            Icons.watch_later,
            size: 12,
            color: Colors.green[300],
          ),
          Text(
            stringToTime(element["createdAt"]),
            style: TextStyle(
              fontSize: 10,
              color: Colors.black87,
            ),
          )
        ]),
      );
    } else {
      return ListTile(
        autofocus: focus,
        contentPadding: EdgeInsets.only(left: 60, right: 10),
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
                element["message"] ?? "",
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
        subtitle: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Icon(
            Icons.watch_later,
            size: 12,
            color: Colors.green[300],
          ),
          Text(
            stringToTime(element["createdAt"]),
            style: TextStyle(
              fontSize: 10,
              color: Colors.black87,
            ),
          )
        ]),
      );
    }
  }
}

String timeToString() {
  return DateTime.now().toString().replaceAll(RegExp(r'\.|:|-| '), "");
}

String stringToTime(String createdAt) {
  String year = createdAt.substring(0, 4);
  String month = createdAt.substring(4, 6);
  String date = createdAt.substring(6, 8);
  String hours = createdAt.substring(8, 10);
  String min = createdAt.substring(10, 12);
  return "$year-$month-$date $hours:$min";
}
