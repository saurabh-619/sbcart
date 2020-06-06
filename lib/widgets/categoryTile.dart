import 'package:flutter/material.dart';
import 'package:sbcart/models/Category.dart';
import 'package:sbcart/userScreens/allProduct.dart';
import 'package:sbcart/widgets/cachedImage.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  CategoryTile({this.category});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 20),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AllProducts(
                          category: category,
                        ))),
            child: Container(
              height: 500,
              margin: EdgeInsets.only(top: 10, bottom: 20),
              child:
                  roundedCachedImageProvider(mediaUrl: category.imagePosterUrl),
            ),
          ),
          Text(
            category.name,
            style: Theme.of(context).textTheme.headline3,
          ),
          Text(
            category.includes,
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }
}
