import 'package:GasTracker/Views/gasStationDetails.dart';
import 'package:GasTracker/services/marker_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '/models/place.dart';
import '/services/geolocator_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:GasTracker/widgets/bottom_navigation_item.dart';
import 'package:GasTracker/utils/navi.dart' as navi;
import 'profileScreen.dart';
import 'favoritesScreen.dart';
import 'package:GasTracker/utils/mysearchdelegate.dart';
import 'package:GasTracker/userVariables.dart';
import 'package:GasTracker/database/database_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:GasTracker/globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:GasTracker/Views/profile_page_new.dart';
import 'settingsScreen.dart';
import 'aboutUs.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  getUserInfo() async {
    DatabaseMethods databaseMethods = new DatabaseMethods();
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      globals.userId = user.uid;
      databaseMethods.getFavorites();
      UserVariables.myName = await databaseMethods.getName(user.uid);
      UserVariables.myEmail = await databaseMethods.getEmail(user.uid);
      UserVariables.imagePath = await databaseMethods.getImagePath(user.uid);
      UserVariables.about = await databaseMethods.getAbout(user.uid);
      UserVariables.userId = user.uid;
      globals.myName = await databaseMethods.getName(user.uid);
      globals.myEmail = await databaseMethods.getEmail(user.uid);
      globals.imagePath = await databaseMethods.getImagePath(user.uid);
      globals.about = await databaseMethods.getAbout(user.uid);
      globals.joinDate = await databaseMethods.getJoinDate(user.uid);
      globals.favoritesCount =
          await databaseMethods.getFavoritesCount(user.uid);
      setState(() {});
    }
  }

  addFavorite(placeId) async {
    String userId = globals.userId;
    /* Map<String, dynamic> favoritesMessageMap = {
      "placeId": placeId
    };   */
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("favorites")
        .doc(placeId)
        .set({"placeId": placeId}).catchError((e) {
      print("ERROR - " + e.toString());
    });
    globals.favorites.add(placeId);
    await DatabaseMethods().updateFavoritesCount(userId, 1);
    setState(() {});
  }

  removeFavorite(placeId) async {
    String userId = globals.userId;
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("favorites")
        .doc(placeId)
        .delete();
    globals.favorites.remove(placeId);
    await DatabaseMethods().updateFavoritesCount(userId, -1);
    setState(() {});
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<Position>(context);
    final placesProvider = Provider.of<Future<List<Place>?>>(context);
    final geoService = GeoLocatorService();
    final markerService = MarkerService();

    return (currentPosition == null)
        ? Text("enable locations")
        : FutureProvider(
            initialData: null,
            create: (context) => placesProvider,
            child: Scaffold(
              body: (currentPosition != null)
                  ? Consumer<List<Place>?>(
                      builder: (context, places, __) {
                        List<Marker> emptyMarkers = [];
                        UserVariables.places = places;
                        var markers = (places != null)
                            ? markerService.getMarkers(places)
                            : emptyMarkers;
                        return (places != null)
                            ? Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
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
                                        icon: Icon(Icons.info),
                                        iconSize: 28,
                                        onPressed: () => navi.newScreen(
                                          context: context,
                                          newScreen: () => AboutUsPage(),
                                        ),
                                      ),
                                      const SizedBox(width: 25),
                                      const Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          "Gas Tracker",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.redAccent,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height /
                                        2.5,
                                    width: MediaQuery.of(context).size.width,
                                    child: GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                              currentPosition.latitude,
                                              currentPosition.longitude),
                                          zoom: 16.0),
                                      zoomGesturesEnabled: true,
                                      markers: Set<Marker>.of(markers),
                                    ),
                                  ),
                                  AppBar(
                                    foregroundColor: Colors.black,
                                    backgroundColor: Colors.white,
                                    title: const Text('Search'),
                                    actions: [
                                      IconButton(
                                        icon: const Icon(Icons.search),
                                        onPressed: () {
                                          showSearch(
                                            context: context,
                                            delegate: MySearchDelegate(),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                        itemCount: places.length,
                                        itemBuilder: (context, index) {
                                          return FutureProvider(
                                            initialData: 0.0,
                                            create: (context) =>
                                                geoService.getDistance(
                                                    currentPosition.latitude,
                                                    currentPosition.longitude,
                                                    places[index]
                                                        .geometry!
                                                        .location!
                                                        .lat!,
                                                    places[index]
                                                        .geometry!
                                                        .location!
                                                        .lng!),
                                            child: Card(
                                              child: ListTile(
                                                title:
                                                    Text(places[index].name!),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    (places[index].rating !=
                                                            0.0)
                                                        ? Row(
                                                            children: <Widget>[
                                                                SizedBox(
                                                                  height: 3,
                                                                ),
                                                                RatingBarIndicator(
                                                                  rating: places[
                                                                          index]
                                                                      .rating!,
                                                                  itemBuilder: (context,
                                                                          index) =>
                                                                      Icon(
                                                                          Icons
                                                                              .star,
                                                                          color:
                                                                              Colors.amber),
                                                                  itemCount: 5,
                                                                  itemSize: 10,
                                                                  direction: Axis
                                                                      .horizontal,
                                                                )
                                                              ])
                                                        : Row(),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Consumer<double?>(builder:
                                                        (_, meters, __) {
                                                      return (meters != null)
                                                          ? Text(
                                                              '${places[index].vicinity} \u00b7 ${(meters / 1609).toStringAsFixed(2)} miles')
                                                          : Container();
                                                    }) // consumer
                                                  ], // widget
                                                ),
                                                trailing: Wrap(
                                                  spacing: 12,
                                                  children: <Widget>[
                                                    IconButton(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      iconSize: 27,
                                                      icon: Icon(
                                                          Icons.info_outline),
                                                      color: Colors.redAccent,
                                                      onPressed: () =>
                                                          navi.newScreen(
                                                        context: context,
                                                        newScreen: () =>
                                                            DetailsScreen(
                                                          place: places[index],
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      iconSize: 30,
                                                      icon: (DatabaseMethods()
                                                              .placeIsFavorited(
                                                                  places[index]
                                                                      .placeId))
                                                          ? Icon(Icons.star)
                                                          : Icon(Icons
                                                              .star_border),
                                                      color: Colors.redAccent,
                                                      onPressed: () async {
                                                        if (DatabaseMethods()
                                                            .placeIsFavorited(
                                                                places[index]
                                                                    .placeId)) {
                                                          await removeFavorite(
                                                              places[index]
                                                                  .placeId);
                                                        } else {
                                                          await addFavorite(
                                                              places[index]
                                                                  .placeId);
                                                        }
                                                      },
                                                    ),
                                                    IconButton(
                                                      iconSize: 30,
                                                      icon: Icon(
                                                          Icons.directions),
                                                      color: Colors.redAccent,
                                                      onPressed: () {
                                                        _launchMapsUrl(
                                                            places[index]
                                                                .geometry!
                                                                .location!
                                                                .lat,
                                                            places[index]
                                                                .geometry!
                                                                .location!
                                                                .lng);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  )
                                ],
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          );
  }

  void _launchMapsUrl(double? lat, double? lng) async {
    final url =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
