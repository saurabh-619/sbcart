import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String photoUrl, id, address, name, email;
  bool isAdmin;
  List<dynamic> messages;

  User({
    this.photoUrl,
    this.id,
    this.name,
    this.address,
    this.email,
    this.isAdmin,
    this.messages,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      name: doc['name'],
      id: doc['id'],
      photoUrl: doc['photoUrl'],
      address: doc['address'],
      isAdmin: doc['isAdmin'],
      email: doc['email'],
      messages: doc['messages'],
    );
  }
}
