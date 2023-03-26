import 'package:flutter/material.dart';
import 'package:flutter_app/map_service.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MapController mapController;
  final List<GeoPoint> points = [];

  @override
  void initState() {
    super.initState();
    mapController = MapController(
      initMapWithUserPosition: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OSMFlutter(
        controller: mapController,
        trackMyPosition: true,
        initZoom: 12,
        minZoomLevel: 8,
        stepZoom: 1.0,
        userLocationMarker: UserLocationMaker(
          personMarker: const MarkerIcon(
            icon: Icon(
              Icons.location_history_rounded,
              color: Colors.red,
              size: 48,
            ),
          ),
          directionArrowMarker: const MarkerIcon(
            icon: Icon(
              Icons.double_arrow,
              size: 48,
            ),
          ),
        ),
        roadConfiguration: const RoadOption(
          roadColor: Colors.yellowAccent,
        ),
        markerOption: MarkerOption(
            defaultMarker: const MarkerIcon(
          icon: Icon(
            Icons.person_pin_circle,
            color: Colors.blue,
            size: 56,
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.my_location),
        onPressed: () async {
          await mapController.currentLocation();
          GeoPoint centerMap = await mapController.centerMap;
          final newPoints = await getPharmacies(centerMap);
          await mapController.removeMarkers(points);
          points.clear();
          points.addAll(newPoints);
          newPoints.forEach((point) {
            mapController.addMarker(point);
          });
          print("hi");
          // mapController.centerMap.then((value) async {
          //   print(await getPharmacies(value));
          //   print("obaaaa");
          // });
        },
      ),
    );
  }
}
