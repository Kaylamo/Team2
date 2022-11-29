import 'package:GasTracker/services/marker_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '/models/place.dart';
import 'package:GasTracker/services/places_service.dart';
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  getUserInfo() async {
    print(
        "SETTING USER VARIABLES ------------------------------------------------");
    DatabaseMethods databaseMethods = new DatabaseMethods();
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      UserVariables.myName = await databaseMethods.getName(user.uid);
      UserVariables.myEmail = await databaseMethods.getEmail(user.uid);
      UserVariables.imagePath = await databaseMethods.getImagePath(user.uid);
      UserVariables.about = await databaseMethods.getAbout(user.uid);
      UserVariables.userId = user.uid;

      globals.myName = await databaseMethods.getName(user.uid);
      globals.myEmail = await databaseMethods.getEmail(user.uid);
      globals.imagePath = await databaseMethods.getImagePath(user.uid);
      globals.about = await databaseMethods.getAbout(user.uid);
      globals.userId = user.uid;
    }
    print("USER VARIABLES WERE SET ---------------------------" +
        UserVariables.myName);
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

    return FutureProvider(
      initialData: null,
      create: (context) => placesProvider,
      child: Scaffold(
        body: (currentPosition != null)
            ? Consumer<List<Place>?>(
                builder: (context, places, __) {
                  List<Marker> emptyMarkers = [];
                  UserVariables.places = places;
                  print(
                      "TEST ------------------------------------------------------------------ 2");
                  var markers = (places != null)
                      ? markerService.getMarkers(places)
                      : emptyMarkers;
                  return (places != null)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                BottomNavigationItem(
                                  icon: Icon(Icons.person),
                                  iconSize: 28,
                                  onPressed: () => navi.newScreen(
                                    context: context,
                                    newScreen: () => ProfileScreen(
                                      themeColor: Colors.red,
                                    ),
                                  ),
                                ),
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
                              ],
                            ),
                            /* BottomNavigationItem(
                              icon: Icon(Icons.person),
                              iconSize: 28,
                              onPressed: () => navi.newScreen(
                                context: context,
                                newScreen: () => ProfileScreen(
                                  themeColor: Colors.red,
                                ),
                              ),
                            ),
                            BottomNavigationItem(
                              icon: Icon(Icons.star),
                              iconSize: 28,
                              onPressed: () => navi.newScreen(
                                context: context,
                                newScreen: () => FavoritesScreen(
                                  themeColor: Colors.red,
                                ),
                              ),
                            ),*/

                            Container(
                              height: MediaQuery.of(context).size.height / 2.5,
                              width: MediaQuery.of(context).size.width,
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                    target: LatLng(currentPosition.latitude,
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
                                          title: Text(places[index].name!),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              (places[index].rating != null)
                                                  ? Row(children: <Widget>[
                                                      SizedBox(
                                                        height: 3,
                                                      ),
                                                      RatingBarIndicator(
                                                        rating: places[index]
                                                            .rating!,
                                                        itemBuilder: (context,
                                                                index) =>
                                                            Icon(Icons.star,
                                                                color: Colors
                                                                    .amber),
                                                        itemCount: 5,
                                                        itemSize: 10,
                                                        direction:
                                                            Axis.horizontal,
                                                      )
                                                    ])
                                                  : Row(),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Consumer<double?>(
                                                  builder: (_, meters, __) {
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
                                                iconSize: 30,
                                                icon: Icon(Icons.star_border),
                                                color: Colors.redAccent,
                                                onPressed: () {
                                                },
                                              ),
                                              IconButton(
                                                iconSize: 30,
                                                icon: Icon(Icons.directions),
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
