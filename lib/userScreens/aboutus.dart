import 'package:flutter/material.dart';
import 'package:sbcart/widgets/otherheader.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: otherHeader(title: 'About Us', context: context),
      body: Container(
        color: Theme.of(context).primaryColor.withOpacity(.05),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                'assets/images/logoSbcart.png',
                height: 150,
              ),
              Text(
                'sbcart',
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
              ),
              Text(
                ' sbcart is an e-commerce app made with Google\'s Flutter and Firebase. With sbcart a user can log-in. sbcart provides various categories mainly focused on Youth like clothing, watches, sunglasses, grooming, etc. Each category has many products which a user can add, remove from wishlist also can add, remove from the cart. Users can also make true/fake payments secured by Razorpay payment Gateway. All kinds of payment can be processed.',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.justify,
              ),
              Text(
                'Use 4111-1111-1111-1111 as demo card and all other info including phone no. fill randomly.',
                style: Theme.of(context).textTheme.headline5.copyWith(
                      color: Theme.of(context).primaryColor.withOpacity(.8),
                    ),
                textAlign: TextAlign.justify,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.asset(
                    'assets/images/saurabh.png',
                    height: 70,
                  ),
                  Text(
                    '~ Saurabh Bomble',
                    style: Theme.of(context).textTheme.headline3,
                    textAlign: TextAlign.end,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
