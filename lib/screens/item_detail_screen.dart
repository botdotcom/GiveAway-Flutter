import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:give_away/components/floating_button_animate.dart';

import 'package:give_away/models/item.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
Item currentItem;
Color color = Colors.red[300];

class ItemDetailScreen extends StatelessWidget {
  static const String id = 'item_detail_screen';
  final Item item;

  ItemDetailScreen({@required this.item});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 300.0,
                      width: 300.0,
                      child: (item.imageUrl != null) ? Image.network(item.imageUrl) : Image.network('https://placekitten.com/200/300'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.lightbulb_outline_rounded
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Flexible(
                        child: Text(
                          item.itemName,
                          style: TextStyle(
                              fontSize: 20.0
                          ),
                        ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                        Icons.description_outlined
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Flexible(
                        child: Text(
                          item.description,
                          style: TextStyle(
                              fontSize: 20.0
                          ),
                        ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                        Icons.check
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Flexible(
                      child: Text(
                        item.category,
                        style: TextStyle(
                            fontSize: 20.0
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                        Icons.attach_money_outlined
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Flexible(
                      child: Text(
                        item.price.toString(),
                        style: TextStyle(
                            fontSize: 20.0
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          floatingActionButton: ( _checkFloatingAction())
          ? FloatingActionButton(
              backgroundColor: color,
              child: Icon(Icons.edit_outlined),
              onPressed: () {
                print(item.documentId);
                // deleteItem(item.documentId);
              },
            )
          : null,
          // floatingActionButton: ( _checkFloatingAction())
          //     ? FloatingButtonAnimate(item: item)
          //     : null,
        ),
      );
  }

  bool _checkFloatingAction() {
    User loggedInUser;

    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    }
    catch (e) {
      print(e);
    }

    if (loggedInUser.email == item.author) {
      return true;
    }
    else {
      return false;
    }
  }

  // update of CRUD
  void updateItemContact(String documentId, String contact) {
    _firestore.collection('items').doc(documentId).update({
      'contact': contact,
    }).then((value) => print("Contact updated"))
        .catchError((onError) => print("Failed to update contact"));
  }

  void updateItemPrice(String documentId, double price) {
    _firestore.collection('items').doc(documentId).update({
      'price': price,
    }).then((value) => print("Price updated"))
        .catchError((onError) => print("Failed to update price"));
  }

  void updateItemAvailability(String documentId, bool available) {
    _firestore.collection('items').doc(documentId).update({
      'available': available,
    }).then((value) => print("Availability updated"))
        .catchError((onError) => print("Failed to update availability"));
  }

  // delete of CRUD
  void deleteItem(String documentId) {
    _firestore.collection('items').doc(documentId).delete()
        .then((value) => print("Item deleted"))
        .catchError((onError) => print("Failed to delete item"));
  }
}