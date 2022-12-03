import 'package:GasTracker/Views/Feedback.dart';
import 'package:GasTracker/Views/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '/models/place.dart';
import '/services/geolocator_service.dart';
import '/services/places_service.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCWkRATxvHxv64tqGuEljf5XBjWzMG0x80",
      appId: "1:201221229888:web:84481b4391a0650df83ea5",
      messagingSenderId: "201221229888",
      projectId: "gas-tracker-93d2a",
      storageBucket: "gas-tracker-93d2a.appspot.com"
    ),
  );

  await initialization(null);
  FlutterNativeSplash.removeAfter(initialization);
  runApp(MyApp());
}

Future initialization(BuildContext? context) async {
await Future.delayed(Duration(seconds: 3));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gas Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }









}