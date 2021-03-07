import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String documentId;
  String itemName;
  String description;
  String category;
  String contact;
  String author;
  String imageUrl;
  DateTime createdAt;
  GeoPoint location;
  double price;
  bool available;

  Item({this.documentId, this.itemName, this.description, this.category, this.contact,
      this.author, this.price, this.available, this.createdAt, this.location, this.imageUrl});

  @override
  String toString() {
    return 'Item{itemName: $itemName, description: $description, category: $category, contact: $contact, author: $author, createdAt: $createdAt, location: $location, price: $price, available: $available}';
  }
}