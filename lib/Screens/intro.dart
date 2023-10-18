import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../colors.dart';
import 'login.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  late VideoPlayerController _controller;
  bool _isPlaying = true; // set initial state to true

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/main/videos/intro.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setVolume(0.0); // Mute the sound
        if (_isPlaying) {
          // play video if _isPlaying is true
          _controller.play();
        }
      })
      ..setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
                //   color: Color.fromARGB(255, 11, 0, 105).withOpacity(0.7),
                ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome to the',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 16 * ffem,
                    fontWeight: FontWeight.w400,
                    height: 1.5 * ffem / fem,
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 20 * fem),
                  child: Text(
                    'VoXLite Cinema App!',
                    style: TextStyle(
                      color: kc3,
                      fontFamily: 'Poppins',
                      fontSize: 20 * ffem,
                      fontWeight: FontWeight.w700,
                      height: 1.5 * ffem / fem,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 40 * fem),
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


                
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 500),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    LoginPage(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = const Offset(1.0, 0.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            }
                            )
                            );
                  },

            
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8 * fem),
                    ),
                    primary: kc2,
                    textStyle: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 18 * ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.5 * ffem / fem,
                      letterSpacing: -1.5 *
                          ffem /
                          fem, // add negative letter spacing to reduce space between letters
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 14 * fem,
                      horizontal: 63 * fem,
                    ),
                  ),
                  child: Text(
                    'Get Start',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 15 * ffem,
                      height: 1.7 * ffem / fem,
                      letterSpacing: 1 *
                          ffem /
                          fem, // add negative letter spacing to reduce space between letters
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}









