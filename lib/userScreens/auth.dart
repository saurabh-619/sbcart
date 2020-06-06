import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sbcart/models/User.dart';
import 'package:sbcart/userScreens/UserInfo.dart';
import 'package:sbcart/userScreens/home.dart';
import 'package:sbcart/widgets/otherheader.dart';
import 'package:sbcart/widgets/progress.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
User currentUser;

class AuthScreen extends StatefulWidget {
  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  bool isAuth = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      print('User logged IN');
      handleLogIn(account);
    }, onError: (err) {
      print(err);
    });
    // Reauthenticate when app is opened again (for session)
    googleSignIn.signInSilently(suppressErrors: true).then((account) {
      print('User has returned');
      handleLogIn(account);
    }).catchError((err) => print('Error: $err'));

    Timer(Duration(seconds: 5), () {
      setState(() {
        isLoading = false;
      });
      if (currentUser == null) {
        Fluttertoast.showToast(
          msg: "It seems like you haven\'t signed in yet.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    });
  }

  handleLogIn(GoogleSignInAccount account) async {
    if (account != null) {
      await createUserInFirestore(account);
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInFirestore(GoogleSignInAccount account) async {
    DocumentSnapshot foundUser = await userRef.document(account.id).get();
    if (!foundUser.exists) {
      final String address = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserInfo(account: account),
        ),
      );
      List<String> messages = [];
      userRef.document(account.id).setData({
        'name': account.displayName,
        'id': account.id,
        'photoUrl': account.photoUrl,
        'address': address,
        'isAdmin': false,
        'email': account.email,
        'messages': messages,
        'timestamp': DateTime.now(),
      });
      foundUser = await userRef.document(account.id).get();
    }
    currentUser = User.fromDocument(foundUser);
  }

  login() {
    googleSignIn.signIn();
  }

  buildAuthScreen() {
    return Scaffold(
      appBar: otherHeader(
        title: 'Sign Up',
        context: context,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage('assets/images/avatar2.jpg'),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 60,
                    width: 250,
                    child: FlatButton(
                      color: Theme.of(context).buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60)),
                      onPressed: () => login(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.google,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          ),
                          Text(
                            'Sign In with Google',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          isLoading ? linearProgress() : Text(''),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? Home() : buildAuthScreen();
  }
}
