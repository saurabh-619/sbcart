import 'package:flutter/material.dart';
import 'package:sbcart/userScreens/aboutus.dart';
import 'package:sbcart/userScreens/home.dart';
import 'package:sbcart/userScreens/orderHistory.dart';
import 'package:sbcart/userScreens/orderNotifications.dart';
import 'package:sbcart/userScreens/settings.dart';
import 'package:sbcart/userScreens/auth.dart';

Drawer getDrawer(BuildContext context) {
  logout() async {
    await googleSignIn.signOut();
    // Timer(Duration(seconds: 2), () {
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => AuthScreen()));
    // });
  }

  return Drawer(
    child: ListView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Container(
          height: 220,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(currentUser.photoUrl),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                currentUser.name,
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(
                currentUser.email,
                style: Theme.of(context).textTheme.headline6,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Container(
            height: 500,
            padding: EdgeInsets.only(top: 10, bottom: 15),
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 65,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: ListTile(
                            title: Text(
                              'Home',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(.8),
                                  ),
                            ),
                            leading: Icon(Icons.home,
                                color: Theme.of(context).primaryColor),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Home(),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          height: 65,
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: ListTile(
                            title: Text(
                              'Order History',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(.8),
                                  ),
                            ),
                            leading: Icon(Icons.history,
                                color: Theme.of(context).primaryColor),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderHistory()),
                              );
                            },
                          ),
                        ),
                        Container(
                          height: 65,
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: ListTile(
                            title: Text(
                              'Order Notification',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(.8),
                                  ),
                            ),
                            leading: Icon(Icons.notifications,
                                color: Theme.of(context).primaryColor),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderNotifications(),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          height: 65,
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: ListTile(
                            title: Text(
                              'App Settings',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(.8),
                                  ),
                            ),
                            leading: Icon(Icons.settings,
                                color: Theme.of(context).primaryColor),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Settings(),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          height: 65,
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: ListTile(
                            title: Text(
                              'About Us',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(.8),
                                  ),
                            ),
                            leading: Icon(Icons.help,
                                color: Theme.of(context).primaryColor),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AboutUs(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: ListTile(
                      onTap: () {
                        logout();
                      },
                      leading: Icon(Icons.exit_to_app,
                          color:
                              Theme.of(context).primaryColor.withOpacity(.9)),
                      title: Text(
                        'Log Out',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor.withOpacity(.9),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    ),
  );
}
