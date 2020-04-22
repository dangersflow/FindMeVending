import 'package:findmevending/organizing_classes/LocationEntry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:user_location/user_location.dart';
import 'package:latlong/latlong.dart';
import 'package:findmevending/organizing_classes/VendingEntry.dart';
import 'package:findmevending/organizing_classes/FountainEntry.dart';
import 'package:findmevending/organizing_classes/RestroomEntry.dart';

class PinDetailsScreen extends StatefulWidget {
  Entry pin;
  PinDetailsScreen(this.pin);

  @override
  _PinDetailsScreenState createState() => _PinDetailsScreenState();
}

class _PinDetailsScreenState extends State<PinDetailsScreen> {
  MapController mapController = MapController();
  UserLocationOptions userLocationOptions;

  @override
  Widget build(BuildContext context) {
    userLocationOptions = UserLocationOptions(
      context: context,
      mapController: mapController,
      markers: [widget.pin.marker],
      updateMapLocationOnPositionChange: false,
      //since it'll be mostly used at school, this could be convenient
      zoomToCurrentLocationOnLoad: false,
    );

    AppBar appBar = AppBar(
      title: Text("Location Details", style: TextStyle(fontSize: 27, color: Colors.white)),
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 0,
    );
    Container colorBlock = Container(height: appBar.preferredSize.height, color: Color.fromRGBO(152,188,191, 1),);
    CircleAvatar colorCircle = CircleAvatar(
      backgroundColor: colorSelect[widget.pin.type],
      radius:(MediaQuery.of(context).size.width/6),
      backgroundImage: widget.pin.image is String?NetworkImage(widget.pin.image):FileImage(widget.pin.image),
    );
    Stack stack = Stack(overflow: Overflow.visible, children: <Widget>[Align(child: colorCircle, alignment: Alignment.center), colorBlock, Positioned(top: 10, left: (MediaQuery.of(context).size.width/3), child: colorCircle,)],);
    Widget name = Align(child: Text("${typeSelect[widget.pin.type]} at ${widget.pin.buildingCode}", style: TextStyle(fontFamily: "Poppins", fontSize: 27)), alignment: Alignment.center,);
    Widget loc = Container(padding: EdgeInsets.fromLTRB(25, 5, 25, 10), child: Align(child: Text("${widget.pin.loc}", style: TextStyle(fontFamily: "Poppins", fontSize: 16, color: Colors.grey[600])), alignment: Alignment.center,));
    Container map = Container(color: Colors.red, height: (MediaQuery.of(context).size.height/3), width: (MediaQuery.of(context).size.width),
      child: FlutterMap(
        options: new MapOptions(
            center: new LatLng(widget.pin.lat, widget.pin.long),
            zoom: 18.0,
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
              markers: [widget.pin.marker]
          ),
          userLocationOptions,
        ],
        mapController: mapController,
      ),
    );
    Container otherInfo = Container(child: Text("", style: TextStyle(fontSize: 1),));
    Widget chips;
    if (widget.pin.type == 0 || widget.pin.type == 1) {
      VendingEntry pinSubV = widget.pin;
      Widget itemsTitle = Align(
        child: Text("Containing", style: TextStyle(fontSize: 32),),
        alignment: Alignment.topLeft,);
      List<Widget> items = [itemsTitle];
      for (int i = 0; i < pinSubV.included.length; i++) {
        items.add( Container(width: ((MediaQuery.of(context).size.width / 16) * 15),
            padding: EdgeInsets.all(10),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[Text("${pinSubV.included[i].name}",
                style: TextStyle(fontFamily: "Poppins", fontSize: 16)),
              pinSubV.included[i].lowStock?Text("Low Stock", style: TextStyle(fontFamily: "Poppins", fontSize: 16, color: Colors.red)):Text("", style: TextStyle(fontSize: 1)),
            ]),
            color: Colors.grey[300]));
        items.add(SizedBox(height: 7));
      }

      List<Chip> chippies = [];
      for(int i = 0; i < vendingStatuses.length; i++) {
        if (pinSubV.status[i] == null || pinSubV.status[i] == false) {
          chippies.add(Chip(label: Text("${vendingStatuses[i]}", style: TextStyle(fontFamily: "Poppins", fontSize: 16, color: Colors.grey[700])), backgroundColor: Colors.grey[400],));
        }
        else {
          chippies.add(Chip(label: Text("${vendingStatuses[i]}", style: TextStyle(fontFamily: "Poppins", fontSize: 16)), backgroundColor: vendingStatusesColors[i],));
        }
        otherInfo = Container(padding: EdgeInsets.all(20), child: Column(children: items,));
        chips = Container(padding: EdgeInsets.all(20), child: Row(children:chippies, mainAxisAlignment: MainAxisAlignment.spaceEvenly,),);
      }
    }
    else if (widget.pin.type == 2) {
      RestroomEntry pinSubR = widget.pin;

      List<Chip> chippies = [];
      for(int i = 0; i < restroomStatuses.length; i++) {
        if (pinSubR.included[i] == null || pinSubR.included[i] == false) {
          chippies.add(Chip(label: Text("${restroomStatuses[i]}", style: TextStyle(fontFamily: "Poppins", fontSize: 16, color: Colors.grey[700])), backgroundColor: Colors.grey[400],));
        }
        else {
          chippies.add(Chip(label: Text("${restroomStatuses[i]}", style: TextStyle(fontFamily: "Poppins", fontSize: 16)), backgroundColor: restroomStatusesColors[i],));
        }
        chips = Container(padding: EdgeInsets.all(20), child: Row(children:chippies, mainAxisAlignment: MainAxisAlignment.spaceEvenly,),);
      }
    }
    else if (widget.pin.type == 3) {
      WaterFountainEntry pinSubW = widget.pin;

      List<Chip> chippies = [];
      for(int i = 0; i < fountainStatuses.length; i++) {
        if (pinSubW.included[i] == null || pinSubW.included[i] == false) {
          chippies.add(Chip(label: Text("${fountainStatuses[i]}", style: TextStyle(fontFamily: "Poppins", fontSize: 16, color: Colors.grey[700])), backgroundColor: Colors.grey[400]));
        }
        else {
          chippies.add(Chip(label: Text("${fountainStatuses[i]}", style: TextStyle(fontFamily: "Poppins", fontSize: 16)), backgroundColor: fountainStatusesColors[i],));
        }
        chips = Container(padding: EdgeInsets.all(20), child: Row(children:chippies, mainAxisAlignment: MainAxisAlignment.spaceEvenly,),);
      }
    }

    Column body = new Column(children: <Widget>[stack, Text("", style: TextStyle(fontSize: 20)), name, loc, chips, map, otherInfo],);
    return Scaffold(appBar: appBar,
      body: ListView(children: <Widget>[body],),
    );
  }
}
