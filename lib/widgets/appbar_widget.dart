import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:gastracker/services/auth.dart';
import 'package:GasTracker/views/loginScreen.dart';
import 'package:restart_app/restart_app.dart';

AppBar buildAppBar(BuildContext context) {

  return AppBar(
    leading: BackButton( color: Colors.redAccent, ),
    foregroundColor: Colors.redAccent,
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      GestureDetector(
        onTap: ()  async {
          //await AuthService().signOut();
          Restart.restartApp();
        },
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.exit_to_app)),
      )
    ],
  );
}