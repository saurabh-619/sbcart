import 'package:flutter/material.dart';
import 'package:sbcart/adminSection/addCategories.dart';
import 'package:sbcart/adminSection/addProduct.dart';
import 'package:sbcart/userScreens/auth.dart';
import 'package:sbcart/userScreens/changeAddress.dart';
import 'package:sbcart/userScreens/home.dart';
import 'package:sbcart/widgets/otherheader.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: otherHeader(title: 'Settings', context: context),
      body: ListView(
        children: <Widget>[
          !currentUser.isAdmin
              ? Text('')
              : Container(
                  margin: EdgeInsets.only(top: 10),
                  child: ListTile(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddCategory())),
                    leading: Image.asset(
                      'assets/images/categories/addCategories.png',
                      height: 55,
                    ),
                    title: Text('Add Category'),
                  ),
                ),
          !currentUser.isAdmin
              ? Text('')
              : Divider(
                  color: Theme.of(context).primaryColor,
                ),
          !currentUser.isAdmin
              ? Text('')
              : ListTile(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddProduct())),
                  leading:
                      Image.asset('assets/images/categories/addProduct.png'),
                  title: Text('Add Product'),
                ),
          ListTile(
            onTap: () async {
              String address = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeAddress(
                    account: googleSignIn.currentUser,
                  ),
                ),
              );

              userRef.document(currentUser.id).updateData({
                'address': address,
              });
            },
            leading: Icon(
              Icons.edit_location,
              color: Theme.of(context).primaryColor,
              size: 50,
            ),
            title: Text('Change address'),
          ),
          Divider(
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
