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


class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<Position>(context);
    final placesProvider =  Provider.of<Future<List<Place>?>>(context);
    final geoService = GeoLocatorService();
    final markerService = MarkerService();



    return FutureProvider (
      initialData: null,
      create: (context) => placesProvider,
      child: Scaffold(
        body: (currentPosition != null) ? Consumer<List<Place>?>(
          builder: (context, places, __) {
            List<Marker> emptyMarkers = [];
            var markers = (places != null) ? markerService.getMarkers(places) : emptyMarkers;
            return (places != null) ? Column(
              children: <Widget>[
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
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount:  places.length,
                      itemBuilder: (context, index) {

                        return FutureProvider(
                          initialData: 0.0,
                          create: (context) => geoService.getDistance(currentPosition.latitude, currentPosition.longitude, places[index].geometry!.location!.lat!,  places[index].geometry!.location!.lng!),
                          child: Card(
                            child: ListTile(
                              title: Text(
                               places[index].name!
                              ),
                              subtitle: Column( crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[
                                (places[index].rating != null) ? Row(children: <Widget>[
                                  SizedBox(height: 3,),
                                  RatingBarIndicator(
                                      rating: places[index].rating!,
                                      itemBuilder: (context, index) => Icon(Icons.star, color:Colors.amber),
                                      itemCount: 5,
                                      itemSize: 10,
                                      direction: Axis.horizontal,
                                  )
                              ]) : Row(),
                              SizedBox(height: 5,),
                              Consumer<double?>(
                                builder: (_, meters, __){
                                 return (meters != null) ? Text('${places[index].vicinity} \u00b7 ${(meters/1609).toStringAsFixed(2)} miles') : Container();

                                 }
                              ) // consumer
                              ], // widget
                              ),
                              trailing: IconButton(
                                iconSize: 30,
                                icon: Icon(Icons.directions),
                                color: Colors.redAccent,
                                onPressed: () {
                                  _launchMapsUrl(places[index].geometry!.location!.lat, places[index].geometry!.location!.lng);
                                },
                              ),
                            ),
                          ),
                        );

                      }),
                )
              ],
            ) : Center(child: CircularProgressIndicator() );
          },

        )
        : Center(child: CircularProgressIndicator(),),
      ),
    );
  }

  void _launchMapsUrl(double? lat, double? lng) async {
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}