import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sbcart/data/allData.dart';
import 'package:sbcart/models/Category.dart';
import 'package:sbcart/widgets/addProductHeader.dart';
import 'package:sbcart/widgets/otherheader.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sbcart/userScreens/home.dart';
import 'package:sbcart/widgets/progress.dart';
import 'package:uuid/uuid.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  File file;
  bool isUploading = false;
  String productId = Uuid().v4();
  String dropDownColorValue;
  String dropDownSizeValue;
  String dropDownGenderValue;
  String dropDownCategoryValue;

  List<Category> categories;
  String gender = 'forhim';
  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    QuerySnapshot snapshot = await categoriesRef
        .orderBy('timestamp', descending: true)
        .where('gender', isEqualTo: gender)
        .getDocuments();
    setState(() {
      categories =
          snapshot.documents.map((doc) => Category.fromDocument(doc)).toList();
    });
  }

  // pickImage
  pickImage() async {
    ImagePicker imagePicker = ImagePicker();

    PickedFile file = await imagePicker.getImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 675,
      maxWidth: 960,
    );

    if (file != null) {
      File _file = File(file.path);
      print(file.path);
      setState(() {
        this.file = _file;
      });
    }
  }

  // Splash screen
  Scaffold buildSplashScreen() {
    return Scaffold(
      appBar: otherHeader(title: 'Add Product', context: context),
      body: Center(
        child: Container(
          height: 50,
          child: FlatButton(
            onPressed: () => pickImage(),
            color: Theme.of(context).buttonColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
            child: Text(
              'Upload Product Image',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  // Upload screen
  Scaffold buildUploadScreen() {
    return Scaffold(
      appBar: addProductHeader(
          title: 'Upload', context: context, onPost: uploadProduct),
      body: Column(
        children: <Widget>[
          Flexible(
            child: Container(
              child: ListView(
                children: <Widget>[
                  isUploading
                      ? linearProgress()
                      : Container(height: 0, child: Text('')),
                  AspectRatio(
                    aspectRatio: 16 / 10,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(file),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(
                        Icons.category,
                        color: Colors.white,
                      ),
                    ),
                    title: Container(
                      child: TextField(
                        controller: productNameController,
                        cursorColor: Theme.of(context).accentColor,
                        style: TextStyle(
                            color:
                                Theme.of(context).primaryColor.withOpacity(.8)),
                        decoration: InputDecoration(
                          hintText: 'Name of Product...',
                          hintStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(
                        Icons.monetization_on,
                        color: Colors.white,
                      ),
                    ),
                    title: Container(
                      child: TextField(
                        controller: productPriceController,
                        cursorColor: Theme.of(context).accentColor,
                        style: TextStyle(
                            color:
                                Theme.of(context).primaryColor.withOpacity(.8)),
                        decoration: InputDecoration(
                          hintText: 'Price...',
                          hintStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        DropdownButton(
                          onChanged: (value) {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }

                            setState(() {
                              dropDownColorValue = value;
                            });
                          },
                          hint: Text(
                            'Select Colors',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.8),
                            ),
                          ),
                          value: dropDownColorValue,
                          items: getAllColors()
                              .map((e) => DropdownMenuItem(
                                    value: e.colorName,
                                    child: Container(
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: 15,
                                              backgroundColor: e.color,
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              e.colorName,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(.8)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                        DropdownButton(
                          onChanged: (value) {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            setState(() {
                              dropDownSizeValue = value;
                            });
                          },
                          hint: Text(
                            'Select Sizes',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.8),
                            ),
                          ),
                          value: dropDownSizeValue,
                          items: getAllSizes()
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.size,
                                  child: Text(
                                    e.size,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.8),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        DropdownButton(
                          onChanged: (value) {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            setState(() {
                              dropDownGenderValue = value;
                              gender = value;
                            });
                            getAllCategories();
                          },
                          hint: Text(
                            'Select Gender',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.8),
                            ),
                          ),
                          value: dropDownGenderValue,
                          items: [
                            DropdownMenuItem(
                              child: Text(
                                'For Him',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.8),
                                ),
                              ),
                              value: 'forhim',
                            ),
                            DropdownMenuItem(
                              child: Text(
                                'For Her',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.8),
                                ),
                              ),
                              value: 'forher',
                            ),
                          ],
                        ),
                        DropdownButton(
                          onChanged: (value) {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            setState(() {
                              dropDownCategoryValue = value;
                            });
                          },
                          hint: Text(
                            'Select Category',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.8),
                            ),
                          ),
                          value: dropDownCategoryValue,
                          items: categories == null
                              ? DropdownMenuItem(
                                  child: Text(''),
                                )
                              : categories
                                  .map((e) => DropdownMenuItem(
                                        value: e.name,
                                        child: Text(
                                          e.name,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(.8),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    controller: stockController,
                    cursorColor: Theme.of(context).accentColor,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor.withOpacity(.8)),
                    decoration: InputDecoration(
                      hintText: 'Stocks',
                      hintStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                      border: InputBorder.none,
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

  uploadProduct() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isUploading = true;
    });

    // upload image to storage bucket to get imageUrl
    String mediaUrl = await uploadToStorageBucket();

    await createProductInFireStore(
      id: productId,
      name: productNameController.text,
      gender: dropDownGenderValue,
      productImageUrl: mediaUrl,
      category: dropDownCategoryValue,
      size: dropDownSizeValue,
      stock: stockController.text,
      price: productPriceController.text,
      color: dropDownColorValue,
    );

    productNameController.clear();
    productPriceController.clear();
    stockController.clear();
    setState(() {
      isUploading = false;
      productId = Uuid().v4();
      dropDownSizeValue = null;
      dropDownCategoryValue = null;
      dropDownColorValue = null;
      dropDownGenderValue = null;
    });
    clearFile();
  }

  // uploadToStorageBucket
  Future<String> uploadToStorageBucket() async {
    StorageUploadTask uploadTask =
        storageRef.child('product_$productId.jpg').putFile(file);
    StorageTaskSnapshot snapshotSnap = await uploadTask.onComplete;
    String downloadUrl = await snapshotSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  createProductInFireStore(
      {id,
      name,
      gender,
      category,
      color,
      size,
      productImageUrl,
      price,
      stock}) {
    productsRef.document(productId).setData({
      'id': id,
      'name': name,
      'gender': gender,
      'category': category,
      'color': color,
      'size': size,
      'productImageUrl': productImageUrl,
      'price': price,
      'stock': stock,
      'timestamp': DateTime.now(),
    });
  }

  clearFile() {
    setState(() {
      this.file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: file == null ? buildSplashScreen() : buildUploadScreen(),
    );
  }
}
