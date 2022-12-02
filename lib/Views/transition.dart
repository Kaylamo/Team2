import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sizer/sizer.dart';
import '/utils/constants.dart';
import 'homeScreen.dart';
import "package:provider/provider.dart";
import '/services/geolocator_service.dart';
import 'package:GasTracker/models/place.dart';
import 'package:GasTracker/services/places_service.dart';
import 'allowLocationsScreen.dart';
//this page sets up the initial home page after loggin in

class TransitionPage extends StatefulWidget {
  @override
  _TransitionPageState createState() => _TransitionPageState();
}

class _TransitionPageState extends State<TransitionPage> {
  final locatorService = GeoLocatorService();
  final placesService = PlacesService();

  Position? currentPosition;

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  void getCurrentLocation() async {
    currentPosition = await locatorService.determinePosition();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider(
            initialData: null,
            create: (context) => locatorService.determinePosition()),
        ProxyProvider<Position, Future<List<Place>?>>(
          update: (context, position, places) {
            return placesService.getPlaces(
                position.latitude, position.longitude);
          },
        ),
      ],
      child: MaterialApp(
        title: 'Gas Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: (currentPosition == null)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : HomePage(),
      ),
    );
  }

/*Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Gas Tracker',
        theme: ThemeData.dark().copyWith(
          platform: TargetPlatform.iOS,
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: kPrimaryColor,
        ),
        home: HomePage(),
      );
  }*/

}
