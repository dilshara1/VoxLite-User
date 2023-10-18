
import 'dart:ui';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voxliteapp/Screens/home.dart';

import '../colors.dart';

class myOrders extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<myOrders> {
  String _statusFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      const Image(
        image: AssetImage('assets/dafault-background-blur.png'),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 6, 0, 92).withOpacity(0.02),
          ),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('My Orders'),

          backgroundColor: Colors.transparent,

          // Set the app bar color here
        ),
        body: Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              DropdownButton<String>(
                value: _statusFilter,
                items: <String>['All', 'waiting', 'watched']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _statusFilter = value!;
                  });
                },
                style: const TextStyle(
                    color: Color.fromARGB(
                        255, 255, 255, 255)), // Set the text color here
                dropdownColor: const Color.fromARGB(
                    255, 8, 0, 0), // Set the dropdown background color here
                iconEnabledColor: const Color.fromARGB(
                    255, 255, 255, 255), // Set the dropdown icon color here
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .where('userID', isEqualTo: HomePage.GuserUD)
                      .where('status',
                          isEqualTo:
                              _statusFilter == 'All' ? null : _statusFilter)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style:
                              const TextStyle(color: kc3), // Set the text color here
                        ),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(MyColors
                              .kc1), // Set the progress indicator color here
                        ),
                      );
                    }

                    List<Order> orders = snapshot.data!.docs
                        .map((doc) => Order.fromSnapshot(doc))
                        .toList();

                    if (orders.isEmpty) {
                      return const Center(
                        child: Text(
                          'No orders found.',
                          style:
                              TextStyle(color: kc3), // Set the text color here
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: orders.length,
                      separatorBuilder: (context, index) => const Divider(
                        thickness: 5,
                        color: Color.fromARGB(0, 255, 255, 255),
                        // Set the divider color here
                      ),
                      itemBuilder: (context, index) {
                        Order order = orders[index];
                        return FutureBuilder(
                          future: order.fetchMovieData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const ListTile(
                                title: Text(
                                  'Loading...',
                                  style: TextStyle(
                                      color: MyColors
                                          .kc3), // Set the text color here
                                ),
                              );
                            }
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: const DecorationImage(
                                  image: AssetImage(
                                      'assets/dafault-background1.jpg'),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              child: ListTile(
                                subtitle: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        // color: Color.fromARGB(255, 253, 1, 1) .withOpacity(0.5),
                                      ),
                                    ),
                                    SafeArea(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 16.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Order ID :${order.orderID}',
                                                style: const TextStyle(color: kc3),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                order.movieName.length > 40
                                                    ? '${order.movieName.substring(0, 40)}...'
                                                    : order.movieName,
                                                style: const TextStyle(color: kc3),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                '${DateFormat('EEE, MMM d, y').format(order.selectedDate)} ',
                                                style: const TextStyle(color: kc3),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                '${DateFormat('h:mm a').format(order.mtime)} ',
                                                style: const TextStyle(color: kc3),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              const Text(
                                                'Seats:',
                                                style: TextStyle(color: kc3),
                                              ),
                                              const SizedBox(width: 8),
                                              const SizedBox(height: 10.0),
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                padding: const EdgeInsets.all(4),
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: order
                                                        .selectedSeats
                                                        .take(4)
                                                        .map((seat) =>
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            3),
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(3),
                                                              margin: const EdgeInsets
                                                                  .all(2),
                                                              child: Text(
                                                                seat,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 10,
                                                                  color: kc3,
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                  ),
                                                ),
                                              ),
                                              if (order.selectedSeats.length >
                                                  4)
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: kc3,
                                                  ),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Selected Seats'),
                                                          content:
                                                              SingleChildScrollView(
                                                            child: Wrap(
                                                              children: order
                                                                  .selectedSeats
                                                                  .map((seat) =>
                                                                      Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                kc2,
                                                                            width:
                                                                                1,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(4),
                                                                        ),
                                                                        padding:
                                                                            const EdgeInsets.all(4),
                                                                        margin:
                                                                            const EdgeInsets.all(4),
                                                                        child:
                                                                            Text(
                                                                          seat,
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                kc2,
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  .toList(),
                                                            ),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              child:
                                                                  const Text('Close'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Status: ${order.status}',
                                                style: const TextStyle(color: kc3),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.monetization_on, color: kc3),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${order.total.toStringAsFixed(2)}',
                                      style: const TextStyle(color: kc3),
                                    ),
                                  ],
                                ),
                                //  tileColor: kc2,
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}

class Order {
  final String orderID;
  final String movieID;
  String movieName;
  DateTime mtime;
  final DateTime selectedDate;
  final String selectedShowtime;
  final List<String> selectedSeats;
  final double total;
  final String userID;
  final String status;

  Order({
    required this.orderID,
    required this.movieID,
    required this.movieName,
    required this.mtime,
    required this.selectedDate,
    required this.selectedShowtime,
    required this.selectedSeats,
    required this.total,
    required this.userID,
    required this.status,
  });

  factory Order.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Order(
      orderID: snapshot.id,
      movieID: data['movieID'],
      movieName: '',
      mtime: DateTime(2000 - 11 - 27 - 10 - 30),
      selectedDate: data['selectedDate'].toDate(),
      selectedShowtime: data['selectedShowtime'],
      selectedSeats: List<String>.from(data['selectedSeats']),
      total: data['total'].toDouble(),
      userID: data['userID'],
      status: data['status'],
    );
  }

  Future<void> fetchMovieData() async {
    DocumentSnapshot movieSnapshot = await FirebaseFirestore.instance
        .collection('movies')
        .doc(movieID)
        .get();
    Map<String, dynamic> movieData =
        movieSnapshot.data() as Map<String, dynamic>;
    movieName = movieData['title'];

    try {
      Timestamp startDateTime = movieSnapshot.get('startDateTime');
      mtime = startDateTime.toDate();
    } catch (e) {
      print('Error: $e');
    }
  }

}
