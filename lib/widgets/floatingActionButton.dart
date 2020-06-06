import 'package:flutter/material.dart';
import 'package:sbcart/userScreens/auth.dart';
import 'package:sbcart/userScreens/cart.dart';
import 'package:sbcart/userScreens/home.dart';

FloatingActionButton floatingActionButton(context) {
  return FloatingActionButton(
    onPressed: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Cart(),
      ),
    ),
    backgroundColor: Theme.of(context).cardColor,
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          child: Icon(
            Icons.shopping_cart,
            size: 32,
          ),
        ),
        Positioned(
          right: 7,
          top: 5,
          child: StreamBuilder(
            stream: cartRef
                .document(currentUser.id)
                .collection('cartItems')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text('');
              }
              int cartLength = snapshot.data.documents.length;
              return Container(
                padding: EdgeInsets.all(1),
                constraints: BoxConstraints(minHeight: 16, minWidth: 16),
                decoration: BoxDecoration(
                  color: cartLength == 0
                      ? Colors.transparent
                      : Theme.of(context).buttonColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text(
                  cartLength == 0 ? '' : cartLength.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        )
      ],
    ),
  );
}
