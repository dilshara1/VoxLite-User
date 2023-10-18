import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voxliteapp/Screens/PlaceOrderScreen.dart';
import 'package:voxliteapp/Screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:square_in_app_payments/google_pay_constants.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:square_in_app_payments/google_pay_constants.dart'
    as google_pay_constants;
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

// import 'package:webview_flutter/webview_flutter.dart';
import '../colors.dart';

import 'package:flutter/material.dart';

import '../config.dart';
import '../models/movie.dart';

// import 'package:flutter_localizations/flutter_localizations.dart';

class OrderPage extends StatefulWidget {
  final String movieID;
  final DateTime selectedDate;
  final String backimg;
  OrderPage(
      {required this.movieID,
      required this.selectedDate,
      required this.backimg});

  @override
  _OrderPageState createState() => _OrderPageState(this.backimg);
}

class _OrderPageState extends State<OrderPage> {
  DateTime _showtime = DateTime(2000 - 11 - 27);
  final String backimg1;
  bool isLoading = true;
  bool applePayEnabled = false;
  bool googlePayEnabled = false;

  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  _OrderPageState(this.backimg1);

  @override
  void initState() {
    super.initState();
    // _getTime();
    _getMoviePrice();
    _getBookedSeats();
    _initSquarePayment();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    //   _getMovieShowtimes();
  }

  double _moviePrice = 0;
  List<List<String>> _seats = [
    ['1', '2', '3', '4', '5', ' ', '6', '7', '8', '9', '10'],
    ['11', '12', '13', '14', '15', ' ', '16', '17', '18', '19', '20'],
    ['21', '22', '23', '24', '25', ' ', '26', '27', '28', '29', '30'],
    ['31', '32', '33', '34', '35', ' ', '36', '37', '38', '39', '40'],
    ['41', '42', '43', '44', '45', ' ', '46', '47', '48', '49', '50'],
    ['51', '52', '53', '54', '55', ' ', '56', '57', '58', '59', '60'],
    ['61', '62', '63', '64', '65', ' ', '66', '67', '68', '69', '70'],
    ['71', '72', '73', '74', '75', ' ', '76', '77', '78', '79', '80'],
    ['81', '82', '83', '84', '85', ' ', '86', '87', '88', '89', '90'],
    ['91', '92', '93', '94', '95', ' ', '96', '97', '98', '99', '100'],
  ];
  List<String> _selectedSeats = [];
  List<String> _bookedSeats = [];

  void _selectSeat(int row, int col) {
    setState(() {
      String seat = _seats[row][col];
      if (seat != ' ') {
        if (_selectedSeats.contains(seat)) {
          _selectedSeats.remove(seat);
        } else {
          _selectedSeats.add(seat);
        }
      }
    });
  }

  void _getTime() async {
    String movieID = widget.movieID;

    // Get movie startDateTime from Firebase
    DocumentSnapshot movieSnapshot = await FirebaseFirestore.instance
        .collection('movies')
        .doc(movieID)
        .get();
    dynamic startDateTime = movieSnapshot.get('startDateTime');
    DateTime mshowtime;

    if (startDateTime is Timestamp) {
      mshowtime = startDateTime.toDate();

      print('This is time get from Firebase 1: $mshowtime');
    } else {
      mshowtime = startDateTime;
      print('This is time get from Firebase 2: $mshowtime');
    }

    String formattedTime =
        DateFormat('h:mm a').format(mshowtime); // Format time with AM or PM

    print('This is time get from Firebase 3: $formattedTime');

    setState(() {
      _showtime = mshowtime;
    });
  }

  void _getMoviePrice() async {
    String movieID = widget.movieID;

    // Get movie price from Firebase
    DocumentSnapshot movieSnapshot = await FirebaseFirestore.instance
        .collection('movies')
        .doc(movieID)
        .get();
    double moviePrice = movieSnapshot.get('price');

    // DateTime mshow = movieSnapshot.get('startDateTime');
    // TimeOfDay showtime = TimeOfDay.fromDateTime(mshow);

    setState(() {
      _moviePrice = moviePrice;
      print('This is price$_moviePrice');
      print('THIS IS URL $backimg1');
      //  _showtime = showtime;
    });
  }

