import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sbcart/widgets/otherheader.dart';

class ErrorInPayment extends StatelessWidget {
  final PaymentFailureResponse response;
  ErrorInPayment({this.response});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: otherHeader(title: 'Payment Failed', context: context),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/paymentFail.png',
              color: Theme.of(context).accentColor,
              height: 250,
            ),
            Text(
              'Order Failed.',
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Payment was failed reasons could be, loss of internet connectivity or cancellation of payment.',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
