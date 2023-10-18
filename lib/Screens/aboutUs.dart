import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../colors.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
        backgroundColor: kc1,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'About Us',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: kc3,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: kc3,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            Image.asset(
              'assets/dafault-background.jpg',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: kc1.withOpacity(0.7),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40 * fem),
                    Container(
                      width: 269 * fem,
                      height: 210 * fem,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/main/images/intro.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 40 * fem),
                    Text(
                      'Welcome to VoxLite Cinema',
                      style: TextStyle(
                        color: kc3,
                        fontFamily: 'Poppins',
                        fontSize: 24 * ffem,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 20 * fem),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20 * fem),
                      child: Text(
                        'At VoxLite Cinema, we are dedicated to providing our patrons with the ultimate movie-going experience. Our state-of-the-art facilities and friendly staff ensure that every visit to our cinema is a memorable one. We believe that movies are more than just entertainment – they are a way to connect with others, experience new worlds, and explore different perspectives. Come join us for an unforgettable cinematic experience!',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: kc3,
                          fontFamily: 'Poppins',
                          fontSize: 16 * ffem,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 40 * fem),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
