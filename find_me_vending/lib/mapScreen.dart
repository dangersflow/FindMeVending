import 'package:flutter/material.dart';
import 'package:findmevending/MainCard.dart';
import 'package:findmevending/custom_icons_icons.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:findmevending/loginSignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:map_markers/map_markers.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:user_location/user_location.dart';
import 'package:latlong/latlong.dart';

class MapScreen extends StatefulWidget {
  MapScreen({this.key});

  PageStorageKey key;
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // ADD THIS
  MapController mapController = MapController();
  UserLocationOptions userLocationOptions;
  // ADD THIS
  List<Marker> markers = [];
  @override
  Widget build(BuildContext context) {
    userLocationOptions = UserLocationOptions(
      context: context,
      mapController: mapController,
      markers: markers,
      updateMapLocationOnPositionChange: false
    );

    return FlutterMap(
      options: new MapOptions(
        center: new LatLng(26.306167, -98.173148),
        zoom: 13.0,
        plugins: [
          UserLocationPlugin(),
        ]
      ),
      layers: [
        new TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
        ),
        new MarkerLayerOptions(
          markers: [
            new Marker(
              width: 80.0,
              height: 80.0,
              point: new LatLng(26.306167, -98.173148),
              builder: (ctx) =>
              new BubbleMarker(
                bubbleColor: Colors.black,
              ),
            ),
          ],
        ),
        MarkerLayerOptions(markers: markers),
        userLocationOptions,
      ],
      mapController: mapController,
    );
  }
}
