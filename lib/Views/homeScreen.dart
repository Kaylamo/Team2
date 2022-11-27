import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '/models/place.dart';
import 'package:GasTracker/services/places_service.dart';
import '/services/geolocator_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';



class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<Position>(context);
    final placesProvider =  Provider.of<Future<List<Place>?>>(context);
    final geoService = GeoLocatorService();



    return FutureProvider (
      initialData: null,
      create: (context) => placesProvider,
      child: Scaffold(
        body: (currentPosition != null) ? Consumer<List<Place>?>(
          builder: (context, places, __) {
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
                          initialData: [],
                          create: (context) => geoService.getDistance(currentPosition.latitude, currentPosition.longitude, places[index].geometry!.location!.lat!,  places[index].geometry!.location!.lng!),

                          child: Card(
                            child: ListTile(
                              title: Text(
                               places[index].name!
                              ),
                              subtitle: Column(children: <Widget>[
                                (places[index].rating != null) ? Row(children: <Widget>[
                                  RatingBarIndicator(
                                      rating: places[index].rating!,
                                      itemBuilder: (context, index) => Icon(Icons.star, color:Colors.amber),
                                      itemCount: 5,
                                      itemSize: 10,
                                      direction: Axis.horizontal,
                                  )
                              ]) : Row(),
                              Consumer<double?>(
                                builder: (context, meters, widget){
                                  return (meters != null) ? Text('${places[index].vicinity} \u00b7 ${(meters/1609).round()} miles') : Container();
    }
                              )
                            ]),
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

}