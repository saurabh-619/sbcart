import 'package:flutter/material.dart';

AppBar otherHeader(
    {String title, bool centerTitle = true, bool backButton = true, context}) {
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
    centerTitle: centerTitle,
    automaticallyImplyLeading: backButton,
    elevation: 0,
    backgroundColor: Color(0xffF7F8FC),
  );
}
