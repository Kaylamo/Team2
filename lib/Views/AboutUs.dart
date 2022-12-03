import 'package:flutter/material.dart';

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
        appBar: AppBar(
          backgroundColor: Colors.blue[800],
          title: Text("About US",style: TextStyle(fontSize: 18),),
        ),

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white70,
                    radius: 75,
                    backgroundImage: AssetImage("img/gastracker.png"),
                  ),
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
                ],
              ),
          //  Flex(direction: Axis.vertical),
            //  Container(),



        ),
      ),
    );
  }
}
