import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:sbcart/models/Product.dart';
import 'package:sbcart/userScreens/auth.dart';
import 'package:sbcart/userScreens/home.dart';
import 'package:sbcart/widgets/cachedImage.dart';
import 'package:sbcart/widgets/otherheader.dart';
import 'package:sbcart/widgets/progress.dart';

class OrderNotifications extends StatefulWidget {
  @override
  _OrderNotificationsState createState() => _OrderNotificationsState();
}

class _OrderNotificationsState extends State<OrderNotifications>
    with AutomaticKeepAliveClientMixin<OrderNotifications> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);

    buildNoItemInCartScreen() {
      return Container(
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/noItem2.png'),
              Text(
                'None orders were placed.',
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Be inspired and discover something new to renew your closet.',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                width: 195,
                margin: EdgeInsets.only(top: 15),
                child: FlatButton(
                  onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home())),
                  color: Theme.of(context).buttonColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60)),
                  child: Text(
                    'GO TO SHOPPING',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: otherHeader(title: 'Notifications', context: context),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: StreamBuilder(
              stream: orderNotificationRef
                  .document(currentUser.id)
                  .collection('notifications')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return circularProgress();
                } else if (snapshot.data.documents.length == 0) {
                  return buildNoItemInCartScreen();
                }
                List<OrderNotification> orders = [];
                snapshot.data.documents.forEach((doc) {
                  orders.add(OrderNotification.fromDocument(doc));
                });
                return Container(
                  padding: EdgeInsets.only(bottom: 10),
                  color: Theme.of(context).accentColor.withOpacity(.2),
                  child: ListView(
                    children: orders,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Random random = Random();

class OrderNotification extends StatelessWidget {
  final Timestamp timestamp;
  final String orderTotal;
  final List<dynamic> products;
  final List<Container> allphotoes = [];
  OrderNotification({this.timestamp, this.orderTotal, this.products});

  factory OrderNotification.fromDocument(doc) {
    return OrderNotification(
      timestamp: doc['timestamp'],
      orderTotal: doc['total'],
      products: doc['products'],
    );
  }

  getAllProducts() {
    products.forEach(
      (e) => allphotoes.add(Container(
        height: 100,
        padding: EdgeInsets.fromLTRB(12, 10, 0, 12),
        margin: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: roundedCachedImageProvider(
          mediaUrl: e['productImageUrl'],
          height: 100,
          width: 100,
        ),
      )),
    );

    return allphotoes;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Container(
        margin: EdgeInsets.only(right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 120,
              child: CarouselSlider(
                  items: getAllProducts(),
                  options: CarouselOptions(
                    height: 200,
                    viewportFraction: .8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: false,
                    scrollDirection: Axis.horizontal,
                  )),
            ),
            Expanded(
              child: Container(
                child: Text(
                  'You\'ll receive your order by,          ${DateTimeFormat.format((timestamp.toDate().add(Duration(days: random.nextInt(3) + 1))), format: 'D, M j ')}',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Theme.of(context).primaryColor.withOpacity(.9),
                      ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// color: Theme.of(context).primaryColor.withOpacity(.05),
