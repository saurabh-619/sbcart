import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id, name, gender, category, stock, price, size, color, photoUrl;
  Timestamp timestamp;

  Product({
    this.id,
    this.gender,
    this.category,
    this.photoUrl,
    this.color,
    this.size,
    this.name,
    this.price,
    this.stock,
    this.timestamp,
  });

  factory Product.fromDocument(DocumentSnapshot doc) {
    return Product(
      id: doc['id'],
      gender: doc['gender'],
      category: doc['category'],
      name: doc['name'],
      photoUrl: doc['productImageUrl'],
      color: doc['color'],
      size: doc['size'],
      price: doc['price'],
      stock: doc['stock'],
      timestamp: doc['timestamp'],
    );
  }
}

class ProducInTheCart {
  List<String> photoUrls;
  String name, id, categoryId, colorSelected, sizeSelected;
  String count, price;

  ProducInTheCart({
    this.id,
    this.categoryId,
    this.photoUrls,
    this.colorSelected,
    this.sizeSelected,
    this.name,
    this.price,
    this.count,
  });

  factory ProducInTheCart.fromDocument(DocumentSnapshot doc) {
    return ProducInTheCart(
      id: doc['id'],
      categoryId: doc['categoryId'],
      name: doc['name'],
      photoUrls: doc['photoUrls'],
      colorSelected: doc['colorSelected'],
      sizeSelected: doc['sizeSelected'],
      price: doc['price'],
      count: doc['count'],
    );
  }
}
