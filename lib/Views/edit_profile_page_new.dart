

import 'dart:io';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:GasTracker/models/user.dart';
import 'package:GasTracker/widgets/appbar_widget.dart';
import 'package:GasTracker/widgets/button_widget.dart';
import 'package:GasTracker/widgets/profile_widget.dart';
import 'package:GasTracker/widgets/textfield_widget.dart';
import 'package:GasTracker/database/database_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:GasTracker/globals.dart' as globals;

class EditProfilePageNew extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePageNew> {
  String name = globals.myName;
  String email = globals.myEmail;
  String imagePath = globals.imagePath;
  String about = globals.about;
  String favoritesCount = globals.favoritesCount;
  String joinDate = globals.joinDate;

  @override
  Widget build(BuildContext context) => ThemeSwitchingArea(
    child: Builder(
      builder: (context) => Scaffold(
        appBar: buildAppBar(context),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 32),
          physics: BouncingScrollPhysics(),
          children: [
            ProfileWidget(
              imagePath: imagePath,
              isEdit: true,
              onClicked: () async {},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Full Name',
              text: name,
              onChanged: (name) {},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Email',
              text: email,
              onChanged: (email) {},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'GasType',
              text: about,
              maxLines: 1,
              onChanged: (about) {},
            ),
          ],
        ),
      ),
    ),
  );
}


