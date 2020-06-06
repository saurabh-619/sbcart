import 'package:flutter/material.dart';

class MyColor {
  final String colorName;
  final Color color;

  MyColor({this.color, this.colorName});
}

List<MyColor> getAllColors() {
  return [
    MyColor(colorName: 'white', color: Colors.white),
    MyColor(colorName: 'red', color: Colors.red),
    MyColor(colorName: 'maroon', color: Color(0xff800000)),
    MyColor(colorName: 'navy blue', color: Colors.indigo[900]),
    MyColor(colorName: 'yellow', color: Colors.yellow),
    MyColor(colorName: 'black', color: Colors.black),
    MyColor(colorName: 'blue', color: Colors.blue),
    MyColor(colorName: 'purple', color: Colors.purple),
    MyColor(colorName: 'pink', color: Colors.pink),
    MyColor(colorName: 'green', color: Colors.green),
    MyColor(colorName: 'grey', color: Colors.grey),
    MyColor(colorName: 'orange', color: Colors.orange),
    MyColor(colorName: 'teal', color: Colors.teal),
    MyColor(colorName: 'cyan', color: Colors.cyan),
    MyColor(colorName: 'indigo', color: Colors.indigo),
    MyColor(colorName: 'brown', color: Colors.brown),
  ];
}

class Size {
  final String size;
  Size({
    this.size,
  });
}

List<Size> getAllSizes() {
  return [
    Size(size: 'S'),
    Size(size: 'M'),
    Size(size: 'L'),
    Size(size: 'XL'),
    Size(size: 'XXL'),
    Size(size: 'XXXL'),
    Size(size: 'S, M, L, XL'),
    Size(size: 'XL, XXL'),
    Size(size: 'All'),
  ];
}
