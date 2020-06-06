import 'package:flutter/material.dart';
import 'package:sbcart/userScreens/auth.dart';
import 'package:sbcart/userScreens/loadingScreen.dart';
import 'package:sbcart/userScreens/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xff032B5C), //blue
        accentColor: Color(0xff965EFF), //purple
        buttonColor: Color(0xffFD4092), //pink
        backgroundColor: Color(0xffF7F8FC),
        cardColor: Color(0xffFCD755),

        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 35.0,
            fontFamily: 'Poppins',
            color: Color(0xff032B5C),
            fontWeight: FontWeight.bold,
          ),
          headline2: TextStyle(
            fontSize: 28.0,
            fontFamily: 'Poppins',
            color: Color(0xff032B5C),
            fontWeight: FontWeight.bold,
          ),
          headline3: TextStyle(
            fontSize: 24.0,
            fontFamily: 'Poppins',
            color: Color(0xff032B5C),
            fontWeight: FontWeight.bold,
          ),
          headline4: TextStyle(
            fontSize: 20.0,
            fontFamily: 'Poppins',
            color: Color(0xff032B5C),
            fontWeight: FontWeight.bold,
          ),
          headline5: TextStyle(
            fontSize: 17.0,
            fontFamily: 'Poppins',
            color: Color(0xff032B5C).withOpacity(.5),
            fontWeight: FontWeight.bold,
          ),
          headline6: TextStyle(
            fontSize: 14.0,
            fontFamily: 'Poppins',
            color: Color(0xff032B5C).withOpacity(.5),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: LoadingScreen(),
    );
  }
}
