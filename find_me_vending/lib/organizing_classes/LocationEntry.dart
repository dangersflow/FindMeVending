import 'dart:async';

import 'package:findmevending/organizing_classes/VendingEntry.dart';
import 'package:findmevending/organizing_classes/FountainEntry.dart';
import 'package:findmevending/organizing_classes/RestroomEntry.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmevending/organizing_classes/ItemEntry.dart';

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
  var image;
  String buildingCode;
  String loc;
  String id;
  Marker marker;

  Entry(this.id, this.type, this.lat, this.long, this.image, this.buildingCode, this.loc){
    marker = new Marker(
      height: 100.0,
      width: 120.0,
      point: new LatLng(lat, long),
      builder: (ctx) =>
          Icon(Icons.location_on,
              color: colorSelect[type])
    );
  }

  dynamic toStr(){
    return false;
  }

  int createEntryDocument() {
    print("WRONG ONE YOU DINGUS");
    return -1;
  }
}

class EntryList extends ChangeNotifier {
  final List<Entry> _entries = [];
  bool downloaded = false;

  void add(Entry entry) {
    _entries.add(entry);
    notifyListeners();
  }

  void removeAll() {
    _entries.clear();
    notifyListeners();
  }

  Entry at(int index){
    return _entries[index];
  }

  List<Entry> get() {
    return _entries;
  }

  void reopen() {
    downloaded = false;
  }

  Future<void> downloadAllEntryDocuments() async {
    if(!downloaded) {
      downloaded = true;
      _entries.clear();
      Stream<QuerySnapshot> collectSnap = Firestore.instance.collection(
          'locations').snapshots();
      StreamSubscription collectSub = collectSnap.listen(null);
      collectSub.onData((query) {
        List<DocumentSnapshot> docs = query.documents;
        for (int i = 0; i < docs.length; i++) {
          DocumentSnapshot doc = docs[i];
          switch (doc.data["type"]) {
            case 0:
            case 1:
              List<Item> items = <Item>[];
              Stream<QuerySnapshot> itemsSnap = Firestore.instance.collection(
                  'locations').document(doc.documentID)
                  .collection('items')
                  .snapshots();
              StreamSubscription itemSub = itemsSnap.listen(null);
              DateTime end = DateTime.now().add(Duration(seconds: 1));
              itemSub.onData((itemQuery) {
                for (int j = 0; j < itemQuery.documents.length &&
                    DateTime.now().isBefore(end); j++) {
                  DocumentSnapshot itemDoc = itemQuery.documents[j];
                  items.add(Item(itemDoc.documentID, itemDoc.data["name"],
                      itemDoc.data["low_stock"]));
                }
              });
              itemSub.onError((err) {
                print("error: $err");
                itemSub.cancel();
              });
              itemSub.onDone(() {
                print("done");
                itemSub.cancel();
              });
              add(VendingEntry(
                  doc.documentID,
                  doc.data["type"],
                  doc.data["loc"].latitude,
                  doc.data["loc"].longitude,
                  doc.data["image_url"],
                  doc.data["building_code"],
                  doc.data["location_description"],
                  items,
                  doc.data["status"]));
              notifyListeners();
              break;
            case 2:
              add(RestroomEntry(
                  doc.documentID,
                  doc.data["loc"].latitude,
                  doc.data["loc"].longitude,
                  doc.data["image_url"],
                  doc.data["building_code"],
                  doc.data["location_description"],
                  doc.data["included"]));
              notifyListeners();
              break;
            case 3:
              add(WaterFountainEntry(
                  doc.documentID,
                  doc.data["loc"].latitude,
                  doc.data["loc"].longitude,
                  doc.data["image_url"],
                  doc.data["building_code"],
                  doc.data["location_description"],
                  doc.data["included"]));
              notifyListeners();
              break;
          }
        }
        collectSub.cancel();
      });
      collectSub.onError((err) {
        print("error: $err");
        collectSub.cancel();
      });
      collectSub.onDone(() {
        print("done");
        collectSub.cancel();
      });
    }
  }
}

List<Entry> masterlistEntries = <Entry>[testVending, testFountain, testRestroom];
