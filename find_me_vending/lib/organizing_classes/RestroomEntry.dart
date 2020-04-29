import 'package:flutter/material.dart';
import 'package:findmevending/organizing_classes/LocationEntry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const List<String> restroomStatuses = <String>["Mens", "Womens", "Private", "Nursing"];
const List<Color> restroomStatusesColors = [Color(0xFF87DFFC), Color(0xFFFFE2FF), Color(0xFFF2A365), Color(0xFFBE9FE1)];


class RestroomEntry extends Entry{
  var included = [];

  RestroomEntry(String id, double lat, double long, var image, String buildingCode, String loc, this.included) :
        super(id, 2, lat, long, image, buildingCode, loc);

  int createEntryDocument() {
    if (image is String) {
      while(included.length != restroomStatuses.length) {
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

RestroomEntry testRestroom =
RestroomEntry("IHzDSqK4kIFe5YWINX5U",
    26.306719, // + N, - S
    -98.174076, // + E, - W
    "https://firebasestorage.googleapis.com/v0/b/findmevending-seniorproject.appspot.com/o/IMG_20200323_184139536.jpg?alt=media&token=74881058-6492-4047-b86c-2c3702d35464",
    "ELIBR",
    "1st Floor of the Library, to the left of the elevators when coming through the entrance",
    [true, true, false, false] // mens, womens, private, nursing
);