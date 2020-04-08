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
  MapScreen({this.key, this.markers});

  PageStorageKey key;
  List<Marker> markers;
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  //things needed for user location
  MapController mapController = MapController();
  UserLocationOptions userLocationOptions;
  List<Marker> markers = [];

  //booleans
  bool drinksSelected = false;
  bool snacksSelected = false;
  bool waterSelected = false;
  bool restroomSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    markers = widget.markers;
  }
  @override
  Widget build(BuildContext context) {
    userLocationOptions = UserLocationOptions(
      context: context,
      mapController: mapController,
      markers: markers,
      updateMapLocationOnPositionChange: false,
      //since it'll be mostly used at school, this could be convenient
      zoomToCurrentLocationOnLoad: false,
    );

    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              ChoiceChip(
                  label: Text("Drinks"),
                  onSelected: (bool value) {
                    setState(() {
                      drinksSelected = !drinksSelected;
                    });
                  },
                  elevation: drinksSelected ? 5 : 0,
                  selected: drinksSelected,
                  selectedColor: Color(0xFFFFBB97),
                  labelStyle: TextStyle(color: Colors.black, fontFamily: "Poppins"),
                  backgroundColor: Colors.transparent,
                  shape: StadiumBorder(side: BorderSide(color: drinksSelected ? Color(0xFFF57C00) : Colors.grey)),
              ),
              ChoiceChip(
                label: Text("Snacks"),
                onSelected: (bool value) {
                  setState(() {
                    snacksSelected = !snacksSelected;
                  });
                },
                elevation: snacksSelected ? 5 : 0,
                selected: snacksSelected,
                selectedColor: Color(0xFFFFBB97),
                labelStyle: TextStyle(color: Colors.black, fontFamily: "Poppins"),
                backgroundColor: Colors.transparent,
                shape: StadiumBorder(side: BorderSide(color: snacksSelected ? Color(0xFFF57C00) : Colors.grey)),
              ),
              ChoiceChip(
                label: Text("Water"),
                onSelected: (bool value) {
                  setState(() {
                    waterSelected = !waterSelected;
                  });
                },
                elevation: waterSelected ? 5 : 0,
                selected: waterSelected,
                selectedColor: Color(0xFFFFBB97),
                labelStyle: TextStyle(color: Colors.black, fontFamily: "Poppins"),
                backgroundColor: Colors.transparent,
                shape: StadiumBorder(side: BorderSide(color: waterSelected ? Color(0xFFF57C00) : Colors.grey)),
              ),
              ChoiceChip(
                label: Text("Restroom"),
                onSelected: (bool value) {
                  setState(() {
                    restroomSelected = !restroomSelected;
                  });
                },
                elevation: restroomSelected ? 5 : 0,
                selected: restroomSelected,
                selectedColor: Color(0xFFFFBB97),
                labelStyle: TextStyle(color: Colors.black, fontFamily: "Poppins"),
                backgroundColor: Colors.transparent,
                shape: StadiumBorder(side: BorderSide(color: restroomSelected ? Color(0xFFF57C00) : Colors.grey)),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Container(
            child: FlutterMap(
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
                  markers: markers
                ),
                MarkerLayerOptions(markers: markers),
                userLocationOptions,
              ],
              mapController: mapController,
            ),
            height: 300,
          )
        ],
      ),
    );
  }
}
