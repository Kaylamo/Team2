import 'package:GasTracker/models/user.dart';
import 'package:flutter/material.dart';
import 'package:GasTracker/utils/scroll_top_with_controller.dart' as scrollTop;
import 'package:GasTracker/Views/gasStationDetails.dart';
import 'package:GasTracker/widgets/appbar_widget.dart';
import 'package:GasTracker/widgets/profile_widget.dart';
import 'edit_profile_page.dart';
import 'package:GasTracker/widgets/numbers_widget.dart';
import 'package:GasTracker/uservariables.dart';
import 'package:GasTracker/views/homeScreen.dart';
import 'package:GasTracker/utils/transition_variables.dart';
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
import 'package:GasTracker/uservariables.dart';
import 'package:GasTracker/database/database_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:GasTracker/globals.dart' as globals;
import 'package:GasTracker/Views/profile_page_new.dart';


class FavoritesScreen extends StatefulWidget {
  final Color themeColor;

  FavoritesScreen({required this.themeColor});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  //for scroll uppingl;
  late ScrollController _scrollController;

  bool showBackToTopButton = false;

  bool showLoadingScreen = false;

  Future<void> loadData(String movieName) async {
    setState(() {
      scrollTop.scrollToTop(_scrollController);
    });
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
      print("ERROR --- " + e.toString());
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
    String name = UserVariables.myName;
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          showBackToTopButton = (_scrollController.offset >= 200);
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
                  var markers = (places != null)
                      ? markerService.getMarkers(places)
                      : emptyMarkers;
                  return (places != null)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  icon: Icon(Icons.map),
                                  iconSize: 28,
                                  onPressed: () => navi.newScreen(
                                    context: context,
                                    newScreen: () => HomePage(),
                                  ),
                                ),
                                SizedBox(width: 20,),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "Favorited Stations",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Expanded(
                              child: (globals.favorites.length == 0)
                                  ? Text("No Favorites Found")
                                  : ListView.builder(
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
                                          child: (DatabaseMethods()
                                                  .placeIsFavorited(
                                                      places[index].placeId))
                                              ? Card(
                                                  child: ListTile(
                                                    title: Text(
                                                        places[index].name!),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        (places[index].rating !=
                                                                0.0)
                                                            ? Row(children: <
                                                                Widget>[
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
                                                        Consumer<double?>(
                                                            builder: (_, meters,
                                                                __) {
                                                          return (meters !=
                                                                  null)
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
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10),
                                                          iconSize: 27,
                                                          icon: Icon(Icons
                                                              .info_outline),
                                                          color:
                                                              Colors.redAccent,
                                                          onPressed: () =>
                                                              navi.newScreen(
                                                            context: context,
                                                            newScreen: () =>
                                                                DetailsScreen(
                                                              place:
                                                                  places[index],
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
                                                          color:
                                                              Colors.redAccent,
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
                                                          color:
                                                              Colors.redAccent,
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
                                                )
                                              : SizedBox(
                                                  height: 0,
                                                ),
                                        );
                                      }),
                            )
                          ],
                        )
                      : Center(child: CircularProgressIndicator());
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
