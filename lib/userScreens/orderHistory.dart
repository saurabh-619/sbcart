import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sbcart/models/Product.dart';
import 'package:sbcart/userScreens/auth.dart';
import 'package:sbcart/userScreens/home.dart';
import 'package:sbcart/userScreens/singleorder.dart';
import 'package:sbcart/widgets/cachedImage.dart';
import 'package:sbcart/widgets/otherheader.dart';
import 'package:sbcart/widgets/progress.dart';
import 'package:date_time_format/date_time_format.dart';

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  @override
  void initState() {
    super.initState();
    getAllOrders();
  }

  getAllOrders() async {
    QuerySnapshot snapshot = await orderHistoryRef
        .document('107934781948829228374')
        .collection('orders')
        .document('dd927788-8ace-45cf-bc00-46961983fe50')
        .collection('orderProducts')
        .getDocuments();

    print(snapshot.documents);
  }

  @override
  Widget build(BuildContext context) {
    buildNoItemInCartScreen() {
      return Container(
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/noItem3.png'),
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
      appBar: otherHeader(title: 'Order History', context: context),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: StreamBuilder(
              stream: orderHistoryRef
                  .document(currentUser.id)
                  .collection('orders')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return circularProgress();
                } else if (snapshot.data.documents.length == 0) {
                  return buildNoItemInCartScreen();
                }
                List<OrderTile> orders = [];
                snapshot.data.documents.forEach((doc) {
                  orders.add(OrderTile.fromDocument(doc));
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

class OrderTile extends StatelessWidget {
  final Timestamp timestamp;
  final String orderTotal;
  final List<dynamic> products;
  OrderTile({this.timestamp, this.orderTotal, this.products});

  factory OrderTile.fromDocument(doc) {
    return OrderTile(
      timestamp: doc['timestamp'],
      orderTotal: doc['total'],
      products: doc['products'],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(top: 12),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleOrder(
                timestamp: timestamp,
                products: products,
                orderTotal: orderTotal),
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 200,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              roundedCachedImageProvider(
                mediaUrl: products[0]['productImageUrl'],
                height: 85,
                width: 85,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    ' \u20B9 ${orderTotal}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    ' ${DateTimeFormat.format(timestamp.toDate(), format: DateTimeFormats.american)}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
