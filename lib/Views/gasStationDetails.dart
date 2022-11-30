import 'package:flutter/material.dart';

import 'package:GasTracker/utils/scroll_top_with_controller.dart' as scrollTop;

import 'package:GasTracker/widgets/appbar_widget.dart';
import 'package:GasTracker/widgets/profile_widget.dart';
import 'edit_profile_page.dart';
import 'package:GasTracker/widgets/numbers_widget.dart';
import 'package:GasTracker/uservariables.dart';
import 'package:GasTracker/views/homeScreen.dart';
import 'package:GasTracker/utils/transition_variables.dart';
import 'favoritesScreen.dart';
import 'package:GasTracker/database/database_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:GasTracker/globals.dart' as globals;
import "package:GasTracker/models/place.dart";
import "package:flutter_rating_bar/flutter_rating_bar.dart";


class DetailsScreen extends StatefulWidget {
  final Place place;

  DetailsScreen({required this.place});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  //for scroll uppingl;
  late ScrollController _scrollController;

  bool showBackToTopButton = false;

  bool showLoadingScreen = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          showBackToTopButton = (_scrollController.offset >= 200);
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.place.name!;
    double rating = widget.place.rating!;
    String vicinity = widget.place.vicinity!;

    print(
        "BUILD PROFILE PAGE ------------------------------------------------------ NAME = " +
            name);

    return (name != "")
        ? Scaffold(
            appBar: buildAppBar(context),
            body: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 24),
                buildName(name, vicinity),
                const SizedBox(height: 14),
                buildRating(rating),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget buildName(name, address) => Column(
        children: [
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
          ),
          const SizedBox(height: 4),
          Text(
            address,
            style: TextStyle(color: Colors.grey, fontSize: 15),
          )
        ],
      );

  Widget buildRating(rating) => Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        SizedBox(
          height: 3,
        ),
        RatingBarIndicator(
          rating: rating,
          itemBuilder: (context, index) =>
              Icon(Icons.star, color: Colors.amber),
          itemCount: 5,
          itemSize: 40,
          direction: Axis.horizontal,
        )
      ]);
}
