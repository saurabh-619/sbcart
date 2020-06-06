import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sbcart/models/Product.dart';

class UserCart {
  List<ProducInTheCart> producsInTheCart;
  String totalPrice;
  UserCart({this.producsInTheCart, this.totalPrice});

  factory UserCart.fromDocument(DocumentSnapshot doc) {
    return UserCart(
      totalPrice: doc['totalPrice'],
      producsInTheCart: doc['producsInTheCart'],
    );
  }
}
