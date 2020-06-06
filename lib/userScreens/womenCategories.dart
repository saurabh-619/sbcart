import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sbcart/models/Category.dart';
import 'package:sbcart/userScreens/home.dart';
import 'package:sbcart/widgets/categoryTile.dart';
import 'package:sbcart/widgets/header.dart';
import 'package:sbcart/widgets/progress.dart';

class WomenCategories extends StatefulWidget {
  @override
  _WomenCategoriesState createState() => _WomenCategoriesState();
}

class _WomenCategoriesState extends State<WomenCategories> {
  List<Category> categories;
  @override
  void initState() {
    super.initState();
  }

  getAllWomanCategories() async {
    QuerySnapshot snapshot = await categoriesRef
        .where('gender', isEqualTo: 'forher')
        .orderBy('timestamp', descending: false)
        .getDocuments();
    this.categories =
        snapshot.documents.map((doc) => Category.fromDocument(doc)).toList();
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(title: 'women', context: context),
      body: RefreshIndicator(
        onRefresh: () {
          return getAllWomanCategories();
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Categories',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor.withOpacity(0.85),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/delivery.png',
                          height: 70,
                        ),
                        Container(
                          width: 200,
                          alignment: Alignment.center,
                          child: Text(
                            'Fastest and Easy delivery Worldwide',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(color: Colors.white),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  StreamBuilder(
                    stream: categoriesRef
                        .where('gender', isEqualTo: 'forher')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return circularProgress();
                      }
                      List<Category> categories = [];
                      snapshot.data.documents.forEach(
                          (doc) => categories.add(Category.fromDocument(doc)));

                      List<CategoryTile> categoryTiles = [];
                      categories.forEach((category) {
                        categoryTiles.add(CategoryTile(category: category));
                      });

                      return Column(
                        children: categoryTiles,
                      );
                    },
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
