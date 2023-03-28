import 'dart:convert';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:http/http.dart' as http;

Future<Map<String, GeoPoint>> getPharmacies(GeoPoint bounds) async {
  // Compute the bounding box from the center point
  final query = '''
      [out:json];
      node["amenity"="pharmacy"](around: 10000, ${bounds.latitude}, ${bounds.longitude});
      out;
    ''';
  // Send the query to the Overpass API
  String url =
      "https://overpass-api.de/api/interpreter?data=${Uri.encodeQueryComponent(query)}";
  final response = await http.get(Uri.parse(url));

  // Parse the response and extract the coordinates of the pharmacies
  Map<String, GeoPoint> foundLocations = {};
  dynamic data = json.decode(response.body);

  for (var element in data["elements"]) {
    if (element["tags"]["name"] == null) {
      continue;
    }
    double lat = element["lat"] ?? element["center"]["lat"];
    double lon = element["lon"] ?? element["center"]["lon"];
    foundLocations[element["tags"]["name"]] =
        GeoPoint(latitude: lat, longitude: lon);
  }
  return foundLocations;
}
