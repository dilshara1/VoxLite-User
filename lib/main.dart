import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voxliteapp/Screens/details.dart';
import 'package:voxliteapp/Screens/home.dart';
import 'Screens/intro.dart';
import 'Screens/profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'controllers/auth_controller.dart';
import 'firebase_options.dart';

const String squareApplicationId = "sandbox-sq0idb-rrvupvGBQSIicjAWA_ckAg";
const String squareLocationId = "LP7WYFBM0PTEC";
Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    Get.put(AuthController());
  } catch (e) {
    print(e);
  }

  final fcmToken = await FirebaseMessaging.instance.getToken();
  print('Token here- $fcmToken');

 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: IntroPage(),
    );
  }
}

