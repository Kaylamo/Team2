import 'package:GasTracker/database/database_methods.dart';
import 'package:GasTracker/models/geometry.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:GasTracker/globals.dart' as globals;

class Place{
  final String? name;
  final double? rating;
  final int? userRatingCount;
  final String? vicinity;
  final Geometry? geometry;
  final String? placeId;
  bool? favorited;

  Place({this.geometry, this.name, this.rating, this.userRatingCount, this.vicinity, this.placeId, this.favorited});

  Place.fromJson(Map<dynamic, dynamic> parsedJson)
      :name = parsedJson['name'],
        rating = (parsedJson['rating'] !=null) ? parsedJson['rating'].toDouble() : null,
        userRatingCount = (parsedJson['user_ratings_total'] != null) ? parsedJson['user_ratings_total'] : null,
        vicinity = parsedJson['vicinity'],
        geometry = Geometry.fromJson(parsedJson['geometry']),
        placeId = parsedJson['place_id'],
        favorited = (globals.favorites.contains(parsedJson['placeId'])) ? true : false;


}