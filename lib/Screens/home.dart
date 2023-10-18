import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../colors.dart';
import '../models/movie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'details.dart';
import 'profile.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class HomePage extends StatefulWidget {
  static String GuserUD = '';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name1 = '';
  String email1 = '';
  String photoUrl1 = '';
  String userUD = '';

  bool isBackgroundLoaded = false;
  void getUserDetails() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      String email = user.email!;
      String name = '';
      String photoUrl = '';

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (documentSnapshot.exists) {
        name = documentSnapshot.get('name');
        photoUrl = documentSnapshot.get('photoUrl');
        userUD = documentSnapshot.id;
        HomePage.GuserUD = userUD;
      }

      setState(() {
        name1 = name;
        email1 = email;
        photoUrl1 = photoUrl;
      });
    }
  }

  String _backgroundImage =
      'https://play-lh.googleusercontent.com/1-hPxafOxdYpYZEOKzNIkSP43HXCNftVJVttoo4ucl7rsMASXW3Xr6GlXURCubE1tA=w3840-h2160-rw';

  List<VacationBean> _list = [];

  PageController? pageController;

  double viewportFraction = 0.8;

  double? pageOffset = 0;

  @override
  void initState() {
    getUserDetails();
    super.initState();
    pageController =
        PageController(initialPage: 0, viewportFraction: viewportFraction)
          ..addListener(() {
            setState(() {
              pageOffset = pageController!.page;
            });
          });
    fetchVacationBeans();
  }

  void fetchVacationBeans() async {
  List<VacationBean> vacationBeans = await VacationBean.fetchFromFirestore();

  // Get the current local time of the user's mobile device
  DateTime now = DateTime.now();

  // Filter the vacationBeans list to only include movies where the endDate is less than today's date, or if the endDate is today, check if the end time is less than the current time
  vacationBeans = vacationBeans.where((vacationBean) {
    DateTime endDate = vacationBean.endDate;

    // Check if the endDate is before today's date
    if (endDate.isBefore(DateTime(now.year, now.month, now.day))) {
      return true;
    }

    // If the endDate is today, check if the end time is less than the current time
    if (endDate.isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
      int endHour = endDate.hour;
      int endMinute = endDate.minute;

      // Add 2 hours to the end time
      int endPlus2Hours = endHour + 2;
      if (endPlus2Hours > 23) {
        endPlus2Hours -= 24;
      }

      // Get the current time
      int currentHour = now.hour;
      int currentMinute = now.minute;

      // Check if the end time + 2 hours is less than the current time
      if (endPlus2Hours < currentHour ||
          (endPlus2Hours == currentHour && endMinute <= currentMinute)) {
        return true;
      }
    }

    // If the endDate is after today's date, exclude the movie
    return false;
  }).toList();

  setState(() {
    _list = vacationBeans;

    if (!isBackgroundLoaded) {
      _backgroundImage = _list[0].coverUrl;
      isBackgroundLoaded = true;
    }
  });
}


  /* void fetchVacationBeans() async {
    List<VacationBean> vacationBeans = await VacationBean.fetchFromFirestore();
    setState(() {
      _list = vacationBeans;

      if (!isBackgroundLoaded) {
        _backgroundImage = _list[0].coverUrl;
        isBackgroundLoaded = true;
      }
    });
  } */

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: _backgroundImage,
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
          cacheKey: _backgroundImage,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 6, 0, 92).withOpacity(0.3),
            ),
          ),
        ),
        Scaffold(
          appBar: AppBar(
              backgroundColor: Color.fromARGB(0, 255, 255, 255),
              automaticallyImplyLeading: false,
              title: Text(
                'VOXLITE CINEMA APP',
                style: GoogleFonts.montserrat(
                  color: kc3,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
              actions: [
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            Profile(
                                name: name1,
                                email: email1,
                                photoUrl: photoUrl1),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var begin = const Offset(1.0, 0.0);
                          var end = Offset.zero;
                          var curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: CircleAvatar(
                    foregroundColor: Colors.red,
                    radius: 25,
                    backgroundImage: NetworkImage(photoUrl1),
                  ),
                ),
                SizedBox(width: 10),
              ]),
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 0, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top +
                                kToolbarHeight -
                                40,
                            left: 30,
                          ),
                          child: Text(
                            "Now Showing \nMovies",
                            style: GoogleFonts.montserrat(
                              color: kc3,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          width: 150,
                          height: 100,
                          child: Lottie.network(
                              'https://assets2.lottiefiles.com/packages/lf20_j1adxtyb.json'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageViewWidget(
                  onBackgroundImageChange: (String imagePath) {
                    setState(() {
                      _backgroundImage = imagePath;
                    });
                  },
                  backgroundImage: _backgroundImage,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class PageViewWidget extends StatefulWidget {
  final Function(String) onBackgroundImageChange;

  const PageViewWidget(
      {Key? key,
      required this.onBackgroundImageChange,
      required String backgroundImage})
      : super(key: key);

  @override
  _PageViewWidgetState createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<PageViewWidget> {
  void onPageChanged(int index) {
    widget.onBackgroundImageChange(_list[index].coverUrl);
  }

  List<VacationBean> _list = [];

  PageController? pageController;

  double viewportFraction = 0.8;

  double? pageOffset = 0;

  @override
  void initState() {
    super.initState();
    pageController =
        PageController(initialPage: 0, viewportFraction: viewportFraction)
          ..addListener(() {
            setState(() {
              pageOffset = pageController!.page;
            });
          });
    fetchVacationBeans();
  }

  void fetchVacationBeans() async {
    List<VacationBean> vacationBeans = await VacationBean.fetchFromFirestore();
    setState(() {
      _list = vacationBeans;
    });
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

    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return PageView.builder(
      controller: pageController,
      itemCount: _list.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        double scale = max(
          viewportFraction,
          (1 - (pageOffset! - index).abs()) + viewportFraction,
        );

        double angle = (pageOffset! - index).abs();

        if (angle > 0.5) {
          angle = 1 - angle;
        }
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    DetailsPage(vacationBean: _list[index]),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(1.0, 0.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.only(
              right: 10,
              left: 20,
              top: 100 - scale * 25,
              bottom: 50,
            ),
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(
                  3,
                  2,
                  0.001,
                )
                ..rotateY(angle),
              alignment: Alignment.center,
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: CachedNetworkImage(
                        imageUrl: _list[index].coverUrl,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        alignment:
                            Alignment((pageOffset! - index).abs() * 0.5, 0),
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        cacheManager: cacheManager,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
