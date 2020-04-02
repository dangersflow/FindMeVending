import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  String uid;
  String name;
  int points;
  List favorites;
  DocumentReference doc;
  FirebaseUser user;

  User({this.uid, this.name, this.points, this.favorites, this.doc, this.user}) {
    if(doc != null) {
      processDoc();
    }
  }

  Future<void> processDoc() async{
    if(doc == null) {
      return;
    }

    DocumentSnapshot snap = await doc.get();
    this.favorites = snap.data['favorites'];
    this.uid = snap.data['uid'];
    this.points = snap.data['points'];
    this.name = snap.data['name'];
  }
}

User testUser = User(uid: "0000001", name: "Test", points: 0, favorites:[1, 4]);