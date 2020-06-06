import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sbcart/data/allData.dart';
import 'package:sbcart/models/Product.dart';
import 'package:sbcart/payment/error.dart';
import 'package:sbcart/payment/success.dart';
import 'package:sbcart/userScreens/auth.dart';
import 'package:sbcart/userScreens/home.dart';
import 'package:sbcart/widgets/cachedImage.dart';
import 'package:sbcart/widgets/otherheader.dart';
import 'package:sbcart/widgets/progress.dart';
import 'package:uuid/uuid.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  String subtotal = '';
  String total = '';
  Razorpay razorpay;
  List<Product> products = [];
  String orderId = Uuid().v4();

  Color getColor(product) {
    final List<MyColor> colors = getAllColors();
    var foundcolor =
        colors.firstWhere((mycolor) => mycolor.colorName == product.color);
    return foundcolor.color;
  }

  List<String> getSizes(product) {
    return product.size.trim().split(',').toList();
  }

  giveCartTotal(List<Product> productsInTheCart) {
    double totalSub = 0;
    productsInTheCart.forEach((product) {
      totalSub = totalSub + int.parse(product.price);
    });
    subtotal = totalSub.toString();
    total = (totalSub + 40).toString();
    products = productsInTheCart;
  }

  buildNoItemInCartScreen() {
    return Container(
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/noItem1.png'),
            Text(
              'Shopping bag is empty.',
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

  removeItemFromCart(Product currentProduct) {
    cartRef
        .document(currentUser.id)
        .collection('cartItems')
        .document(currentProduct.id)
        .delete();
  }

  @override
  void initState() {
    super.initState();

    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerPaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerPaymentExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void openCheckout() {
    var options = {
      'key': 'rzp_test_tH8GOtiRSN1NO3',
      'amount': num.parse(total) * 100,
      'name': 'sbcart',
      'description': 'Payment for the order',
      'prefill': {
        'email': currentUser.email,
      },
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      razorpay.open(options);
    } catch (e) {
      print('Error during payment:- ${e.toString()}');
    }
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) {
    orderHistoryRef
        .document(currentUser.id)
        .collection('orders')
        .document(orderId)
        .setData({
      'timestamp': DateTime.now(),
      'total': total,
      'address': currentUser.address,
      'products': [
        {
          'id': products[0].id,
          'name': products[0].name,
          'gender': products[0].gender,
          'category': products[0].category,
          'color': products[0].color,
          'size': products[0].size,
          'productImageUrl': products[0].photoUrl,
          'price': products[0].price,
          'stock': products[0].stock,
        },
      ]
    });
    // // Generate order notification
    orderNotificationRef
        .document(currentUser.id)
        .collection('notifications')
        .document(orderId)
        .setData({
      'timestamp': DateTime.now(),
      'total': total,
      'address': currentUser.address,
      'products': [
        {
          'id': products[0].id,
          'name': products[0].name,
          'gender': products[0].gender,
          'category': products[0].category,
          'color': products[0].color,
          'size': products[0].size,
          'productImageUrl': products[0].photoUrl,
          'price': products[0].price,
          'stock': products[0].stock,
        }
      ]
    });

    products.forEach((product) {
      orderHistoryRef
          .document(currentUser.id)
          .collection('orders')
          .document(orderId)
          .updateData({
        'products': FieldValue.arrayUnion([
          {
            'id': product.id,
            'name': product.name,
            'gender': product.gender,
            'category': product.category,
            'color': product.color,
            'size': product.size,
            'productImageUrl': product.photoUrl,
            'price': product.price,
            'stock': product.stock,
          }
        ])
      });

      // // Generate order notification
      orderNotificationRef
          .document(currentUser.id)
          .collection('notifications')
          .document(orderId)
          .updateData({
        'products': FieldValue.arrayUnion([
          {
            'id': product.id,
            'name': product.name,
            'gender': product.gender,
            'category': product.category,
            'color': product.color,
            'size': product.size,
            'productImageUrl': product.photoUrl,
            'price': product.price,
            'stock': product.stock,
          }
        ])
      });
    });

    setState(() {
      orderId = Uuid().v4();
    });

    // empty the cart
    cartRef
        .document(currentUser.id)
        .collection('cartItems')
        .getDocuments()
        .then((value) {
      value.documents.forEach((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Success()),
    );
  }

  void handlerPaymentError(PaymentFailureResponse response) {
    print(
        'Error - ${response.message}-------------------------------------------------------------------------------------------------');
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ErrorInPayment(response: response)),
    );
  }

  void handlerPaymentExternalWallet(ExternalWalletResponse response) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Success()),
    );
    cartRef.document(currentUser.id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: otherHeader(title: 'My Cart', context: context),
      body: Container(
        color: Theme.of(context).primaryColor.withOpacity(.1),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: StreamBuilder(
                stream: cartRef
                    .document(currentUser.id)
                    .collection('cartItems')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return circularProgress();
                  } else if (snapshot.data.documents.length == 0) {
                    return buildNoItemInCartScreen();
                  }
                  List<Product> productsInTheCart = [];
                  snapshot.data.documents.forEach((doc) =>
                      productsInTheCart.add(Product.fromDocument(doc)));
                  giveCartTotal(productsInTheCart);
                  return Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                          itemCount: productsInTheCart.length,
                          itemBuilder: (context, index) {
                            Product currentProduct = productsInTheCart[index];
                            return Container(
                              height: 200,
                              padding: EdgeInsets.fromLTRB(12, 10, 0, 12),
                              margin: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Row(
                                children: <Widget>[
                                  roundedCachedImageProvider(
                                    mediaUrl: currentProduct.photoUrl,
                                    height: 150,
                                    width: 100,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Container(
                                          width: 190,
                                          child: Text(
                                            currentProduct.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text('Color:'),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                CircleAvatar(
                                                  radius: 10,
                                                  backgroundColor:
                                                      getColor(currentProduct),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text('Sizes:'),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: getSizes(
                                                          currentProduct)
                                                      .map(
                                                        (e) => Container(
                                                          margin:
                                                              EdgeInsets.all(
                                                                  1.3),
                                                          child: CircleAvatar(
                                                            radius: 10,
                                                            backgroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .accentColor,
                                                            child: Container(
                                                              child: Text(
                                                                e,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 9,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Container(
                                          alignment: Alignment.bottomRight,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                '\u20B9 ${currentProduct.price}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .buttonColor,
                                                    ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () =>
                                                    removeItemFromCart(
                                                        currentProduct),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Card(
                            margin: EdgeInsets.all(0),
                            color:
                                Theme.of(context).primaryColor.withOpacity(1),
                            elevation: 100.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Subtotal',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            .copyWith(
                                              color: Colors.white70,
                                            ),
                                      ),
                                      Text(
                                        '\u20B9 $subtotal',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            .copyWith(
                                              color: Colors.white70,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Shipping',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            .copyWith(
                                              color: Colors.white70,
                                            ),
                                      ),
                                      Text(
                                        '\u20B9 40',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            .copyWith(
                                              color: Colors.white70,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 20,
                                    color: Colors.white70,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Total',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            .copyWith(
                                              color: Colors.white70,
                                            ),
                                      ),
                                      Text(
                                        '\u20B9 $total',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            .copyWith(
                                              color: Colors.white70,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        width: 310,
                                        child: Text(
                                          'Address: ${currentUser.address}',
                                          overflow: TextOverflow.ellipsis,
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
                                  Container(
                                    height: 55,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(top: 15),
                                    child: FlatButton(
                                      onPressed: () => openCheckout(),
                                      color: Theme.of(context).buttonColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(60)),
                                      child: Text(
                                        'CHECKOUT',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
