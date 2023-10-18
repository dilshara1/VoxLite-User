import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:voxliteapp/Screens/home.dart';
import 'package:voxliteapp/Screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxliteapp/Screens/profile.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  late final String name;
  late final String email;
  late final String photoUrl;

  late Rx<User?> _user;
  bool isLogging = false; // Corrected variable name
  User? get user => _user.value;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.authStateChanges());
    ever(_user, loginRedirect);
  }

  void loginRedirect(User? user) {
    // Added void keyword to function signature
    Timer(Duration(seconds: isLogging ? 0 : 2), () async {
      if (user == null) {
        isLogging = false; // Corrected variable name
        update();
        Get.offAll(() => LoginPage());
      } else {
        isLogging = true; // Corrected variable name
        update();

        // Save user details to Firebase
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': user.displayName,
          'email': user.email,
          'photoUrl': user.photoURL,

          // Add any other user details you want to save here
        });

        this.name = name;
        this.email = email;
        this.photoUrl = photoUrl;

        Get.offAll(
          () => HomePage(),
        );
      }
    });
  }
Future<void> signOut() async {
  await _auth.signOut();
  await _googleSignIn.signOut();
}
  Future<void> googleLogin(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Navigate to the Home screen
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ));
      }
    } catch (e) {
      print(e);
    }
  }

  /* Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  } */
}

void getErrorSnackBar(String message, error) {
  // Added void keyword and error parameter
  Get.snackbar(
    "Error",
    "$message\n${error.message}", // Added error message
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: const Color.fromARGB(255, 255, 0, 0),
    colorText: Colors.white,
    borderRadius: 10,
    margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
  );
}

void getErrorSnackBarNew(String message) {
  // Added void keyword
  Get.snackbar(
    "Error",
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: const Color.fromARGB(255, 255, 0, 0),
    colorText: Colors.white,
    borderRadius: 10,
  );
}



