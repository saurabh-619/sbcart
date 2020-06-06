import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sbcart/userScreens/home.dart';
import 'package:sbcart/widgets/otherheader.dart';
import 'package:sbcart/widgets/progress.dart';
import 'package:uuid/uuid.dart';

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController categoryIncludesController = TextEditingController();
  File file;
  bool isUploading = false;
  String categoryId = Uuid().v4();
  String dropDownValue;

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
      appBar: otherHeader(title: 'Add Category', context: context),
      body: Center(
        child: Container(
          height: 50,
          child: FlatButton(
            onPressed: () => pickImage(),
            color: Theme.of(context).buttonColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
            child: Text(
              'Upload Category Poster',
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
      appBar: otherHeader(title: 'Upload', context: context),
      body: Column(
        children: <Widget>[
          Flexible(
            child: Container(
              height: 500,
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
                        controller: categoryNameController,
                        cursorColor: Theme.of(context).accentColor,
                        style: TextStyle(
                            color:
                                Theme.of(context).primaryColor.withOpacity(.8)),
                        decoration: InputDecoration(
                          hintText: 'Name of Category...',
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
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                    title: Container(
                      child: TextField(
                        controller: categoryIncludesController,
                        cursorColor: Theme.of(context).accentColor,
                        style: TextStyle(
                            color:
                                Theme.of(context).primaryColor.withOpacity(.8)),
                        decoration: InputDecoration(
                          hintText: 'Includes (Comma seperated values)',
                          hintStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: DropdownButton(
                      onChanged: (value) {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          dropDownValue = value;
                        });
                      },
                      hint: Text('Select Gender'),
                      value: dropDownValue,
                      items: [
                        DropdownMenuItem(
                          child: Text('For Him'),
                          value: 'forhim',
                        ),
                        DropdownMenuItem(
                          child: Text('For Her'),
                          value: 'forher',
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 180,
            height: 50,
            child: FlatButton(
              onPressed: () => uploadCategory(),
              color: Theme.of(context).buttonColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60)),
              child: Text(
                'Post',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  uploadCategory() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isUploading = true;
    });

    // upload image to storage bucket to get imageUrl
    String mediaUrl = await uploadToStorageBucket();

    await createCategoryInFireStore(
      name: categoryNameController.text,
      gender: dropDownValue,
      imagePosterUrl: mediaUrl,
      includes: categoryIncludesController.text,
    );

    categoryNameController.clear();
    categoryIncludesController.clear();
    setState(() {
      isUploading = false;
      categoryId = Uuid().v4();
      dropDownValue = null;
    });
    clearFile();
  }

  // uploadToStorageBucket
  Future<String> uploadToStorageBucket() async {
    StorageUploadTask uploadTask =
        storageRef.child('category_$categoryId.jpg').putFile(file);
    StorageTaskSnapshot snapshotSnap = await uploadTask.onComplete;
    String downloadUrl = await snapshotSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  createCategoryInFireStore({
    name,
    gender,
    imagePosterUrl,
    includes,
  }) {
    categoriesRef.document(categoryId).setData({
      'name': name,
      'gender': gender,
      'imagePosterUrl': imagePosterUrl,
      'includes': includes,
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
