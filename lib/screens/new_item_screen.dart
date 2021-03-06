import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import 'package:give_away/models/item.dart';
import 'package:give_away/components/rounded_button.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User loggedInUser;

class NewItemScreen extends StatefulWidget {
  static const String id = 'new_item_screen';

  @override
  _NewItemScreenState createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ItemCustomForm(),
      ),
    );
  }
}

class ItemCustomForm extends StatefulWidget {
  @override
  ItemCustomFormState createState() {
    return ItemCustomFormState();
  }
}

class ItemCustomFormState extends State<ItemCustomForm> {
  final _itemFormKey = GlobalKey<FormState>();
  Item _item = Item();
  Color color = Colors.red[300];
  String categoryDropdownValue = 'Clothes';
  List<String> categoryOptions = ['Clothes', 'Electronics', 'Furniture', 'Toys', 'Books', 'Supplies'];

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
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: SingleChildScrollView(
          // children: <Widget>[
          child:
            Form(
                key: _itemFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return '*Required field';
                        }
                        return null;
                      },
                      onChanged: (value) => _item.itemName = value,
                      keyboardType: TextInputType.text,
                      maxLength: 20,
                      autocorrect: true,
                      decoration: InputDecoration(
                        hintText: 'Item',
                        icon: Icon(Icons.fiber_new_outlined, color: color),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      onChanged: (value) => _item.description = value,
                      keyboardType: TextInputType.multiline,
                      maxLength: 200,
                      autocorrect: true,
                      decoration: InputDecoration(
                        hintText: 'Description',
                        icon: Icon(Icons.description_outlined, color: color),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        hintText: 'Category',
                        icon: Icon(Icons.check_rounded, color: color),
                      ),
                        items: categoryOptions.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                      }).toList(),
                        onChanged: (value) {
                        setState(() {
                          categoryDropdownValue = value;
                        });
                    },
                    onSaved: (value) => _item.category = value,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return '*Required field';
                        }
                        if (value.length != 10) {
                          return '*Enter valid phone number';
                        }
                        return null;
                      },
                      onChanged: (value) => _item.contact = value,
                      autovalidateMode: AutovalidateMode.always,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: InputDecoration(
                        hintText: 'Contact',
                        icon: Icon(Icons.call, color: color),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                        validator: (value) {
                          if (value.length > 6) {
                            return '*Too large amount';
                          }
                          return null;
                        },
                      onChanged: (value) => _item.price = double.parse(value),
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                      decoration: InputDecoration(
                        hintText: 'Price',
                        icon: Icon(Icons.attach_money_outlined, color: color),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    RoundedButton(
                        title: 'Cancel',
                        color: Colors.white70,
                        textColor: color,
                        onPressed: () {
                          Navigator.pop(context);
                        }
                    ),
                    RoundedButton(
                        title: 'Save',
                        color: color,
                        onPressed: () async {
                          _item.author = loggedInUser.email;
                          _item.available = true;
                          _item.createdAt = DateTime.now();
                          Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
                          _item.location = new GeoPoint(position.latitude, position.longitude);

                          if (_itemFormKey.currentState.validate()) {
                            _itemFormKey.currentState.save();
                            Item item = new Item(
                              itemName: _item.itemName,
                              description: _item.description,
                              contact: _item.contact,
                              category: _item.category,
                              price: _item.price,
                              available: _item.available,
                              author: _item.author,
                              createdAt: _item.createdAt,
                              location: _item.location
                            );

                            addItemToDatabase(item);
                          }
                        }
                    )
                  ],
                )
            ),
          // ],
        )
      ),
    );
  }

  void addItemToDatabase(Item item) {
    _firestore.collection('items').add({
      'itemName': item.itemName,
      'description': item.description,
      'author': item.author,
      'contact': item.contact,
      'category': item.category,
      'price': item.price,
      'available': item.available,
      'createdAt': item.createdAt,
      'location': item.location
    });
  }
}