import 'package:flutter/cupertino.dart';
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
    _auth.signInWithEmailAndPassword(email: email, password: password)
        .then((AuthResult auth) {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => MyHomePage(auth: _auth, user: auth.user)),
          );
        }).catchError((e) {
      Navigator.pop(context);
      showDialog(context: context,
          builder: (BuildContext context) =>
              AlertDialog(content: Text("Incorrect Password")));
      return;
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    Container loginScreen;

    TextField username = TextField(controller: _uname, style: TextStyle(fontFamily: 'Poppins'), decoration: InputDecoration(labelText: "Email"), keyboardType: TextInputType.emailAddress,);
    TextField password = TextField(controller: _pword, style: TextStyle(fontFamily: 'Poppins'), decoration: InputDecoration(labelText: "Password"), obscureText: true,);

    RaisedButton login = RaisedButton(
        child: Text("LOG IN", style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 18)),
        color: Color(0xFF98BCBF),
        onPressed: (){ _handleSignIn(context, _uname.text.toString(), _pword.text.toString()); }
        );

    loginScreen = Container(
      child: Column(
          children: [Align(child: Text("Email", style: TextStyle(fontSize: 27)), alignment: Alignment.topLeft,), username, Spacer(), Align(child: Text("Password", style: TextStyle(fontSize: 27)), alignment: Alignment.topLeft,), password, Spacer(), Align(child: login, alignment: Alignment.topRight,), Spacer(flex: 15)],
      ),
      padding: EdgeInsets.all(20),
    );

    return Scaffold(
        appBar:
          AppBar(
            title: Text("Log In", style: TextStyle(fontSize: 27, color: Colors.white)),
            iconTheme: IconThemeData(color: Colors.white),
          ),
        body: loginScreen);
  }
}