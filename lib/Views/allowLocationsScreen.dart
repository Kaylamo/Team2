import 'package:GasTracker/Views/gasStationDetails.dart';
import 'package:GasTracker/services/marker_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '/models/place.dart';
import '/services/geolocator_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:GasTracker/widgets/bottom_navigation_item.dart';
import 'package:GasTracker/utils/navi.dart' as navi;
import 'profileScreen.dart';
import 'favoritesScreen.dart';
import 'package:GasTracker/utils/mysearchdelegate.dart';
import 'package:GasTracker/userVariables.dart';
import 'package:GasTracker/database/database_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:GasTracker/globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:GasTracker/Views/profile_page_new.dart';

class AllowLocationScreen extends StatefulWidget {
  const AllowLocationScreen({Key? key}) : super(key: key);

  @override
  AllowLocationScreenState createState() => AllowLocationScreenState();
}

class AllowLocationScreenState extends State<AllowLocationScreen> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Text("Please Enable Location Services");
  }

  void _launchMapsUrl(double? lat, double? lng) async {
    final url =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