  void _getBookedSeats() async {
    String movieID = widget.movieID;
    DateTime selectedDate = widget.selectedDate;
    String selectedShowtime = _showtime.toString(); // Convert to string

    // Get booked seats for selected date and showtime
    List<String> bookedSeats = [];
    QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('movieID', isEqualTo: movieID)
        .where('selectedDate', isEqualTo: selectedDate)
        .where('selectedShowtime', isEqualTo: selectedShowtime)
        .get();
    ordersSnapshot.docs.forEach((doc) {
      List<dynamic> selectedSeats = doc['selectedSeats'];
      bookedSeats.addAll(List<String>.from(selectedSeats));
    });

    setState(() {
      _bookedSeats = bookedSeats;
    });
  }

/////////////////////////////////////////////////////////////////////////////////////////////

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

  ///
  ///
  ///
  ///
  ///
  ///

  void _paymentRun() async {
    String userID = HomePage.GuserUD;
    String movieID = widget.movieID;
    DateTime selectedDate = widget.selectedDate;
    String selectedShowtime = _showtime.toString();
    List<String> selectedSeats = _selectedSeats;
    double total = totalPrice;

    String key;
    String coverUrl;
    String title;
    DateTime startDate;

    double price;

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('movies')
        .doc(movieID)
        .get();

    String key1 = documentSnapshot.id;

    String title1 = documentSnapshot.get('title');
    DateTime showtime1 = documentSnapshot.get('startDateTime').toDate();
    double price1 = documentSnapshot.get('price');

    setState(() {
      title = title1;
      startDate = showtime1;
      price = price1;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Payment(
            userID: userID,
            movieID: movieID,
            selectedDate: selectedDate,
            selectedShowtime: selectedShowtime,
            selectedSeats: selectedSeats,
            total: total,
            title: title1,
            price: price1),
      ),
    );
  }

  void _placeOrder() async {
    String userID = HomePage.GuserUD;
    String movieID = widget.movieID;
    DateTime selectedDate = widget.selectedDate;
    String selectedShowtime = _showtime.toString();
    List<String> selectedSeats = _selectedSeats;
    double total = totalPrice;

    // Update movie document with booked seats
    DocumentReference movieRef =
        FirebaseFirestore.instance.collection('movies').doc(movieID);
    List<List<String>> chunks = _chunkList(selectedSeats, 10);
    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (List<String> chunk in chunks) {
      QuerySnapshot seatsSnapshot = await movieRef
          .collection('seats')
          .where('name', whereIn: chunk)
          .get();
      seatsSnapshot.docs.forEach((doc) {
        batch.update(doc.reference, {'status': 'booked'});
      });
    }
    batch.commit();

    // Add order document to orders collection
    CollectionReference ordersRef =
        FirebaseFirestore.instance.collection('orders');
    ordersRef.add({
      'userID': userID,
      'movieID': movieID,
      'selectedDate': selectedDate,
      'selectedShowtime': selectedShowtime,
      'selectedSeats': selectedSeats,
      'total': total,
      'status': 'waiting',
      'OrderPlaceDate': DateTime.now()
    });

    // Navigate back to movie selection page

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);

