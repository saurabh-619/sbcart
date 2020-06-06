import 'package:flutter/material.dart';
import 'package:sbcart/widgets/otherheader.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: otherHeader(title: 'Messages', context: context),
    );
  }
}
