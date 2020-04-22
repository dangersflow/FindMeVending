import 'package:findmevending/main.dart';
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
import 'package:findmevending/organizing_classes/LocationEntry.dart';
import 'package:findmevending/pinDetailsScreen.dart';

Map<int, Color> colorSelect = {
  0: const Color(0xFFF69D9D),
  1: const Color(0xFF9192FB),
  2: const Color(0xFF5AEF93),
  3: const Color(0xFF87DFFC)
};

Map<int, Color> darkColorSelect = {
  0: const Color(0xFFc16e6f),
  1: const Color(0xFF5e64c7),
  2: const Color(0xFF00bb64),
  3: const Color(0xFF52adc9)
};

//global vars
class MapScreen extends StatefulWidget {
  MapScreen({this.key, this.masterList, this.snacksSelected = true, this.drinksSelected = true, this.waterSelected = true, this.restroomSelected = true, this.searchQuery = ""});

  PageStorageKey key;
  List<Entry> masterList;

  //booleans
  bool drinksSelected;
  bool snacksSelected;
  bool waterSelected;
  bool restroomSelected;
  String searchQuery;
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  //searchQuery
  String searchQuery;
  //things needed for user location
  MapController mapController = MapController();
  UserLocationOptions userLocationOptions;

  //markers
  List<Marker> markers = [];

  //entry lists
  List<Entry> masterList = [];
  List<Entry> masterWorkingList = [];
  List<Entry> searchQueryList = [];

  //booleans
  bool drinksSelected = true;
  bool snacksSelected = true;
  bool waterSelected = true;
  bool restroomSelected = true;

  void modifyMapInfo({String searchQuery = ""}){
    List<Entry> newWorkingList = [];
    for(int i = 0; i < masterList.length; i++){
      if(searchQuery == ""){
        if(snacksSelected && masterList[i].type == 0)
          newWorkingList.add(masterList[i]);
        if(drinksSelected && masterList[i].type == 1)
          newWorkingList.add(masterList[i]);
        if(restroomSelected && masterList[i].type == 2)
          newWorkingList.add(masterList[i]);
        if(waterSelected && masterList[i].type == 3)
          newWorkingList.add(masterList[i]);
      }
      else{
        if(masterList[i].toStr() is String){
          String items = masterList[i].toStr();
          if(items.contains(RegExp(searchQuery))){
            print("Found item!");
            newWorkingList.add(masterList[i]);
          }
        }
      }
    }

    setState(() {
      masterWorkingList = newWorkingList;
      addMarkersFromList();
    });
  }

  void addMarkersFromList(){
    List<Marker> newMarkerList = [];
    for(int i = 0; i < masterWorkingList.length; i++){
      newMarkerList.add(masterWorkingList[i].marker);
    }

    setState(() {
      markers = newMarkerList;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchQuery = widget.searchQuery;
    snacksSelected = widget.snacksSelected;
    drinksSelected = widget.drinksSelected;
    restroomSelected = widget.restroomSelected;
    waterSelected = widget.waterSelected;

    masterList = widget.masterList;
    masterWorkingList = widget.masterList;
    //add every marker in the master list to the markers list
    modifyMapInfo(searchQuery: searchQuery);
    addMarkersFromList();

    print(markers.length);
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
                      modifyMapInfo();
                    });
                  },
                  elevation: drinksSelected ? 5 : 0,
                  selected: drinksSelected,
                  selectedColor: colorSelect[1],
                  disabledColor: Colors.black54,
                  labelStyle: TextStyle(color: Colors.black, fontFamily: "Poppins"),
                  shape: StadiumBorder(side: BorderSide(color: drinksSelected ? darkColorSelect[1] : Colors.grey)),
              ),
              ChoiceChip(
                label: Text("Snacks"),
                onSelected: (bool value) {
                  setState(() {
                    snacksSelected = !snacksSelected;
                    modifyMapInfo();
                  });
                },
                elevation: snacksSelected ? 5 : 0,
                selected: snacksSelected,
                selectedColor: colorSelect[0],
                disabledColor: Colors.black54,
                labelStyle: TextStyle(color: Colors.black, fontFamily: "Poppins"),
                shape: StadiumBorder(side: BorderSide(color: snacksSelected ? darkColorSelect[0] : Colors.grey)),
              ),
              ChoiceChip(
                label: Text("Water"),
                onSelected: (bool value) {
                  setState(() {
                    waterSelected = !waterSelected;
                    modifyMapInfo();
                  });
                },
                elevation: waterSelected ? 5 : 0,
                selected: waterSelected,
                selectedColor: colorSelect[3],
                disabledColor: Colors.black54,
                labelStyle: TextStyle(color: Colors.black, fontFamily: "Poppins"),
                shape: StadiumBorder(side: BorderSide(color: waterSelected ? darkColorSelect[3] : Colors.grey)),
              ),
              ChoiceChip(
                label: Text("Restroom"),
                onSelected: (bool value) {
                  setState(() {
                    restroomSelected = !restroomSelected;
                    modifyMapInfo();
                  });
                },
                elevation: restroomSelected ? 5 : 0,
                selected: restroomSelected,
                selectedColor: colorSelect[2],
                disabledColor: Colors.black54,
                labelStyle: TextStyle(color: Colors.black, fontFamily: "Poppins"),
                shape: StadiumBorder(side: BorderSide(color: restroomSelected ? darkColorSelect[2] : Colors.grey)),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Container(
            child: FlutterMap(
              options: new MapOptions(
                  center: new LatLng(26.306167, -98.173148),
                  zoom: 15.0,
                  maxZoom: 18.0,
                  plugins: [
                    UserLocationPlugin(),
                  ],
              ),
              layers: [
                new TileLayerOptions(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                new MarkerLayerOptions(
                  markers: markers,
                ),
                userLocationOptions,
              ],
              mapController: mapController,
            ),
            height: 300,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: masterWorkingList.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(masterWorkingList[index].buildingCode),
                      leading: Column(
                        children: <Widget>[
                          CircleAvatar(backgroundColor: colorSelect[masterWorkingList[index].type], child: Text(masterWorkingList[index].buildingCode[0], style: TextStyle(color: Colors.white, fontSize: 20,),),),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      subtitle: Column(
                        children: <Widget>[
                          Text(masterWorkingList[index].loc),
                          Row(
                            children: <Widget>[
                              Container(
                                child: Container(child: Icon(Icons.keyboard_arrow_up, color: Colors.black54)),
                                height: 25,
                                width: 25,
                                alignment: Alignment.centerLeft,
                              ),
                              Text("+4", style: TextStyle(color: Colors.black),),
                              Container(
                                child: Container(child: Icon(Icons.keyboard_arrow_down, color: Colors.black54)),
                                height: 25,
                                width: 25,
                                alignment: Alignment.centerLeft,
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.start,
                          )
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      onTap: (){
                        //mapController.move(LatLng(masterWorkingList[index].lat, masterWorkingList[index].long), 18);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PinDetailsScreen(masterWorkingList[index])));
                      },
                      trailing: Column(
                        children: <Widget>[
                          Icon(CustomIcons.heart_filled)
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                    Divider(color: Colors.black54, endIndent: 15, indent: 15,)
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
