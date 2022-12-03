import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("FeedBack"),),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
               // width: MediaQuery.of(context).size.,
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white70,
                      radius: 75,
                      backgroundImage: AssetImage("img/gastracker.png"),
                    ),

                    Text('Did you find any issue in our application?',style: TextStyle(fontSize: 18)),
                    Container(
                      height: 20,
                    ),
                    GestureDetector(
                        onTap: () async {
                          String email = Uri.encodeComponent("siddukasam7@gmail.com");
                          String subject = Uri.encodeComponent("Issue in Gas Tracker App");
                          String body = Uri.encodeComponent("Hi! I'm (Your name)");
                          print(subject); //output: Hello%20Flutter
                          Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
                          if (await launchUrl(mail)) {
                          //email app opened
                          }else{
                          //email app is not opened
                          }
                        },
                        child: Row(
                          children: [
                            Text( "Email Us Here:",style: TextStyle(fontSize: 18),),
                            Text(" siddukasam7@gmail.com",style: TextStyle(fontSize: 18,color: Colors.blue,decoration: TextDecoration.underline),)
                          ],
                        )),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
