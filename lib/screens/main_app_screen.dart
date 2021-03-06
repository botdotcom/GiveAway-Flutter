import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:give_away/screens/feed_screen.dart';
import 'package:give_away/screens/new_item_screen.dart';

class MainAppScreen extends StatefulWidget {
  static const String id = 'main_app_screen';

  @override
  _MainAppScreenState createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  final _auth = FirebaseAuth.instance;
  int _currentIndex = 0;
  final List<Widget> _children = [FeedScreen(), NewItemScreen()];
  Color color = Colors.red[300];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GiveAway'
        ),
        backgroundColor: color,
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        fixedColor: color,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.apps_rounded),
            title: Text(
              'Feed'
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text(
              'New Item'
            )
          ),
        ],
      )
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}