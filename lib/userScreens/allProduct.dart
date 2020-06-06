import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sbcart/models/Category.dart';
import 'package:sbcart/models/Product.dart';
import 'package:sbcart/userScreens/home.dart';
import 'package:sbcart/userScreens/auth.dart';
import 'package:sbcart/userScreens/singleProduct.dart';
import 'package:sbcart/widgets/otherheader.dart';
import 'package:sbcart/widgets/progress.dart';

class AllProducts extends StatefulWidget {
  final Category category;
  AllProducts({this.category});
  @override
  _AllProductsState createState() => _AllProductsState(category: category);
}

class _AllProductsState extends State<AllProducts> {
  final Category category;
  List<Product> products;
  _AllProductsState({this.category});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: otherHeader(
          title: category.gender.toLowerCase(),
          context: context,
          centerTitle: false),
      body: Container(
        color: Theme.of(context).primaryColor.withOpacity(.2),
        child: ListView(
          children: <Widget>[
            Container(
              height: 120,
              alignment: Alignment.center,
              child: Text(
                category.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            StreamBuilder(
              stream: productsRef
                  .where('category', isEqualTo: category.name)
                  .where('gender', isEqualTo: category.gender)
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return circularProgress();
                }
                List<Product> products = [];
                snapshot.data.documents
                    .forEach((doc) => products.add(Product.fromDocument(doc)));

                List<ProductTile> productTiles = [];
                productTiles = products
                    .map((product) => ProductTile(
                          product: product,
                        ))
                    .toList();
                return GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: .4,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: productTiles,
                );
              },
            ),
            Container(
              height: 180,
              margin: EdgeInsets.fromLTRB(10, 10, 10, 35),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.smile,
                      size: 40,
                      color: Colors.white70,
                    ),
                    Text(
                      'You\'re all caught up!',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Hundreads more fresh styles dropping tomorrow',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductTile extends StatefulWidget {
  final Product product;
  final bool isWishlisted = false;
  ProductTile({this.product});

  @override
  _ProductTileState createState() => _ProductTileState(
        isWishlisted: isWishlisted,
      );
}

class _ProductTileState extends State<ProductTile> {
  bool isWishlisted;
  _ProductTileState({this.isWishlisted});

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

  getIfWishlisted() async {
    DocumentSnapshot snapshot = await wishlistRef
        .document(currentUser.id)
        .collection('allwishlists')
        .document(widget.product.id)
        .get();

    if (!snapshot.exists) {
      setState(() {
        isWishlisted = false;
      });
    } else {
      setState(() {
        isWishlisted = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getIfWishlisted();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 10,
          child: GestureDetector(
            onTap: () async {
              final bool wishlistbool = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SingleProduct(
                    product: widget.product,
                    isWishlisted: isWishlisted,
                  ),
                ),
              );
              setState(() {
                isWishlisted = wishlistbool;
              });
            },
            onDoubleTap: () => handleWishlist(),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: CachedNetworkImage(
                      imageUrl: widget.product.photoUrl,
                      fit: BoxFit.cover,
                      height: 400,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      placeholder: (context, url) => Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 7, left: 7),
                    child: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).cardColor.withOpacity(.5),
                      child: IconButton(
                        onPressed: () {
                          handleWishlist();
                        },
                        icon: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          color: Theme.of(context).buttonColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Theme.of(context).primaryColor.withOpacity(.6)),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '\u20B9 ${widget.product.price}',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
