import 'package:flutter/material.dart';

import 'package:GasTracker/utils/scroll_top_with_controller.dart'
as scrollTop;

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


class ProfileScreen extends StatefulWidget {
  final Color themeColor;

  ProfileScreen({required this.themeColor});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  //for scroll uppingl;
  late ScrollController _scrollController;
  bool showBackToTopButton = false;

  bool showLoadingScreen = false;


  @override
  void initState()  {
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
    String name = globals.myName;
    String email = globals.myEmail;
    String imagePath = globals.imagePath;
    String about = globals.about;
    print("BUILD PROFILE PAGE ------------------------------------------------------ NAME = " + name);
    if (about == "") {
      about = "Edit your profile to add a Bio";
    }


    return (name != "") ? Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: imagePath,
            onClicked: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
            },
          ),
          const SizedBox(height: 24),
          buildName(name, email),
          const SizedBox(height: 14),
          MaterialButton(
            padding: EdgeInsets.symmetric(vertical: 4),
            onPressed: () {
              TransitionVariables.index = 2;
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => FavoritesScreen(themeColor: Colors.redAccent,))
              );},
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  (globals.favoritesCount == "") ? "0" : globals.favoritesCount,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 2),
                Text(
                  "Favorites",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          buildAbout(about),
        ],
      ),
    ) : Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildName(name, email) => Column(
    children: [
      Text(
        name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      const SizedBox(height: 4),
      Text(
        email,
        style: TextStyle(color: Colors.grey),
      )
    ],
  );

  Widget buildAbout(about) => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          about,
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
      ],
    ),
  );
}