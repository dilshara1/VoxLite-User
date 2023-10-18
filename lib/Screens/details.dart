import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxliteapp/Screens/login.dart';
import '../utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:cloud_firestore/src/collection_reference.dart';
import 'SelectDatePage.dart';
import 'home.dart';
import '../colors.dart';
import 'package:voxliteapp/models/movie.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'profile.dart';
import 'seactSel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palette_generator/palette_generator.dart';
//import 'package:flutter_native_screenshot/flutter_native_screenshot.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class DetailsPage extends StatefulWidget {
  final VacationBean vacationBean;

  DetailsPage({required this.vacationBean});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isLoading = true;
  bool isLoading2 = true;
  List<Color> myColors = [];

  @override
  void initState() {
    super.initState();
    _loadColors();
  }

  Future<void> _loadColors() async {
    setState(() {
      isLoading = true;
    });
    final colors = await getCachedImageColors(widget.vacationBean.coverUrl);
    setState(() {
      myColors = colors;
      isLoading = false;
    });
    print('My colors are $myColors');

    // Delay the appearance of the button by 500 milliseconds
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      isLoading2 = false;
    });
  }

  Future<List<Color>> getCachedImageColors(String imageUrl) async {
    final file = await DefaultCacheManager().getSingleFile(imageUrl);
    final imageProvider = FileImage(file);
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      imageProvider,
      maximumColorCount: 3, // Reduce the maximum color count
    );

    return paletteGenerator.colors.toList();
  }

  Widget build(BuildContext context) {
    final cacheManager = CacheManager(
      Config(
        'my_cache_key',
        stalePeriod: const Duration(days: 7),
        maxNrOfCacheObjects: 20,
      ),
    );

    String _backgroundImage = (widget.vacationBean.coverUrl);

    String movieID = widget.vacationBean.key;

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
            backgroundColor: Colors.transparent,
            title: const Text(
              'Overview',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: // Image.network(vacationBean.coverUrl),
                                CachedNetworkImage(
                              imageUrl: widget.vacationBean.coverUrl,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              cacheManager: cacheManager,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          widget.vacationBean.title,
                          style:  GoogleFonts.montserrat(
                              color: kc3,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              fontSize: 30,
                            ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          widget.vacationBean.description,
                           style:  GoogleFonts.montserrat(
                              color: kc3,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0,
                              fontSize: 16,
                            ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.timelapse_rounded,
                              color: kc3,
                              size: 30,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              '${DateFormat.jm().format(widget.vacationBean.showtime)}',
                              style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                color: kc3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.play_arrow,
                              color: kc3,
                              size: 30,
                            ),
                            Text(
                              ' ${DateFormat('yyyy-MM-dd').format(widget.vacationBean.startDate)}',
                              style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                color: kc3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.play_disabled_outlined,
                              color: kc3,
                              size: 30,
                            ),
                            Text(
                              '${DateFormat('yyyy-MM-dd').format(widget.vacationBean.endDate)}',
                              style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                color: kc3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: kc3,
                                  size: 30,
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  '${widget.vacationBean.rate}',
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    color: kc3,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            const SizedBox(width: 16.0),
                            Row(
                              children: [
                                const Icon(
                                  Icons.attach_money,
                                  color: kc3,
                                  size: 30,
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  '${widget.vacationBean.price}',
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    color: kc3,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 5.0, bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: myColors[2].withOpacity(0.3),
                              blurRadius: 10.0,
                              spreadRadius: 4.0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            if (isLoading2)
                              const CircularProgressIndicator()
                            else if (myColors.isNotEmpty)
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SelectDatePage(
                                          movieID: movieID,
                                          backimg: _backgroundImage),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  primary: myColors[0],
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                    letterSpacing: -1.5,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14.0,
                                    horizontal: 63.0,
                                  ),
                                ),
                                child: Text(
                                  'BOOK MY SEAT',
                                  style:  GoogleFonts.montserrat(
                              color: kc3,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              fontSize: 20,
                            ),
                                  
                                  
                                  /* TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.0,
                                    height: 1.7,
                                    letterSpacing: 0,
                                  ), */
                                ),
                              ),
                          ],
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
