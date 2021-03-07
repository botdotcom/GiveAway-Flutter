import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

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
  File _imageFile;
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
                    GestureDetector(
                        onTap: () {
                          showPicker(context);
                        },
                        child: Container(
                          child: (_item.imageUrl != null)
                              ? Image.network(_item.imageUrl)
                              : Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200]
                            ),
                            width: 50.0,
                            height: 50.0,
                            child: Icon(
                              Icons.image_outlined,
                              color: Colors.grey[800],
                            ),
                          ),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    RoundedButton(
                        title: 'Cancel',
                        color: Colors.white70,
                        textColor: color,
                        onPressed: () {
                          Navigator.of(context).pop();
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
                          _item.imageUrl = await uploadImageToStorage(_item.author);

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
                              location: _item.location,
                              imageUrl: _item.imageUrl
                            );

                            addItemToDatabase(item);
                            Navigator.of(context).pop();
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

  // create of CRUD
  void addItemToDatabase(Item item) {
    DocumentReference documentReference = _firestore.collection('items').doc();

    // _firestore.collection('items').doc(documentReference.id).add({
    _firestore.collection('items').add({
      'itemName': item.itemName,
      'description': item.description,
      'author': item.author,
      'contact': item.contact,
      'category': item.category,
      'price': item.price,
      'available': item.available,
      'createdAt': item.createdAt,
      'location': item.location,
      'imageUrl': item.imageUrl,
      'documentId': documentReference.id
    }).then((value) => print("Item added"))
        .catchError((onError) => print("Failed to added item"));
  }

  // image capture helper methods
  void showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.photo_library_outlined),
                    title: Text(
                        'Photo Gallery'
                    ),
                    onTap: () {
                      captureImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.camera_outlined),
                    title: Text(
                        'Camera'
                    ),
                    onTap: () {
                      captureImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  void captureImage(ImageSource source) async {
    PickedFile picked = await ImagePicker().getImage(source: source);
    File selected = File(picked.path);

    setState(() {
      _imageFile = selected;
    });
  }

  // void uploadImageToStorage(String author) async {
  Future<String> uploadImageToStorage(String author) async {
    final _firebaseStorage = FirebaseStorage.instance;

    if (_imageFile != null) {
      var filePath = '$author/${DateTime.now()}.png';
      var file = await _firebaseStorage.ref().child(filePath).putFile(_imageFile);

      var downloadUrl = await _firebaseStorage.ref().child(filePath).getDownloadURL();

      // setState(() {
      //   _item.imageUrl = downloadUrl;
      // });

      return downloadUrl;
    }
  }

  // Future<String> uploadImageFromGalleryToStorage(String author) async {
  //   final _firebaseStorage = FirebaseStorage.instance;
  //   final _imagePicker = ImagePicker();
  //   PickedFile pickedImage;
  //
  //   // check permissions
  //   await Permission.photos.request();
  //   var photosPermissionStatus = await Permission.photos.status;
  //
  //   if (photosPermissionStatus.isGranted) {
  //     // select image
  //     pickedImage = await _imagePicker.getImage(source: ImageSource.gallery);
  //     var imageFile = File(pickedImage.path);
  //
  //     if (imageFile != null) {
  //       // upload to firebase storage
  //       var downloadUrl = await _firebaseStorage.ref().child(author).getDownloadURL();
  //       return downloadUrl;
  //     }
  //     else {
  //       print("No image path received!");
  //       return null;
  //     }
  //   }
  //   else {
  //     print("Pemission to access photo gallery not granted!");
  //     return null;
  //   }
  // }
}