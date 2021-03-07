import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:give_away/models/item.dart';
import 'package:give_away/screens/item_detail_screen.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;
Color color = Colors.red[300];

class FeedScreen extends StatefulWidget {
  static const String id = 'feed_screen';

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    }
    catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ItemsStream()
            ],
          ),
        ),
      ),
    );
  }
}

class ItemBox extends StatelessWidget {
  final Item item;

  ItemBox({this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context, new MaterialPageRoute(builder: (context) => new ItemDetailScreen(item: item)));
        },
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Material(
              color: Colors.red[200],
              elevation: 8.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 80.0,
                      child: (item.imageUrl != null) ? Image.network(item.imageUrl) : Image.network('https://placekitten.com/200/300'),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      item.itemName,
                      style: TextStyle(
                          fontSize: 20.0
                      ),
                    ),
                    Text(
                      'USD ' + item.price.toString(),
                      style: TextStyle(
                          fontSize: 20.0
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}

class ItemsStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('items').orderBy('createdAt').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: color,
            ),
          );
        }
        final items = snapshot.data.docs;
        List<ItemBox> itemBoxes = [];

        for (var item in items) {
          final currentItemData = item.data();

          final currentItem = new Item(
            documentId: currentItemData['documentId'],
            itemName: currentItemData['itemName'],
            description: currentItemData['description'],
            contact: currentItemData['contact'],
            category: currentItemData['category'],
            available: currentItemData['available'],
            price: currentItemData['price'].toDouble(),
            author: currentItemData['author'],
            createdAt: (item.data()['createdAt'] as Timestamp).toDate(),
            location: currentItemData['location'],
            imageUrl: currentItemData['imageUrl'],
          );

          // final currentUser = loggedInUser.email;
          final itemBox = ItemBox(item: currentItem);
          itemBoxes.add(itemBox);
        }

        return Expanded(
            child: CustomScrollView(
              primary: false,
              slivers: <Widget>[
                SliverPadding(
                  padding: EdgeInsets.all(10),
                  sliver: SliverGrid.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: itemBoxes,
                  ),
                )
              ],
            )
        );
      },
    );
  }
}