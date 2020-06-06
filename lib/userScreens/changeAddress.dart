import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sbcart/widgets/otherheader.dart';

class ChangeAddress extends StatelessWidget {
  final GoogleSignInAccount account;
  final _formkey = GlobalKey<FormState>();
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final TextEditingController addressController = TextEditingController();
  String address;

  ChangeAddress({this.account});

  onSubmit(context) {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();

      SnackBar _snackBar = SnackBar(
        content: Text(
          'Address changed to \'${addressController.text}\'',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).accentColor,
      );
      _scaffoldkey.currentState.showSnackBar(_snackBar);

      Timer(Duration(seconds: 2), () {
        Navigator.pop(context, address);
      });
    }
  }

  getGeoLocation() async {
    try {
      final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
      Position position = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemark = await geolocator.placemarkFromCoordinates(
          position.latitude, position.longitude);

      String geoaddress =
          '${placemark[0].name}, ${placemark[0].locality}, ${placemark[0].subAdministrativeArea}, ${placemark[0].administrativeArea}';
      addressController.value = TextEditingValue(text: geoaddress);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: otherHeader(
          title: 'Add your Info', context: context, backButton: false),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(account.photoUrl),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.greenAccent,
                      child: Icon(
                        Icons.check,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Hello ${account.displayName}, We\'ll need your address for shipping of orders.',
              textAlign: TextAlign.center,
              style:
                  Theme.of(context).textTheme.headline4.copyWith(fontSize: 19),
            ),
            SizedBox(
              height: 15,
            ),
            Form(
              key: _formkey,
              autovalidate: true,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: addressController,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                  decoration: InputDecoration(labelText: 'Your Address'),
                  validator: (userInput) {
                    if (userInput.isEmpty || userInput.trim().length < 5)
                      return 'Address is too short';
                    else
                      return null;
                  },
                  onSaved: (val) {
                    address = val;
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => getGeoLocation(),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(Icons.location_on),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Get location',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        TextSpan(
                          text: '   Turn location ON!',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontSize: 12),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 55,
              width: 145,
              margin: EdgeInsets.only(top: 15),
              child: FlatButton(
                onPressed: () => onSubmit(context),
                color: Theme.of(context).buttonColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60)),
                child: Text(
                  'Submit',
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
}