    Navigator.pop(context);
  }

  List<List<String>> _chunkList(List<String> list, int chunkSize) {
    List<List<String>> chunks = [];
    for (int i = 0; i < list.length; i += chunkSize) {
      int end = i + chunkSize;
      chunks.add(list.sublist(i, end > list.length ? list.length : end));
    }
    return chunks;
  }

  double get totalPrice {
    return _selectedSeats.length * (_moviePrice);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double padding = 16;
    double contentHeight = screenHeight - appBarHeight - padding * 4;
    double contentWidth = screenWidth - padding * 2;
    double dateWidth = (contentWidth - padding) / 2;
    double seatWidth = contentWidth;
    double seatHeight = contentHeight - dateWidth - padding * 3 - 60;
    if (screenWidth > 600) {
      dateWidth = 300;
      seatWidth = contentWidth - dateWidth - padding;
    }

    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: backimg1,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => Image.asset(
            'assets/dafault-background.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          errorWidget: (context, url, error) => Image.asset(
            'assets/dafault-background.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          cacheKey: backimg1,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 6, 0, 92).withOpacity(0.6),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Select Seat and Pay'),
            backgroundColor: Colors.transparent,
            //  backgroundColor: kc1,
          ),
          body: Column(
            children: [
              Expanded(
                child: SafeArea(
                  child: Container(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/main/seat/1.png',
                              width: screenWidth,
                              height: 100,
                              fit: BoxFit.fitWidth,
                            ),

                            /* SvgPicture.asset(
                            'assets/main/screen_here.svg',
                            width: screenWidth,
                            height: 50,
                            fit: BoxFit.fitWidth,
                          ), */
                            const Center(
                                child: Text(
                              'Screen Here',
                              style: TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            )),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [],
                              ),
                            ),
                            SizedBox(height: padding * 2),
                            const Text(
                              'Select Seats',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: kc3),
                            ),
                            SizedBox(height: padding),
                            Column(children: [
                              SingleChildScrollView(
                                child: Container(
                                  child: Column(
                                    children:
                                        _seats.asMap().entries.map((entry) {
                                      int rowIndex = entry.key;
                                      List<String> row = entry.value;
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children:
                                            row.asMap().entries.map((entry) {
                                          int colIndex = entry.key;
                                          String seat = entry.value;
                                          bool isBooked =
                                              _bookedSeats.contains(seat);
                                          bool isSelected =
                                              _selectedSeats.contains(seat);
                                          return GestureDetector(
                                            onTap: () {
                                              if (!isBooked) {
                                                _selectSeat(rowIndex, colIndex);
                                              }
                                            },
                                            child: Container(
                                              width: 30,
                                              height: 28,
                                              margin: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: isBooked
                                                    ? const Color.fromARGB(
                                                        255, 0, 0, 0)
                                                    : isSelected
                                                        ? kc2
                                                        : const Color.fromARGB(
                                                            255, 0, 225, 255),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                    color: const Color.fromARGB(
                                                        255, 0, 183, 255)),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  seat,
                                                  style: TextStyle(
                                                    color: isBooked
                                                        ? Colors.white
                                                        : isSelected
                                                            ? Colors.white
                                                            : Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ]),
                            SizedBox(height: padding),
                            SizedBox(height: padding),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.square,
                                        color: Colors.black,
                                      ),
                                      Text('Booked',
                                          style: TextStyle(color: kc3)),
                                    ],
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.square,
                                        color: Color.fromARGB(255, 0, 225, 255),
                                      ),
                                      Text('Available',
                                          style: TextStyle(color: kc3)),
                                    ],
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.square,
                                        color: kc2,
                                      ),
                                      Text('Selected',
                                          style: TextStyle(color: kc3)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: padding),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Row(children: [
                                      Text(
                                        'Total Price: ${totalPrice.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: kc3),
                                      ),
                                    ]),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Selected Seats: ${_selectedSeats.length}',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: kc3),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                /*  ElevatedButton(
                                onPressed: () {
    
                                Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>_paymentRun( ),
                                      ),
                                    );
                                //async {
                                  //   _placeOrder(); // Call the _placeOrder() function
                                },
                                child: Text('Next '),
                              ), */
                              ],
                            ),
                            SizedBox(height: padding + 20),
                            Center(
                              child: Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () =>
                                        totalPrice > 0 ? _paymentRun() : null,
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(kc2),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(kc3),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 10),
                                      child: Text(
                                        'Next',
                                        style: GoogleFonts.montserrat(
                                          color: kc3,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
