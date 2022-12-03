import 'package:flutter/material.dart';
import 'package:GasTracker/userVariables.dart';
import 'package:GasTracker/models/place.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:GasTracker/database/database_methods.dart';
import 'navi.dart' as navi;
import 'package:GasTracker/Views/gasStationDetails.dart';

class MySearchDelegate extends SearchDelegate {
  @override
  List<Place> searchResults = [];

  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
        ),
      ];

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Text(query, style: const TextStyle(fontSize: 64)),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    UserVariables.places.forEach((place) => searchResults.add(place));
    List<Place> suggestions = searchResults.where((searchResult) {
      final result = searchResult.name!.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toSet().toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        //return ListTile(title: Text(suggestion.name!), onTap:(){query = suggestion.name!; showResults(context);},);

        return Card(
          child: ListTile(
            title: Text(suggestion.name!),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                (suggestion.rating != null)
                    ? Row(children: <Widget>[
                        SizedBox(
                          height: 3,
                        ),
                        RatingBarIndicator(
                          rating: suggestion.rating!,
                          itemBuilder: (context, index) =>
                              Icon(Icons.star, color: Colors.amber),
                          itemCount: 5,
                          itemSize: 10,
                          direction: Axis.horizontal,
                        )
                      ])
                    : Row(),
                SizedBox(
                  height: 5,
                ),
            Text(
              '${suggestion.vicinity}'),
               // consumer
              ], // widget
            ),
            trailing: Wrap(
              spacing: 12,
              children: <Widget>[
                IconButton(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  iconSize: 27,
                  icon: Icon(Icons.info_outline),
                  color: Colors.redAccent,
                  onPressed: () => navi.newScreen(
                    context: context,
                    newScreen: () =>
                        DetailsScreen(
                          place: suggestion,
                        ),
                  ),
                ),
                IconButton(
                  iconSize: 30,
                  icon: (DatabaseMethods().placeIsFavorited(suggestion.placeId))
                      ? Icon(Icons.star)
                      : Icon(Icons.star_border),
                  color: Colors.redAccent,
                  onPressed: () async {
                  },
                ),
                IconButton(
                  iconSize: 30,
                  icon: Icon(Icons.directions),
                  color: Colors.redAccent,
                  onPressed: () {
                    _launchMapsUrl(suggestion.geometry!.location!.lat,
                        suggestion.geometry!.location!.lng);
                  },
                ),
              ],
            ),
          ),
        );
      },
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
