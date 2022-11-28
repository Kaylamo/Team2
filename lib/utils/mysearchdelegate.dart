import 'package:flutter/material.dart';
import 'package:GasTracker/userVariables.dart';

class MySearchDelegate extends SearchDelegate{
  @override

  List<String> searchResults = [];



  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        if (query.isEmpty){
          close(context, null);
        } else {
          query = '';
        }
        },
    ),
  ];

  @override
  Widget buildResults(BuildContext context) => Center (
    child: Text( query, style: const TextStyle(fontSize: 64)),
  );

  @override
  Widget buildSuggestions(BuildContext context) {
    UserVariables.places.forEach((place) => searchResults.add(place.name));
    List<String> suggestions = searchResults.where((searchResult){
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();
    return ListView.builder(itemCount: suggestions.length,itemBuilder: (context, index) {

      final suggestion = suggestions[index];
      return ListTile(title: Text(suggestion), onTap:(){query = suggestion; showResults(context);},);
    },
    );
  }
}