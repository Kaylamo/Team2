import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_gas/model/user.dart';
import 'package:my_gas/page/edit_profile_page.dart';
import 'package:my_gas/utils/user_preferences.dart';
import 'package:my_gas/widget/appbar_widget.dart';
import 'package:my_gas/widget/button_widget.dart';
import 'package:my_gas/widget/numbers_widget.dart';
import 'package:my_gas/widget/profile_widget.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.myUser;

    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: user.imagePath,
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          buildName(user),
          const SizedBox(height: 24),
          Center(child: buildEditProfile()),
          const SizedBox(height: 24),
          NumbersWidget(),
          const SizedBox(height: 48),
          buildEmail(user),
          const SizedBox(height: 40),
          buildGasType(user),
          const SizedBox(height: 48),
          buildJoinDate(user),
        ],
      ),
    );
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.username,
            style: TextStyle(color: Colors.grey),
          )
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

  Widget buildEmail(User user) => Container(
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
              user.email,
              style: TextStyle(fontSize: 20, height: 1.4),
            ),
          ],
        ),
      );

  Widget buildGasType(User user) => Container(
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
              user.gastype,
              style: TextStyle(fontSize: 20, height: 1.4),
            ),
          ],
        ),
      );
  Widget buildJoinDate(User user) => Container(
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
              user.joindate,
              style: TextStyle(fontSize: 20, height: 1.4),
            ),
          ],
        ),
      );
}
