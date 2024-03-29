import 'package:flutter/material.dart';
import 'package:findmevending/organizing_classes/LocationEntry.dart';
import 'package:findmevending/organizing_classes/ItemEntry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const List<String> vendingStatuses = ["Out of Order", "Cash Only"];
const List<Color> vendingStatusesColors = [Color(0xFFF69D9D), Color(0xFF5AEF93)];

class VendingEntry extends Entry{
  List<Item> included = [];
  List<dynamic> status = [];
  
  VendingEntry(String id, int type, double lat, double long, var image, String buildingCode, String loc, this.included, this.status) : super(id, type, lat, long, image, buildingCode, loc);

  dynamic toStr(){
    String str = "";
    for(int i = 0; i < included.length; i++){
      str += included[i].name;
    }
    str = str.replaceAll(RegExp(r"([^\w])"), '');
    str = str.toLowerCase();

    return str;
  }

  int createEntryDocument() {
    if (image is String) {
      while(status.length != vendingStatuses.length) {
        status.add(false);
      }
      DocumentReference postRef = Firestore.instance.collection('locations')
          .document();
      postRef.setData({
        'building_code': buildingCode,
        "id": postRef.documentID,
        "image_url": image,
        "loc": GeoPoint(lat, long),
        "location_description": loc,
        "type": type,
        "status": status
      });
      for (int i = 0; i < included.length; i++) {
        Firestore.instance.collection('locations')
            .document('${postRef.documentID}').collection('items')
            .document().setData({
          "low_stock": included[i].lowStock,
          "name": included[i].name,
          "other_names": included[i].otherNames
        });
      }

      return 0;
    }
    else {
      return -1;
    }
  }
}

List<Item> items = [
  Item("3qlDNFJGwqapEUhtq5FB", "Sprite", false),
  Item("E02i1bO2T9JLSacygIqR", "Cherry Coke", true),
  Item("OotA0OI54Ek2Wlhr74wC", "Dr. Pepper", false),
  Item("dJyIkOfedJIdP4MjG7o5", "Coke Zero", true),
  Item("jYhtsnSeZr9lNcJgCJN1", "Coca-Cola", false),
];

VendingEntry testVending =
  VendingEntry("7I5F9r3tgGWn6kWx9CTV",
      1,
      26.306, // + N, - S
      -98.173, // + E, - W
      "gs://findmevending-seniorproject.appspot.com/IMG_20200321_194707709.jpg",
      "EACSB",
      "Outside the building entrance facing the library",
      items,
      [false, false] // out of order, cash only
  );