import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:sbcart/data/allData.dart';
import 'package:sbcart/widgets/cachedImage.dart';
import 'package:sbcart/widgets/otherheader.dart';
import 'package:uuid/uuid.dart';

import 'auth.dart';

class SingleOrder extends StatelessWidget {
  final Timestamp timestamp;
  final String orderTotal;
  final List<dynamic> products;
  List<Widget> allphotoes = [];
  SingleOrder({this.timestamp, this.orderTotal, this.products});

  Color getColor(product) {
    final List<MyColor> colors = getAllColors();
    var foundcolor =
        colors.firstWhere((mycolor) => mycolor.colorName == product['color']);
    return foundcolor.color;
  }

  List<String> getSizes(product) {
    return product['size'].trim().split(',').toList();
  }

  @override
  Widget build(BuildContext context) {
    getAllProducts() {
      products.forEach(
        (e) => allphotoes.add(Container(
          height: 200,
          padding: EdgeInsets.fromLTRB(12, 10, 0, 12),
          margin: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              roundedCachedImageProvider(
                mediaUrl: e['productImageUrl'],
                height: 150,
                width: 100,
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 190,
                      child: Text(
                        e['name'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text('Color:'),
                            SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: getColor(e),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text('Sizes:'),
                            SizedBox(
                              width: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: getSizes(e)
                                  .map(
                                    (e) => Container(
                                      margin: EdgeInsets.all(1.3),
                                      child: CircleAvatar(
                                        radius: 10,
                                        backgroundColor:
                                            Theme.of(context).accentColor,
                                        child: Container(
                                          child: Text(
                                            e,
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        '\u20B9 ${e['price']}',
                        style: Theme.of(context).textTheme.headline3.copyWith(
                              color: Theme.of(context).buttonColor,
                            ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )),
      );

      return allphotoes;
    }

    return Scaffold(
      appBar: otherHeader(title: 'Order Details', context: context),
      body: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Track Orders',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Orders Items',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(fontSize: 16),
                      ),
                      Text(
                        '${products.length} Products',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CarouselSlider(
                items: getAllProducts(),
                options: CarouselOptions(
                  height: 320,
                  aspectRatio: 16 / 4,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                )),
            Expanded(
              child: Card(
                margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                color: Theme.of(context).cardColor.withOpacity(1),
                elevation: 100.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Order #${Uuid().v4().toString().substring(0, 7)}',
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(
                                    color: Theme.of(context).primaryColor),
                          ),
                          Text(
                            '${DateTimeFormat.format(timestamp.toDate(), format: 'D, M j, H:i')}',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontSize: 16,
                                    color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Subtotal',
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.92),
                                    ),
                          ),
                          Text(
                            '\u20B9 ${(num.parse(orderTotal) - 40).toString()}',
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.92),
                                    ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Shipping',
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.92),
                                    ),
                          ),
                          Text(
                            '\u20B9 40',
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.92),
                                    ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 20,
                        color: Colors.white70,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Total',
                              style: Theme.of(context).textTheme.headline4),
                          Text('\u20B9 $orderTotal',
                              style: Theme.of(context).textTheme.headline4),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 285,
                            child: Text(
                              'Address:  ${currentUser.address}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    fontSize: 11,
                                    color: Colors.white70,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
