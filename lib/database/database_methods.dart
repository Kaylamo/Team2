import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:GasTracker/globals.dart' as globals;



class DatabaseMethods {



 bool placeIsFavorited(placeId) {
    if (globals.favorites.contains(placeId)){
      return true;
    } else {
      return false;
    }
  }
  //add movie to users favorites
  addFavorite(placeId) async{

    String userId = globals.userId;
   /* Map<String, dynamic> favoritesMessageMap = {
      "placeId": placeId
    };   */
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("favorites")
        .doc(placeId).set({"placeId": placeId})
        .catchError((e) {
      print("ERROR ---" + e.toString());
    });
    globals.favorites.add(placeId);
    await updateFavoritesCount(userId, 1);
  }
  getFavorites() async {
    String userId = globals.userId;
    if(userId == null || userId == ""){
      return;
    }
    var collection =  FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("favorites");
    QuerySnapshot snapshot = await collection.get();
    List<String> placeIds = [];
    for(int i = 0; i < snapshot.docs.length; i++){
      placeIds.add(snapshot.docs[i].id.toString());
    }
    if(placeIds == null){
      globals.favorites =  [" "];
    } else {
      globals.favorites  = placeIds;
    }

  }
  getFavoritesCount(String uid) async {
    var count;
    var data;
    await FirebaseFirestore.instance.collection("users").doc(uid).get().then ((DocumentSnapshot ds){
      data = ds.data();
    });
    if(data != null){
      count = data["favoritesCount"];
    }
    if (count == null){
      count = "0";
    }
    globals.favoritesCount = count.toString();
  return count.toString();
}


  updateFavoritesCount(String uid, int change) async {
    var currCount = await getFavoritesCount(uid);
    int newCount = int.parse(currCount) + change;
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "favoritesCount": newCount.toString()
    });
    globals.favoritesCount = newCount.toString();
  }


    getJoinDate(String? uid) async {
       Timestamp? date;
       var data;
       await FirebaseFirestore.instance.collection("users").doc(uid).get().then ((DocumentSnapshot ds){
         data = ds.data();
       });
       if(data != null){
         date = data["registrationDatetime"];
       }
       var datetime;
       datetime = DateTime.fromMillisecondsSinceEpoch(date!.millisecondsSinceEpoch);

       var dateString = "${datetime.month} - ${datetime.day} - ${datetime.year}";
       return dateString;
    }

  getName(String? uid) async {
    var name = "";
    var data;
    await FirebaseFirestore.instance.collection("users").doc(uid).get().then ((DocumentSnapshot ds){
      data = ds.data();
    });
    if(data != null){
      name = data["userName"];
    }
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