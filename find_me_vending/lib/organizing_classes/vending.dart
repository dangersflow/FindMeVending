import 'package:findmevending/organizing_classes/location_entry.dart';

class VendingEntry extends Entry{
  var included = [];
  var status = [];
  
  VendingEntry(String id, int type, double lat, double long, String imageUrl, String buildingCode, String loc, this.included, this.status) : super(id, type, lat, long, imageUrl, buildingCode, loc);
}

VendingEntry testVending =
  VendingEntry("7I5F9r3tgGWn6kWx9CTV",
      1,
      26.306, // + N, - S
      -98.173, // + E, - W
      "gs://findmevending-seniorproject.appspot.com/IMG_20200321_194707709.jpg",
      "EACSB",
      "Outside the building entrance facing the library",
      ["0OR7XjIB2Qb6b7NXxdiH", "7X1g0VSrP5jEeTm1PQ9p", "Su8xIJ8PnV2AKgauJnxn", "Xg74xZwcZeCIaiZclhhM", "XjnczgaC55YofmGE0Rk3", "mm5JbJwarDBehZqbrAWS"],
      [false, false]
  );