import 'package:GasTracker/models/place.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PlacesService {
  final key = 'AIzaSyDhr2Mn1aIraVMCfeWk5bHPuUhhkvJtdj0';

  Future<List<Place>>? getPlaces(double lat, double lng) async {
    var response = await http.get(Uri.parse('https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&type=parking&rankby=distance&key=$key'));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    return jsonResults.map((place) => Place.fromJson(place)).toList();
  }

}