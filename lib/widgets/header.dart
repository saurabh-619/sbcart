import 'package:flutter/material.dart';
import 'package:sbcart/userScreens/auth.dart';
import 'package:sbcart/userScreens/favorites.dart';
import 'package:sbcart/userScreens/home.dart';
import 'package:sbcart/userScreens/orderNotifications.dart';

AppBar header({String title, bool backButton = true, context}) {
  return AppBar(
    iconTheme:
        IconThemeData(color: Theme.of(context).primaryColor, opacity: .85),
    title: Text(
      title,
      style: TextStyle(
          fontFamily: 'Poppins',
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          fontSize: 25,
          fontWeight: FontWeight.bold),
    ),
    automaticallyImplyLeading: backButton,
    elevation: 0,
    backgroundColor: Color(0xffF7F8FC),
    actions: <Widget>[
      IconButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Favorites(),
          ),
        ),
        icon: Icon(
          Icons.favorite,
          color: Theme.of(context).primaryColor.withOpacity(.85),
          size: 23,
        ),
      ),
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderNotifications(),
              ),
            ),
            icon: Icon(
              Icons.chat,
              color: Theme.of(context).primaryColor.withOpacity(.85),
              size: 23,
            ),
          ),
          Positioned(
            right: 3,
            top: 10,
            child: StreamBuilder(
              stream: orderNotificationRef
                  .document(currentUser.id)
                  .collection('notifications')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text('');
                } else if (snapshot.data.documents.length == 0) {
                  return Text('');
                }
                return Container(
                  padding: EdgeInsets.all(1.5),
                  constraints: BoxConstraints(
                    minHeight: 15,
                    minWidth: 15,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Text(
                    '${snapshot.data.documents.length}',
                    style: TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          )
        ],
      ),
    ],
  );
}
