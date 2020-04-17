import 'package:findmevending/organizing_classes/VendingEntry.dart';
import 'package:findmevending/organizing_classes/FountainEntry.dart';
import 'package:findmevending/organizing_classes/RestroomEntry.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:map_markers/map_markers.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter/material.dart';

Map<int, Color> colorSelect = {
  0: const Color(0xFFF69D9D),
  1: const Color(0xFF9192FB),
  2: const Color(0xFF5AEF93),
  3: const Color(0xFF87DFFC)
};

Map<int, String> typeSelect = {
  0: "Snack Vending",
  1: "Drink Vending",
  2: "Restroom",
  3: "Water Fountain",
};

class Entry {
  double lat;
  double long;
  int type; // 0 = food vending, 1 = drink vending, 2 = restroom, 3 = water fountain
  String imageUrl;
  String buildingCode;
  String loc;
  String id;
  Marker marker;

  Entry(this.id, this.type, this.lat, this.long, this.imageUrl, this.buildingCode, this.loc){
    marker = new Marker(
      height: 100.0,
      width: 120.0,
      point: new LatLng(lat, long),
      builder: (ctx) =>
      new BubbleMarker(
          bubbleColor: colorSelect[type],
          bubbleContentWidgetBuilder: (BuildContext context) {
            return Text(buildingCode);
          },
          widgetBuilder: (BuildContext context) {
            return Icon(Icons.location_on,
                color: colorSelect[type]);
          }
      ),
    );
  }
}

List<Entry> entries = <Entry>[testVending, testFountain, testRestroom];