import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:GasTracker/globals.dart' as globals;



class DatabaseMethods {



 bool placeIsFavorited(placeId) {
    print("IS PLACE IN FAVORITES -------------- " + placeId);
    if (globals.favorites.contains(placeId)){
      print("PLACE IS IN FAOVRITES ---------------------------------------------------");
      return true;
    } else {
      return false;
    }
  }
  //add movie to users favorites
  addFavorite(placeId) async{

    String userId = globals.userId;
    print("adding favorites    userId= " + userId + "      placeId = " + placeId + "-------------------------------------------------");
   /* Map<String, dynamic> favoritesMessageMap = {
      "placeId": placeId
    };   */
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("favorites")
        .doc(placeId).set({"placeId": placeId})
        .catchError((e) {
      print("ERRORR ADDING FAVORITE --------------" + e.toString());
    });
    globals.favorites.add(placeId);
    print("Favorite added - ---------------------------- -- userId =" + userId);
    await updateFavoritesCount(userId, 1);
    print("count updated -------------------------------------------------");
  }
  getFavorites() async {
    print("getting favorites -------------------------------------------------");
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
      print("found favorites -------------------------------------------------");
      globals.favorites  = placeIds;
    }

  }
  getFavoritesCount(String uid) async {
    print("getting favorite count ------------------------------------------------- uid = " + uid);
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
    print("got favorites count ----------------          count = " + count.toString());
  return count.toString();
}


  updateFavoritesCount(String uid, int change) async {
    print("UPDATE FAVORITES 1----------------------- uid = " + uid);
    var currCount = await getFavoritesCount(uid);
    print("UPDATE FAVORITES 2----------------------- CURRECOUNT = " + currCount);
    int newCount = int.parse(currCount) + change;
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "favoritesCount": newCount.toString()
    });
    globals.favoritesCount = newCount.toString();
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