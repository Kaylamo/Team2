import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:GasTracker/models/user.dart';
import 'package:GasTracker/widgets/appbar_widget.dart';
import 'package:GasTracker/widgets/button_widget.dart';
import 'package:GasTracker/widgets/profile_widget.dart';
import 'package:GasTracker/widgets/textfield_widget.dart';
import 'package:path/path.dart';
//import 'package:GasTracker/database/database_methods.dart';
import 'package:GasTracker/uservariables.dart';
import "profileScreen.dart";
import 'package:firebase_storage/firebase_storage.dart';
import 'package:GasTracker/database/database_methods.dart';
import 'package:GasTracker/globals.dart' as globals;

class EditProfilePage extends StatefulWidget {
  @override

  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String name = "";
  String email = "";
  String imagePath = "";
  String about = "";
  String newAbout = "";
  File? _photo;

  FirebaseStorage storage = FirebaseStorage.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _aboutController = TextEditingController();
  @override
  void initState() {
    name =  globals.myName;
    email = globals.myEmail;
    imagePath = globals.imagePath;
    about = globals.about;
    super.initState();
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';
    print("fileName = " + fileName);
    print("destination = " + destination);

    try {
      final ref = storage
          .ref(destination)
          .child('file/');
      print("made ref");
      await ref.putFile(_photo!);
      final url = "https://firebasestorage.googleapis.com/v0/b/gas-tracker-93d2a.appspot.com/o/files%2F"+fileName+"%2Ffile?alt=media&token=725ac89e-e3ad-42e3-a6f6-db4e0df61422";
      print("starting set image path");
      await DatabaseMethods().setImagePath(globals.userId, url);
    } catch (e) {
      print('error occured   ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    about = globals.about;
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          ProfileWidget(
            imagePath: imagePath,
            isEdit: true,
            onClicked: () async {
              final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
              setState(() {
                if (pickedFile != null) {
                  _photo = File(pickedFile.path);
                  uploadFile();
                } else {
                  print('No image selected.');
                }
              });


              setState(() {

              });
            },
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            keyboardType: TextInputType.name,
            decoration:  InputDecoration(
              hintText: "Name: " + name,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email: " + email,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _aboutController,
            decoration: InputDecoration(
              hintText: "About: " + about,
            ),
          ),
          const SizedBox(height: 24),
          ButtonWidget(
            text: 'Save',
            onClicked: () async {
              //UserPreferences.setUser(user);
              print("SAVINGGGG ----"+ _aboutController.text);
              if (_nameController.text != ""){
                await DatabaseMethods().setName(globals.userId, _nameController.text);
              }
              if (_emailController.text != ""){
                await DatabaseMethods().setEmail(globals.userId, _emailController.text);
              }
              if (_aboutController.text != ""){
                await DatabaseMethods().setAbout(globals.userId, _aboutController.text);
              }
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProfileScreen(themeColor: Theme.of(context).colorScheme.primary)),
              );
            },
          ),
        ],
      ),
    );
  }
}