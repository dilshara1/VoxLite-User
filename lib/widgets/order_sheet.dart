
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import '../colors.dart';
import 'cookie_button.dart';

enum PaymentType {
  giftcardPayment,
  cardPayment,
  googlePay,
  applePay,
  buyerVerification,
  secureRemoteCommerce
}



class OrderSheet extends StatelessWidget {
  final bool googlePayEnabled;
  final bool applePayEnabled;
  OrderSheet({required this.googlePayEnabled, required this.applePayEnabled});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0))),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: _title(context),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                    minHeight: 350,
                    maxHeight: MediaQuery.of(context).size.height,
                    maxWidth: MediaQuery.of(context).size.width),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                    
            _PaymentTotal(),
               _detailscard(),
                      _LineDivider(),
                
                      _payButtons(context),
                      _buyerVerificationButton(context),
                    //  _masterCardButton(context)
                    ]),
              ),
            ]),
      );

  Widget _title(context) => Container(
        padding: EdgeInsets.all(5.0),
        color: mainButtonColor,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Expanded(
            child: Text(
              "Place your order",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                  color: closeButtonColor)),
        ]),
      );

















  Widget _payButtons(context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CookieButton(
            text: "Pay with gift card",
            onPressed: () {
              Navigator.pop(context, PaymentType.giftcardPayment);
            },
          ),
          CookieButton(
            text: "Pay with card",
            onPressed: () {
              Navigator.pop(context, PaymentType.cardPayment);
            },
          ),
        ],
      );

  Widget _buyerVerificationButton(context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width * .44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onPressed: googlePayEnabled || applePayEnabled
                  ? () {
                      if (Platform.isAndroid) {
                        Navigator.pop(context, PaymentType.googlePay);
                      } else if (Platform.isIOS) {
                        Navigator.pop(context, PaymentType.applePay);
                      }
                    }
                  : null,
              child: Image(
                  image: (Theme.of(context).platform == TargetPlatform.iOS)
                      ? AssetImage("assets/applePayLogo.png")
                      : AssetImage("assets/googlePayLogo.png")),
            ),
          ),
          
        ],
      );

  Widget _masterCardButton(context) => Column(
        children: [
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width * .44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, PaymentType.secureRemoteCommerce);
              },
              child: Image(image: AssetImage("assets/masterCardLogo.png")),
            ),
          ),
        ],
      );
}


class _LineDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.only(left: 30, right: 30),
      child: Divider(
        height: 1,
        color: dividerColor,
      ));
}



class _PaymentTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 30)),
          Text(
            "Please select your preferred payment method",
            style: TextStyle(
                fontSize: 16,
                color: mainTextColor,
                fontWeight: FontWeight.bold),
          ),
          
   
         
        ],
      );
}

class _detailscard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 30)),
          Text(
            " * Your payment is 100% secure.",
            style: TextStyle(
                fontSize: 16,
                color: mainTextColor,
                fontWeight: FontWeight.bold),
          ),
          
   
         
        ],
      );
}
