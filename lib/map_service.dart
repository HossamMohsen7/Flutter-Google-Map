import 'dart:convert';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:http/http.dart' as http;

Future<List<GeoPoint>> getPharmacies(GeoPoint bounds) async {
  // Compute the bounding box from the center point
  final query = '''
      [out:json];
      node["shop"="supermarket"](around: 1000, ${bounds.latitude}, ${bounds.longitude});
      out;
    ''';
  print(query);
  // Send the query to the Overpass API
  String url =
      "https://overpass-api.de/api/interpreter?data=${Uri.encodeQueryComponent(query)}";
  http.Response response = await http.get(Uri.parse(url));

  // Parse the response and extract the coordinates of the pharmacies
  List<GeoPoint> foundLocations = [];
  dynamic data = json.decode(response.body);
  for (var element in data["elements"]) {
    double lat = element["lat"] ?? element["center"]["lat"];
    double lon = element["lon"] ?? element["center"]["lon"];
    foundLocations.add(GeoPoint(latitude: lat, longitude: lon));
  }

  return foundLocations;
}
