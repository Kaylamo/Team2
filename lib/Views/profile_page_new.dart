
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:GasTracker/models/user.dart';
import 'edit_profile_page_new.dart';
import 'package:GasTracker/widgets/appbar_widget.dart';
import 'package:GasTracker/widgets/button_widget.dart';
import 'package:GasTracker/widgets/numbers_widget.dart';
import 'package:GasTracker/widgets/profile_widget.dart';
import 'package:GasTracker/views/homeScreen.dart';
import 'package:GasTracker/utils/transition_variables.dart';
import 'favoritesScreen.dart';
import 'package:GasTracker/database/database_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:GasTracker/globals.dart' as globals;
import 'package:GasTracker/Views/edit_profile_page.dart';


class ProfilePageNew extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageNew> {
  @override
  Widget build(BuildContext context) {

    String name = globals.myName;
    String email = globals.myEmail;
    String imagePath = globals.imagePath;
    String about = globals.about;
    String joinDate = globals.joinDate;

    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: imagePath,
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          buildName(name),
          const SizedBox(height: 24),
          Center(child: buildEditProfile()),
          const SizedBox(height: 24),
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
          const SizedBox(height: 48),
          buildEmail(email),
          const SizedBox(height: 40),
          buildGasType(about),
          const SizedBox(height: 40),
          buildJoinDate(joinDate),
        ],
      ),
    );
  }

  Widget buildName(name) => Column(
    children: [
      Text(
        name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      const SizedBox(height: 4),
    ],
  );

  Widget buildEditProfile() => ButtonWidget(
    text: 'Edit Profile',
    onClicked: () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => EditProfilePage()),
      );
    },
  );

  Widget buildEmail(email) => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          email,
          style: TextStyle(fontSize: 20, height: 1.4),
        ),
      ],
    ),
  );

  Widget buildGasType(gasType) => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gas Type',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          gasType,
          style: TextStyle(fontSize: 20, height: 1.4),
        ),
      ],
    ),
  );
  Widget buildJoinDate(date) => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Joined Date',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          date,
          style: TextStyle(fontSize: 20, height: 1.4),
        ),
      ],
    ),
  );
}

