import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../colors.dart';
import 'forget.dart';
import 'home.dart';
import 'signup.dart';
import 'package:voxliteapp/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import provider package
import 'package:lottie/lottie.dart';
class LoginPage extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
        backgroundColor: kc1,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10 * fem),
              
                Container(
                  
                  padding: EdgeInsets.all(20),
                  child: 
               Lottie.asset('assets/lottiejson/AAAA.json'), 
/*  Lottie.network( 
                'https://assets5.lottiefiles.com/packages/lf20_cbrbre30.json'), */


                ),  Text(
                  'Hello',
                  style: GoogleFonts.poppins(
                    fontSize: 40 * ffem,
                    fontWeight: FontWeight.w700,
                    color: kc3,
                  ),
                ),
                SizedBox(height: 5 * fem),
                Text(
                  'Sign into your account',
                  style: GoogleFonts.poppins(
                    fontSize: 18 * ffem,
                    fontWeight: FontWeight.w400,
                    color: kc3,
                  ),
                ), SizedBox(height:20 * fem),

              //  SizedBox(height: 40 * fem),
                /* Container(
                  margin: EdgeInsets.symmetric(horizontal: 20 * fem),
                  padding: EdgeInsets.symmetric(horizontal: 10 * fem),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: kc2,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8 * fem),
                  ),
                  child: TextFormField(
                    style: GoogleFonts.poppins(
                      fontSize: 14 * ffem,
                      color: kc3,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14 * ffem,
                        color: kc3.withOpacity(0.5),
                      ),
                      prefixIcon: const Icon(Icons.email, color: Colors.white),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20 * fem),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20 * fem),
                  padding: EdgeInsets.symmetric(horizontal: 10 * fem),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: kc2,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8 * fem),
                  ),
                  child: TextFormField(
                    obscureText: true,
                    style: GoogleFonts.poppins(
                      fontSize: 14 * ffem,
                      color: kc3,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14 * ffem,
                        color: kc3.withOpacity(0.5),
                      ),
                      prefixIcon: const Icon(Icons.lock, color: Colors.white),
                      border: InputBorder.none,
                    ),
                  ),
                ), 
                SizedBox(height: 30 * fem),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 500),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    HomePage(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = Offset(1.0, 0.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            }));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8 * fem),
                    ),
                    primary: kc2,
                    textStyle: TextStyle(
                      color: kc3,
                      fontSize: 16 * ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.5 * ffem / fem,
                      letterSpacing: -0.12 * fem,
                    ),
                    minimumSize: Size(335 * fem, 48 * fem),
                  ),
                  child: const Text('Login'),
                ),*/
             //   SizedBox(height: 20 * fem),
                ElevatedButton(
               onPressed: () {
                    AuthController authController = AuthController();
                    authController.googleLogin(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8 * fem),
                    ),
                    primary: kc2,
                    textStyle: TextStyle(
                      color: kc3,
                      fontSize: 16 * ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.5 * ffem / fem,
                      letterSpacing: -0.12 * fem,
                    ),
                    fixedSize: Size(335 * fem, 48 * fem), // set fixedSize
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/lottiejson/google.json'), 
                        /* Image.asset(
                          'assets/Icons/google.png',
                        ) */
                        SizedBox(width: 16 * fem),
                        const Text('Google'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20 * fem),
                /* RichText(
                  text: TextSpan(
                    text: 'Forget Password? ',
                    style: GoogleFonts.poppins(
                      fontSize: 14 * ffem,
                      fontWeight: FontWeight.w400,
                      color: kc3,
                    ),
                    children: [
                      TextSpan(
                        text: ' Reset Now',
                        style: GoogleFonts.poppins(
                          fontSize: 14 * ffem,
                          fontWeight: FontWeight.w600,
                          color: kc2,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgetPasswordPage(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20 * fem),
                RichText(
                  text: TextSpan(
                    text: 'New User ? ',
                    style: GoogleFonts.poppins(
                      fontSize: 14 * ffem,
                      fontWeight: FontWeight.w400,
                      color: kc3,
                    ),
                    children: [
                      TextSpan(
                        text: ' Register Now',
                        style: GoogleFonts.poppins(
                          fontSize: 14 * ffem,
                          fontWeight: FontWeight.w600,
                          color: kc2,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => signup(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ), */
              ],
            ),
          ),
        ));
  }
}







































/* import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                child: Form(
              child: Container(
                child: Column(children: <Widget>[
                  TextFormField(
                    maxLength: 50,
                    decoration: InputDecoration(hintText: 'Email Address'),
                    validator: (text) {
                      if (text!.isEmpty) {
                        return 'Email must be Enter';
                      }
                      return null;
                      onSaved() {}
                    },
                  ),
                  TextFormField(
                    maxLength: 50,
                    decoration: InputDecoration(hintText: 'Password'),
                    validator: (text) {
                      if (text!.isEmpty) {
                        return 'Password cant Empty';
                      }
                      return null;
                      onSaved() {}
                    },
                  ),
                  Container(
                    child: ElevatedButton(
                      child: Text('Login'),
                      onPressed: () {
                        print('Login');
                      },
                    ),
                  )
                ]),
              ),
            ))
          ]),
    ));
  }
}
 */