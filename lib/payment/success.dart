import 'package:flutter/material.dart';
import 'package:sbcart/widgets/otherheader.dart';

class Success extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: otherHeader(
        title: 'Payment Successful',
        context: context,
        backButton: true,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/successFulPayment.png'),
            Text(
              'Order success.',
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'But don\'t expect delivery since your order was fake and so was your payment .',
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
