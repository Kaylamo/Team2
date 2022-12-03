import 'package:GasTracker/models/geometry.dart';
import 'package:GasTracker/globals.dart' as globals;

class Place{
  final String? name;
  final double? rating;
  final int? userRatingCount;
  final String? vicinity;
  final Geometry? geometry;
  final String? placeId;
  bool? favorited;
  final String? ratingCount;
  final String? website;

  Place({this.geometry, this.name, this.rating, this.userRatingCount, this.vicinity, this.placeId, this.favorited, this.ratingCount, this.website});

  Place.fromJson(Map<dynamic, dynamic> parsedJson)
      :name = parsedJson['name'],
        rating = (parsedJson['rating'] !=null) ? parsedJson['rating'].toDouble() : 0.0,
        userRatingCount = (parsedJson['user_ratings_total'] != null) ? parsedJson['user_ratings_total'] : null,
        vicinity = parsedJson['vicinity'],
        geometry = Geometry.fromJson(parsedJson['geometry']),
        placeId = parsedJson['place_id'],
        favorited = (globals.favorites.contains(parsedJson['placeId'])) ? true : false,
        ratingCount = (parsedJson['user_ratings_total'] == null) ? "0" : parsedJson['user_ratings_total'].toString(),
        website = (parsedJson['website'] == null) ? "No Website" : parsedJson['website'].toString();

}