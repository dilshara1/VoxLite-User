import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colors.dart';

class ForgetPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      backgroundColor: kc1,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 70 * fem),
            Text(
              'Reset Your Password',
              style: GoogleFonts.poppins(
                fontSize: 24 * ffem,
                fontWeight: FontWeight.w600,
                color: kc3,
              ),
            ),
            Text(
              'Get back in to your account',
              style: GoogleFonts.poppins(
                fontSize: 16 * ffem,
                fontWeight: FontWeight.w600,
                color: kc3,
              ),
            ),
            SizedBox(height: 40 * fem),
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
                  prefixIcon: Icon(Icons.email, color: Colors.white),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20 * fem),
            ElevatedButton(
              onPressed: () {},
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
              child: Text('Sent Reset Code'),
            ),
            SizedBox(height: 40 * fem),
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
                style: GoogleFonts.poppins(
                  fontSize: 14 * ffem,
                  color: kc3,
                ),
                decoration: InputDecoration(
                  hintText: 'Reset code',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14 * ffem,
                    color: kc3.withOpacity(0.5),
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.white),
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
                  hintText: 'New Password',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14 * ffem,
                    color: kc3.withOpacity(0.5),
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.white),
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
                  hintText: 'Confirm New Password',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14 * ffem,
                    color: kc3.withOpacity(0.5),
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.white),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20 * fem),
            ElevatedButton(
              onPressed: () {},
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
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
