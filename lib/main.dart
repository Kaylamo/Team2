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

//import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /*await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCvgFPhbcepHuCSRAnUVpJvCRT1gZG8bik",
      appId: "1:119620639374:android:f0020e2fde59122b06c7df",
      messagingSenderId: "119620639374",
      projectId: "-59b7e",
    ),
  );*/

  await initialization(null);
  FlutterNativeSplash.removeAfter(initialization);
  runApp(MyApp());
}

Future initialization(BuildContext? context) async {
await Future.delayed(Duration(seconds: 3));
}

class MyApp extends StatelessWidget {
  //const MyApp({Key? key}) : super(key: key);
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