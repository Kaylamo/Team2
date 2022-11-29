import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:GasTracker/userVariables.dart';
import 'package:GasTracker/globals.dart' as globals;

class DatabaseMethods {

  getName(String? uid) async {
    var name = "";
    var data;
    await FirebaseFirestore.instance.collection("users").doc(uid).get().then ((DocumentSnapshot ds){
      data = ds.data();
    });
    if(data != null){
      name = data["userName"];
    }
    print("DATABSE GETNAME ------------------------------------------------ name = " + name);
    return name;
  }

  setName(String? uid, name) async {
    globals.myName = name;
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "userName": name
    });
  }

  getEmail(String? uid) async {
    var email = "";
    var data;
    await FirebaseFirestore.instance.collection("users").doc(uid).get().then ((DocumentSnapshot ds){
      data = ds.data();
    });
    if(data != null){
      email = data["userEmail"];
    }
    return email;
  }

  setEmail(String? uid, email) async {
    globals.myEmail = email;
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "email": email
    });
  }

  getAbout(String? uid) async {
    var about = "";
    var data;
    await FirebaseFirestore.instance.collection("users").doc(uid).get().then ((DocumentSnapshot ds){
      data = ds.data();
    });
    if(data != null){
      about = data["about"];
    }
    print("GOT ABOUT -- " + about);
    return about;
  }

  setAbout(String? uid, aboutText) async {
    globals.about = aboutText;
    print("SET ABOUT -----" + aboutText);

    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "about": aboutText
    });
  }

  getImagePath(String? uid) async {
    var email = "";
    var data;
    await FirebaseFirestore.instance.collection("users").doc(uid).get().then ((DocumentSnapshot ds){
      data = ds.data();
    });
    if(data != null){
      email = data["imagePath"];
    }
    return email;
  }

  setImagePath(String? uid, imagePath)  {
    globals.imagePath = imagePath;
    FirebaseFirestore.instance.collection("users").doc(uid).update({
      "imagePath": imagePath
    });
  }


}