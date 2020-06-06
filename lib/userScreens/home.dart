import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sbcart/userScreens/menCategories.dart';
import 'package:sbcart/userScreens/womenCategories.dart';
import 'package:sbcart/widgets/drawer.dart';
import 'package:sbcart/widgets/floatingActionButton.dart';
import 'package:sbcart/widgets/header.dart';

// References
final StorageReference storageRef = FirebaseStorage.instance.ref();
final CollectionReference categoriesRef =
    Firestore.instance.collection('categories');
final CollectionReference productsRef =
    Firestore.instance.collection('products');
final CollectionReference wishlistRef =
    Firestore.instance.collection('wishlists');
final CollectionReference cartRef = Firestore.instance.collection('carts');
final CollectionReference orderRef = Firestore.instance.collection('orders');
final CollectionReference orderHistoryRef =
    Firestore.instance.collection('orderHistory');
final CollectionReference orderNotificationRef =
    Firestore.instance.collection('orderNotification');
final CollectionReference userRef = Firestore.instance.collection('users');

// Home class
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(title: 'sbcart', context: context),
      drawer: getDrawer(context),
      floatingActionButton: floatingActionButton(context),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MenCategories())),
                child: Container(
                  height: 250,
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    color: Color(0xffE8E5E0),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'For Him ',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Image(
                        image: AssetImage('assets/images/forhim.png'),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WomenCategories())),
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Color(0xffE8E5E0),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Row(
                      children: <Widget>[
                        Image(
                          image: AssetImage('assets/images/forher.png'),
                        ),
                        Text(
                          'For Her',
                          style: Theme.of(context).textTheme.headline1,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
