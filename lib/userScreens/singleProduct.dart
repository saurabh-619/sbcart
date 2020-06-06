import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sbcart/data/allData.dart';
import 'package:sbcart/models/Product.dart';
import 'package:sbcart/widgets/cachedImage.dart';
import 'package:sbcart/userScreens/home.dart';
import 'package:sbcart/userScreens/auth.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SingleProduct extends StatefulWidget {
  final Product product;
  final bool isWishlisted;

  SingleProduct({this.product, this.isWishlisted});

  @override
  _SingleProductState createState() =>
      _SingleProductState(isWishlisted: isWishlisted);
}

class _SingleProductState extends State<SingleProduct> {
  bool isWishlisted;
  bool isAddedToCart = false;
  _SingleProductState({this.isWishlisted});

  handleWishlist() async {
    setState(() {
      isWishlisted = !isWishlisted;
    });
    DocumentSnapshot snapshot = await wishlistRef
        .document(currentUser.id)
        .collection('allwishlists')
        .document(widget.product.id)
        .get();

    if (!snapshot.exists) {
      // add to allwishlists
      wishlistRef
          .document(currentUser.id)
          .collection('allwishlists')
          .document(widget.product.id)
          .setData({
        'id': widget.product.id,
        'name': widget.product.name,
        'gender': widget.product.gender,
        'category': widget.product.category,
        'color': widget.product.color,
        'size': widget.product.size,
        'productImageUrl': widget.product.photoUrl,
        'price': widget.product.price,
        'stock': widget.product.stock,
        'timestamp': DateTime.now(),
      });
    } else {
      // delete
      await wishlistRef
          .document(currentUser.id)
          .collection('allwishlists')
          .document(widget.product.id)
          .delete();
    }
  }

  Color getColor() {
    final List<MyColor> colors = getAllColors();
    var foundcolor = colors
        .firstWhere((mycolor) => mycolor.colorName == widget.product.color);
    return foundcolor.color;
  }

  List<String> getSizes() {
    return widget.product.size.trim().split(',').toList();
  }

  addToCart() async {
    setState(() {
      isAddedToCart = !isAddedToCart;
    });
    DocumentSnapshot snapshot = await cartRef
        .document(currentUser.id)
        .collection('cartItems')
        .document(widget.product.id)
        .get();

    if (!snapshot.exists) {
      // add to allwishlists
      cartRef
          .document(currentUser.id)
          .collection('cartItems')
          .document(widget.product.id)
          .setData({
        'id': widget.product.id,
        'name': widget.product.name,
        'gender': widget.product.gender,
        'category': widget.product.category,
        'color': widget.product.color,
        'size': widget.product.size,
        'productImageUrl': widget.product.photoUrl,
        'price': widget.product.price,
        'stock': widget.product.stock,
        'timestamp': DateTime.now(),
      });
    } else {
      // delete
      await cartRef
          .document(currentUser.id)
          .collection('cartItems')
          .document(widget.product.id)
          .delete();
    }
  }

  getIfAddedToCart() async {
    DocumentSnapshot snapshot = await cartRef
        .document(currentUser.id)
        .collection('cartItems')
        .document(widget.product.id)
        .get();

    if (!snapshot.exists) {
      setState(() {
        isAddedToCart = false;
      });
    } else {
      setState(() {
        isAddedToCart = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getIfAddedToCart();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('Hello backbutton of mobile');
        Navigator.pop(context, isWishlisted);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () async {
                Navigator.pop(context, isWishlisted);
              }),
          iconTheme: IconThemeData(
              color: Theme.of(context).primaryColor, opacity: .85),
          title: Text(
            widget.product.name,
            style: TextStyle(
                fontFamily: 'Poppins',
                color: Theme.of(context).primaryColor.withOpacity(0.9),
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Color(0xffF7F8FC),
        ),
        body: Container(
          color: Theme.of(context).primaryColor.withOpacity(.2),
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      Container(
                        height: 450,
                        alignment: Alignment.topCenter,
                        child: CarouselSlider(
                          items: [
                            roundedCachedImageProvider(
                                mediaUrl: widget.product.photoUrl),
                          ],
                          options: CarouselOptions(
                            height: 410,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.8,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 50,
                        bottom: 10,
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Theme.of(context).cardColor.withGreen(180),
                              Theme.of(context).cardColor.withOpacity(.9)
                            ]),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: IconButton(
                            onPressed: () {
                              handleWishlist();
                            },
                            icon: Icon(
                              isWishlisted
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 36.0, top: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          widget.product.name,
                          style: Theme.of(context)
                              .textTheme
                              .headline2
                              .copyWith(fontSize: 19),
                        ),
                        Text(
                          '\u20B9 ${widget.product.price}',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 27, top: 5),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              height: 55,
                              width: 125,
                              margin: EdgeInsets.only(right: 8),
                              child: FlatButton(
                                onPressed: () => print(''),
                                color: Colors.white60,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      widget.product.color.toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(.9),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 12.2,
                                          ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    CircleAvatar(
                                      radius: 13,
                                      backgroundColor: getColor(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 55,
                              width: 175,
                              child: FlatButton(
                                onPressed: () => print('sizes'),
                                color: Colors.white60,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: getSizes()
                                      .map(
                                        (e) => CircleAvatar(
                                          radius: 15,
                                          backgroundColor:
                                              Theme.of(context).accentColor,
                                          child: Container(
                                            child: Text(
                                              e,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 55,
                    width: 195,
                    margin: EdgeInsets.only(top: 15),
                    child: FlatButton(
                      onPressed: () => addToCart(),
                      color: isAddedToCart
                          ? Colors.white
                          : Theme.of(context).buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60)),
                      child: Text(
                        isAddedToCart ? 'Remove from Cart' : 'Add to Cart',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              color: isAddedToCart
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ),
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
