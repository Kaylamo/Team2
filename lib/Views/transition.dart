import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '/utils/constants.dart';
import 'homeScreen.dart';


class TransitionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sizer',
          theme: ThemeData.dark().copyWith(
            platform: TargetPlatform.iOS,
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: kPrimaryColor,
          ),
          home: HomePage(
            title: "GasTracker",
            //key: kHomeScreenKey,
          ),
        );
      },
    );

  }
}