import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:give_away/models/item.dart';

final _firestore = FirebaseFirestore.instance;

// This component was adopted partly from here: https://medium.com/@agungsurya/create-a-simple-animated-floatingactionbutton-in-flutter-2d24f37cfbcc
class FloatingButtonAnimate extends StatefulWidget {
  final Function() onPressed;
  final String tooltip;
  final IconData icon;
  final Item item;

  FloatingButtonAnimate({this.onPressed, this.tooltip, this.icon, this.item});

  @override
  _FloatingButtonAnimateState createState() => _FloatingButtonAnimateState();
}

class _FloatingButtonAnimateState extends State<FloatingButtonAnimate>
    with SingleTickerProviderStateMixin {
    bool isOpened = false;
    AnimationController _animationController;
    Animation<Color> _buttonColor;
    Animation<double> _animateIcon;
    Animation<double> _translateButton;
    Curve _curve = Curves.easeOut;
    double _fabHeight = 56.0;

    @override
    initState() {
      _animationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 500))
        ..addListener(() {
          setState(() {});
        });
      _animateIcon =
          Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
      _buttonColor = ColorTween(
        begin: Colors.red[300],
        end: Colors.red[700],
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.00,
          1.00,
          curve: Curves.linear,
        ),
      ));
      _translateButton = Tween<double>(
        begin: _fabHeight,
        end: -14.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.0,
          0.75,
          curve: _curve,
        ),
      ));
      super.initState();
    }

    @override
    dispose() {
      _animationController.dispose();
      super.dispose();
    }

    animate() {
      if (!isOpened) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      isOpened = !isOpened;
    }

    Widget edit() {
      return Container(
        child: FloatingActionButton(
          onPressed: () {
            print("Want to edit this item");
          },
          tooltip: 'Edit',
          child: Icon(Icons.edit),
          backgroundColor: _buttonColor.value,
        ),
      );
    }

    Widget delete() {
      return Container(
        child: FloatingActionButton(
          onPressed: () {
            print("Want to delete this item");
            // print();
          },
          tooltip: 'Image',
          child: Icon(Icons.delete_rounded),
          backgroundColor: _buttonColor.value,
        ),
      );
    }

    Widget toggle() {
      return Container(
        child: FloatingActionButton(
          backgroundColor: _buttonColor.value,
          onPressed: animate,
          tooltip: 'Toggle',
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _animateIcon,
          ),
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Transform(
            transform: Matrix4.translationValues(
              0.0,
              _translateButton.value * 2.0,
              0.0,
            ),
            child: delete(),
          ),
          Transform(
            transform: Matrix4.translationValues(
              0.0,
              _translateButton.value * 1.0,
              0.0,
            ),
            child: edit(),
          ),
          toggle(),
        ],
      );
    }

    // delete of CRUD
    void deleteItem(String documentId) {
      _firestore.collection('items').doc(documentId).delete()
          .then((value) => print("Item deleted"))
          .catchError((onError) => print("Failed to delete item"));
    }
}