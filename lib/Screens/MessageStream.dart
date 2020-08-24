import 'dart:async';
import 'dart:core';

import 'package:last_task/DatabaseHelper.dart';
import 'package:last_task/Screens/UsersList.dart';

class MessageStream {
  DatabaseHelper helper = DatabaseHelper();
  var list;
  static StreamController<List<Map<String, dynamic>>> controller =
      StreamController.broadcast();

  static String sender, receiver;

  setStream() async {
    // int result = 1;
    // print("result : " + result.toString());
    // result = await helper.deleteMessage(Message("", "", "", "null"));
    list = List();
    controller.add([]);
    print("sender : $sender");
    print("receiver : $receiver");
    list = await helper.getMessageMapList(receiver);
    controller.add(list);
    //print("yessss");
  }

  // Future<List<Map<String, dynamic>>> get streamNow async {
  //   List<Map<String, dynamic>> newList = controller.add(newList);
  //   /*print("here length : " + list.length.toString());
  //   list = List<Widget>();
  //   print("here " + list.toString());
  //   //list.clear();
  //   newList.forEach((element) {
  //     debugPrint("me " + element["message"]);
  //     debugPrint("me " + list.length.toString());
  //     if (element["mode"] == "outgoing") {
  //       list.add(ListTile(
  //         contentPadding: EdgeInsets.only(left: 30, right: 10),
  //         title: Container(
  //           child: Wrap(alignment: WrapAlignment.end, children: [
  //             Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(10),
  //                     bottomLeft: Radius.circular(10),
  //                     topRight: Radius.circular(10)),
  //                 color: Colors.green[200],
  //               ),
  //               padding: EdgeInsets.all(8),
  //               child: Text(
  //                 element["message"],
  //                 textAlign: TextAlign.end,
  //                 style: TextStyle(
  //                   fontSize: 15,
  //                   color: Colors.black,
  //                   decorationColor: Colors.green[200],
  //                   backgroundColor: Colors.green[200],
  //                 ),
  //               ),
  //             ),
  //           ]),
  //         ),
  //         subtitle: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
  //           Icon(
  //             Icons.watch_later,
  //             size: 12,
  //             color: Colors.green,
  //           ),
  //           Text(
  //             stringToTime(element["createdAt"]),
  //             style: TextStyle(
  //               fontSize: 10,
  //               color: Colors.black87,
  //             ),
  //           )
  //         ]),
  //       ));
  //     }
  //     // MessageStream.controller = new StreamController();
  //     // snapshot.data.clear();
  //     else {
  //       list.add(ListTile(
  //         contentPadding: EdgeInsets.only(left: 30, right: 10),
  //         title: Container(
  //           child: Wrap(alignment: WrapAlignment.end, children: [
  //             Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(10),
  //                     bottomLeft: Radius.circular(10),
  //                     topRight: Radius.circular(10)),
  //                 color: Colors.green[200],
  //               ),
  //               padding: EdgeInsets.all(8),
  //               child: Text(
  //                 element["message"],
  //                 textAlign: TextAlign.end,
  //                 style: TextStyle(
  //                   fontSize: 15,
  //                   color: Colors.black,
  //                   decorationColor: Colors.green[200],
  //                   backgroundColor: Colors.green[200],
  //                 ),
  //               ),
  //             ),
  //           ]),
  //         ),
  //         subtitle: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
  //           Icon(
  //             Icons.watch_later,
  //             size: 12,
  //             color: Colors.green,
  //           ),
  //           Text(
  //             stringToTime(element["createdAt"]),
  //             style: TextStyle(
  //               fontSize: 10,
  //               color: Colors.black87,
  //             ),
  //           )
  //         ]),
  //       ));
  //     }
  //   });*/
  //   // MessageStream.controller = new StreamController();
  //   // snapshot.data.clear();
  //   return newList;
  // }
  // /*else {
  //     List<Map<String, dynamic>> changes = List();
  //     List<String> ids = List();
  //     Firestore.instance
  //         .collection("Chat")
  //         .document(Chat.receiver)
  //         .collection(Chat.sender)
  //         .getDocuments()
  //         .then((value) => value.documents.forEach((element) async {
  //               changes.add(element.data);
  //               ids.add(element.documentID);
  //               var msg = Message(UsersList.usernsme, "incoming",
  //                   element.data["message"], element.data["createdAt"]);
  //               int result = await helper.insertMessage(msg);
  //               ids.forEach((element) {
  //                 Firestore.instance
  //                     .collection("Chat")
  //                     .document(Chat.receiver)
  //                     .collection(Chat.sender)
  //                     .document(element)
  //                     .delete();
  //               });
  //               print("result : $result");
  //               print("data " + element.data["message"]);
  //             }));

  //     //print("newEvent : " + event.documents.toString());
  //     //Toastit("success");
  //     controller.add(changes);
  //     yield changes;
  //   }*/
}
