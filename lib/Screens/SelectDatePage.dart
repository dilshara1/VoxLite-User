import 'dart:math';
import 'dart:ui';
import 'package:palette_generator/palette_generator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'seactSel.dart';


class SelectDatePage extends StatefulWidget {
  final String movieID;
  final String backimg;
  SelectDatePage({required this.movieID, required this.backimg});

  @override
  _SelectDatePageState createState() => _SelectDatePageState(this.backimg);
}

class _SelectDatePageState extends State<SelectDatePage> {
   final String backimg1;
  List<DateTime> _dates = [];
 bool isLoading = true;
  DateTime _showtime = DateTime(2022, 1, 1, 20, 0);
List<Color> myColors = [];

  _SelectDatePageState( this.backimg1);
  get movieID => null;
  @override
  void initState() {
    super.initState();
 _loadColors();
    _getTime();
  // getCachedImageColors(widget.backimg);
  }

 Future<void> _loadColors() async {
    setState(() {
      isLoading = true;
    });
    final colors = await getCachedImageColors(widget.backimg);
    setState(() {
      myColors = colors;
      isLoading = false;
    });
    print('My colors are $myColors');
  }

  Future<List<Color>> getCachedImageColors(String imageUrl) async {
    final file = await DefaultCacheManager().getSingleFile(widget.backimg);
    final imageProvider = FileImage(file);
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      imageProvider,
      maximumColorCount: 5, // Reduce the maximum color count
    );
    print('Color 2 is ${paletteGenerator.colors.toList()}');
    return paletteGenerator.colors.toList();
  }



  void _getTime() async {
    String movieID = widget.movieID;

    // Get movie startDateTime from Firebase
    DocumentSnapshot movieSnapshot = await FirebaseFirestore.instance
        .collection('movies')
        .doc(widget.movieID)
        .get();
    DateTime startDateTime = movieSnapshot.get('startDateTime').toDate();
    //print('The show time get from firebase $startDateTime');
    setState(() {
      _showtime = startDateTime;
      _loadDates();
    });
  }


  void _loadDates() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('movies')
        .doc(widget.movieID)
        .get();
    if (snapshot.exists) {
      DateTime startDate = snapshot['startDateTime'].toDate();
      DateTime endDate = snapshot['endDateTime'].toDate();

      print('Movie $startDate not found');

      _dates = await _getDatesInRange(startDate, endDate);
      setState(() {});
    } else {
      print('Movie ${widget.movieID} not found');
    }
  }

  List<DateTime> _getDatesInRange(DateTime start, DateTime end) {
    List<DateTime> dates = [];
    DateTime today = DateTime.now();
    DateTime showtime = _showtime;
    int h = 2; // change H time

    for (var i = 0; i <= end.difference(start).inDays; i++) {
      DateTime date = start.add(Duration(days: i));

      if (!date.isBefore(today)) {
        bool isSameDay = today.year == date.year &&
            today.month == date.month &&
            today.day == date.day;

        if (isSameDay) {
          if ((showtime.hour > today.hour + h ||
              showtime.minute >= today.minute)) {
            dates.add(date);
            print(
                'Today and start are the same day and showtime is after $h hours. - Now-$today Showtime- $showtime ID- $movieID');
          } else {
            print(
                'Today and start are the same day, but showtime is less than $h hours after Now. Skipping date. - Now-$today Showtime- $showtime ID- $movieID');
          }
        } else {
          dates.add(date);
          print(
              'Today and start Before Today - Now-$today Showtime- $showtime ID- $movieID');
        }
      } else {
        continue;
      }
    }

    return dates;
  }

  void _onDateSelected(DateTime date) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderPage(
          movieID: widget.movieID,
          selectedDate: date,
           backimg:backimg1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cacheManager = CacheManager(
      Config(
        'my_cache_key',
        stalePeriod: const Duration(days: 7),
        maxNrOfCacheObjects: 20,
      ),
    );
    return Stack(children: [
      CachedNetworkImage(
        imageUrl: widget.backimg,
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
        cacheKey: widget.backimg,
      ),
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 6, 0, 92).withOpacity(0.02),
          ),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Select Date'),
          backgroundColor: Colors.transparent,
        ),
        body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Center(
            child: _dates.isEmpty
                ? const CircularProgressIndicator()
                : ListView.builder(
                    itemCount: _dates.length,
                    itemBuilder: (context, index) {
                      DateTime date = _dates[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Ink(
                          decoration: BoxDecoration(
                            color:myColors[2]
                                .withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: InkWell(
                            onTap: () {
                              _onDateSelected(date);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 63,
                              ),
                              child: Center(
                                child: Text(
                                  '${date.year}-${date.month}-${date.day}',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    ]);
  }
}

