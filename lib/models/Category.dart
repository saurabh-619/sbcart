import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String imagePosterUrl;
  String name, id, includes, gender;
  Timestamp timestamp;

  Category(
      {this.id,
      this.imagePosterUrl,
      this.includes,
      this.name,
      this.gender,
      this.timestamp});

  factory Category.fromDocument(DocumentSnapshot doc) {
    return Category(
      id: doc['id'],
      name: doc['name'],
      gender: doc['gender'],
      imagePosterUrl: doc['imagePosterUrl'],
      includes: doc['includes'],
      timestamp: doc['timestamp'],
    );
  }
}
