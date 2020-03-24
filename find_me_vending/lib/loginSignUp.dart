import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:findmevending/main.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseUser user;
Future<void> signOut() async{
  return _auth.signOut();
}

class LoginScreen extends StatelessWidget {
  TextEditingController _uname = TextEditingController();
  TextEditingController _pword = TextEditingController();

  Future<void> _handleSignIn(var context, String email, String password) async {
    AlertDialog dialog = new AlertDialog(
        content: new Text("Loading...")
    );
    showDialog(context: context, builder: (BuildContext context) => dialog);
    _auth.signInWithEmailAndPassword(email: email, password: password);
//        .then((FirebaseUser user) {
//    }).catchError((e) {
//      Navigator.pop(context);
//      showDialog(context: context,
//          builder: (BuildContext context) =>
//              AlertDialog(content: Text("Incorrect Password")));
//      return;
//    }
//    );
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Container loginScreen;

    TextField username = TextField(controller: _uname, decoration: InputDecoration(labelText: "Email"), keyboardType: TextInputType.emailAddress,);
    TextField password = TextField(controller: _pword, decoration: InputDecoration(labelText: "Password"), obscureText: true,);

    RaisedButton login = RaisedButton(child: Text("Log In"), onPressed: (){ _handleSignIn(context, _uname.text.toString(), _pword.text.toString()); });

    loginScreen = Container(child: Column(children: [Text("Email"), username, Text("Password"), password, login]));

    return Scaffold(appBar: AppBar(title: Text("Log In")), body: loginScreen);
  }
}