import 'package:flutter/material.dart';
import 'package:findmevending/organizing_classes/LocationEntry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const List<String> fountainStatuses = <String>["Water Refiller"];
const List<Color> fountainStatusesColors = [Color(0xFFB2DFFB)];


class WaterFountainEntry extends Entry{
  var included = [];

  WaterFountainEntry(String id, double lat, double long, var image, String buildingCode, String loc, this.included) :
    super(id, 3, lat, long, image, buildingCode, loc);

  int createEntryDocument() {
    if (image is String) {
      while(included.length != fountainStatuses.length) {
        included.add(false);
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
        "included": included
      });
      return 0;
    }
    else {
      return -1;
    }
  }
}

WaterFountainEntry testFountain =
WaterFountainEntry("QAFSLyzgl45YPPWhDZQd",
    26.305, // + N, - S
    -98.176, // + E, - W
    "https://firebasestorage.googleapis.com/v0/b/findmevending-seniorproject.appspot.com/o/IMG_20200323_185121555.jpg?alt=media&token=e7e6fe59-080c-48c0-8244-67eb068eb085",
    "Outside",
    "Along Bronc Trail, across from the ballroom",
    [true] // fountain_refiller
);


