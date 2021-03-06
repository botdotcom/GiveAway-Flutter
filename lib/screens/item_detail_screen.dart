import 'package:flutter/material.dart';

import 'package:give_away/models/item.dart';

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
          )
        ),
      );
  }
}