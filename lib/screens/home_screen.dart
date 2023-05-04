import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
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
  final List productNames = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    mapController = MapController(
      initMapWithUserPosition: true,
    );

    final db = firestore.FirebaseFirestore.instance;
    db.collection("products").get().then((products) {
      productNames.addAll(products.docs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PharmacyFinder"),
        actions: [
          IconButton(
            onPressed: () async {
              GeoPoint centerMap = await mapController.centerMap;

              final newPoints = await getPharmacies(centerMap);
              await mapController.removeMarkers(points);
              points.clear();
              points.addAll(newPoints.values);
              for (final point in points) {
                mapController.addMarker(
                  point,
                  markerIcon: const MarkerIcon(
                    icon: Icon(
                      Icons.local_pharmacy,
                      color: Colors.red,
                    ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          OSMFlutter(
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
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: GridView.builder(
                itemCount: productNames.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            productNames[index]['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(productNames[index]['name']),
                        SizedBox(height: 6),
                        Text(productNames[index]['price']),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Column(
              children: [
                Row(
                  children: const [
                    Text("Name:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 15),
                    Text("Test Name"),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: const [
                    Text("Email:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 15),
                    Text("test@test.com"),
                  ],
                ),
              ],
            )),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "Products"),
          BottomNavigationBarItem(
              icon: Icon(Icons.switch_account), label: "Profile"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.my_location),
        onPressed: () async {
          await mapController.currentLocation();
        },
      ),
    );
  }
}
