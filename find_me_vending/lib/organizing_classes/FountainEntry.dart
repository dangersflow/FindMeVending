import 'package:findmevending/organizing_classes/LocationEntry.dart';

const List<String> fountainStatuses = <String>["Water Refiller"];

class WaterFountainEntry extends Entry{
  var included = [];

  WaterFountainEntry(String id, double lat, double long, String imageUrl, String buildingCode, String loc, this.included) :
    super(id, 3, lat, long, imageUrl, buildingCode, loc);
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


