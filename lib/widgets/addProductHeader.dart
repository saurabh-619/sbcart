import 'package:flutter/material.dart';

AppBar addProductHeader(
    {String title, bool backButton = true, context, Function onPost}) {
  return AppBar(
    iconTheme:
        IconThemeData(color: Theme.of(context).primaryColor, opacity: .85),
    title: Text(
      title,
      style: TextStyle(
          fontFamily: 'Poppins',
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          fontSize: 22,
          fontWeight: FontWeight.bold),
    ),
    actions: <Widget>[
      FlatButton(
        onPressed: () => onPost(),
        child: Text(
          'Post',
          style: TextStyle(color: Theme.of(context).buttonColor, fontSize: 19),
        ),
      )
    ],
    centerTitle: true,
    automaticallyImplyLeading: backButton,
    elevation: 0,
    backgroundColor: Color(0xffF7F8FC),
  );
}
