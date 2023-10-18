/*
 Copyright 2018 Square Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/
import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:square_in_app_payments/google_pay_constants.dart'
    as google_pay_constants;
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:voxliteapp/models/user.dart';

import '../colors.dart';
import '../config.dart';
import '../models/movie.dart';
import '../widgets/buy_sheet.dart';

class Payment extends StatefulWidget {
  final String userID;
  final String movieID;
  final DateTime selectedDate;
  final String selectedShowtime;
  final List<String> selectedSeats;
  final double total;


  final String title;

  final double price;

  Payment({
    required this.userID,
    required this.movieID,
    required this.selectedDate,
    required this.selectedShowtime,
    required this.selectedSeats,
    required this.total,

    required this.title,
    required this.price,
  });

  @override
  PaymentScreenState createState() => PaymentScreenState(
      userID,
      movieID,
      selectedDate,
      selectedShowtime,
      selectedSeats,
      total,

      title,
      price);
}

class PaymentScreenState extends State<Payment> {
  bool isLoading = true;
  bool applePayEnabled = false;
  bool googlePayEnabled = false;

  final String? userID;
  final String? movieID;
  final DateTime? selectedDate;
  final String? selectedShowtime;
  final List<String>? selectedSeats;
  final double? total;

  final String title;

  final double price;

  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  PaymentScreenState(
    this.userID,
    this.movieID,
    this.selectedDate,
    this.selectedShowtime,
    this.selectedSeats,
    this.total,

    this.title,
    this.price,
  );

  @override
  void initState() {
    super.initState();
    _initSquarePayment();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Print out the values of the variables
    print('movieID: $movieID');
    print('selectedDate: $selectedDate');
    print('selectedShowtime: $selectedShowtime');
    print('selectedSeats: $selectedSeats');
    print('total: $total');


    print('title: $title');

    print('price: $price');
  }

  Future<void> _initSquarePayment() async {
    await InAppPayments.setSquareApplicationId(squareApplicationId);

    var canUseApplePay = false;
    var canUseGooglePay = false;
    if (Platform.isAndroid) {
      await InAppPayments.initializeGooglePay(
          squareLocationId, google_pay_constants.environmentTest);
      canUseGooglePay = await InAppPayments.canUseGooglePay;
    } else if (Platform.isIOS) {
      await _setIOSCardEntryTheme();
      await InAppPayments.initializeApplePay(applePayMerchantId);
      canUseApplePay = await InAppPayments.canUseApplePay;
    }

    setState(() {
      isLoading = false;
      applePayEnabled = canUseApplePay;
      googlePayEnabled = canUseGooglePay;
    });
  }

  Future _setIOSCardEntryTheme() async {
    var themeConfiguationBuilder = IOSThemeBuilder();
    themeConfiguationBuilder.saveButtonTitle = 'Pay';
    themeConfiguationBuilder.errorColor = RGBAColorBuilder()
      ..r = 255
      ..g = 0
      ..b = 0;
    themeConfiguationBuilder.tintColor = RGBAColorBuilder()
      ..r = 36
      ..g = 152
      ..b = 141;
    themeConfiguationBuilder.keyboardAppearance = KeyboardAppearance.light;
    themeConfiguationBuilder.messageColor = RGBAColorBuilder()
      ..r = 114
      ..g = 114
      ..b = 114;

    await InAppPayments.setIOSCardEntryTheme(themeConfiguationBuilder.build());
  }

  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
      theme: ThemeData(canvasColor: Colors.white),
      home: Scaffold(
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(mainBackgroundColor),
                ))
              : BuySheet(
                  applePayEnabled: applePayEnabled,
                  googlePayEnabled: googlePayEnabled,
                  applePayMerchantId: applePayMerchantId,
                  squareLocationId: squareLocationId,
                  userID: userID,
                  movieID: movieID,
                  selectedDate: selectedDate,
                  selectedShowtime: selectedShowtime,
                  selectedSeats: selectedSeats,
                  total: total,
                  price: price,
                  title: title)));
}
