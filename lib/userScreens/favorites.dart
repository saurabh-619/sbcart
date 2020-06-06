import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sbcart/models/Product.dart';
import 'package:sbcart/userScreens/auth.dart';
import 'package:sbcart/userScreens/home.dart';
import 'package:sbcart/userScreens/singleProduct.dart';
import 'package:sbcart/widgets/otherheader.dart';
import 'package:sbcart/widgets/progress.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: otherHeader(title: 'My Wishlist', context: context),
      body: Container(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        color: Theme.of(context).primaryColor.withOpacity(.2),
        child: Container(
          child: StreamBuilder(
            stream: wishlistRef
                .document(currentUser.id)
                .collection('allwishlists')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return circularProgress();
              } else if (snapshot.data.documents.length == 0) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 100,
                        backgroundColor: Theme.of(context).cardColor,
                        child: Image.asset(
                          'assets/images/notfound.png',
                          height: 150,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'You haven\'t added anything to Wishlist',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline4,
                      )
                    ],
                  ),
                );
              }
              List<Product> products = [];
              snapshot.data.documents.forEach((doc) {
                products.add(Product.fromDocument(doc));
              });
              List<ProductTile> productTiles = [];
              productTiles = products
                  .map((product) => ProductTile(
                        product: product,
                      ))
                  .toList();
              return Container(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: .4,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  shrinkWrap: true,
                  children: productTiles,
                ),
              );
            },
          ),
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
  bool isWishlisted = false;
  _ProductTileState({this.isWishlisted});

  handleWishlist() async {
    // setState(() {
    //   isWishlisted = !isWishlisted;
    // });
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
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 10,
            child: GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SingleProduct(
                      product: widget.product,
                      isWishlisted: isWishlisted,
                    ),
                  ),
                );
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
                            isWishlisted
                                ? Icons.favorite
                                : Icons.favorite_border,
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
                          color:
                              Theme.of(context).primaryColor.withOpacity(.6)),
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
      ),
    );
  }
}
