import 'package:flutter/material.dart';
import 'package:GasTracker/widgets/bottom_navigation_item.dart';
import 'package:GasTracker/utils/navi.dart' as navi;
import 'package:GasTracker/Views/profile_page_new.dart';
import 'favoritesScreen.dart';
import "homeScreen.dart";
import 'package:GasTracker/widgets/button_widget.dart';
import 'package:GasTracker/Views/Feedback.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:GasTracker/globals.dart' as globals;

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      color: Colors.white,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Column(
              //  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      SizedBox(width: 2),
                      BottomNavigationItem(
                        icon: Icon(Icons.person),
                        iconSize: 28,
                        onPressed: () => navi.newScreen(
                          context: context,
                          newScreen: () => ProfilePageNew(),
                        ),
                      ),
                      SizedBox(width: 5),
                      BottomNavigationItem(
                        icon: Icon(Icons.star),
                        iconSize: 28,
                        onPressed: () => navi.newScreen(
                          context: context,
                          newScreen: () => FavoritesScreen(
                            themeColor: Colors.red,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      BottomNavigationItem(
                        icon: Icon(Icons.map),
                        iconSize: 28,
                        onPressed: () => navi.newScreen(
                          context: context,
                          newScreen: () => HomePage(),
                        ),
                      ),
                      const SizedBox(width: 25),
                      const Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "About Us",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      )
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white70,
                    radius: 115,
                    backgroundImage: AssetImage("img/gastracker.png"),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      // height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Center(
                          child: const Text("The founders of gas tracker have created this app to make drivers life easier to find the nearest gas station with the least gas price. Our users can use this app if they have a smart phone and wifi. "
                              "We want the users of this app to have a easy time accessing their nearest gas station. ",style: TextStyle(
                              height: 1.5,
                              fontSize: 23
                          ),),
                        ),
                    ),

                  ),
                  SizedBox(height: 40),
                  Center(
                    child: Container(
                      // height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Center(
                          child: const Text("App Design by: Sourabh Kasam, Jessica Haines, Kayla Moore, Alec Baker and Jonathan Cho",style: TextStyle(
                              height: 1.5,
                              fontSize: 14
                          ),),
                        )
                    ),
                  ),
                  SizedBox(height: 20),
                  ButtonWidget(
                    text: 'Send Feedback',
                    onClicked: () async {
                      String email = Uri.encodeComponent("siddukasam7@gmail.com");
                      String subject = Uri.encodeComponent("Issue in Gas Tracker App");
                      String body = Uri.encodeComponent("Hi! I'm " + globals.myName);
                      print(subject); //output: Hello%20Flutter
                      Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
                      if (await launchUrl(mail)) {
                      //email app opened
                      }else{
                      //email app is not opened
                      }
                    },
                  ),
                ],
              ),
          //  Flex(direction: Axis.vertical),
            //  Container(),



        ),
      ),
    );
  }
}
