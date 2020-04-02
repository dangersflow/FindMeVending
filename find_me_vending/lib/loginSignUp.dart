import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:findmevending/main.dart';
import 'package:findmevending/organizing_classes/user.dart';

Color textFieldColor = Colors.grey[350];

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> signOut() async{
  return _auth.signOut();
}

Future<void> _handleSignIn(var context, String email, String password) async {
  User user = testUser;
  _auth.signInWithEmailAndPassword(email: email, password: password)
      .then((AuthResult auth) async{
    DocumentReference postRef = Firestore.instance.collection('users').document(auth.user.uid);
    User user;
    user = User(doc: postRef);
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => MyHomePage(auth: _auth, user: user)),
    );
  }).catchError((e) {
    Navigator.pop(context);
    showDialog(context: context,
        builder: (BuildContext context) =>
            AlertDialog(content: Text("${e.message}")));
    return;
  }
  );
}

class LoginScreen extends StatelessWidget {
  TextEditingController _email = TextEditingController();
  TextEditingController _pword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Container loginScreen;

    TextField email = TextField(controller: _email, style: TextStyle(fontFamily: 'Poppins'), decoration: InputDecoration(fillColor: textFieldColor, filled: true), keyboardType: TextInputType.emailAddress,);
    TextField password = TextField(controller: _pword, style: TextStyle(fontFamily: 'Poppins'), decoration: InputDecoration(fillColor: textFieldColor, filled: true), obscureText: true,);

    RaisedButton login = RaisedButton(
        child: Text("LOG IN", style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 18)),
        color: Color(0xFF98BCBF),
        onPressed: (){ _handleSignIn(context, _email.text.toString(), _pword.text.toString()); }
        );

    loginScreen = Container(
      child: Column(
          children: [Align(child: Text("Email", style: TextStyle(fontSize: 27)), alignment: Alignment.topLeft,), email, Spacer(), Align(child: Text("Password", style: TextStyle(fontSize: 27)), alignment: Alignment.topLeft,), password, Spacer(), Align(child: login, alignment: Alignment.topRight,), Spacer(flex: 15)],
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

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _email = TextEditingController();
  TextEditingController _pword = TextEditingController();
  TextEditingController _pword2 = TextEditingController();
  TextEditingController _name = TextEditingController();

  Text emailNotification = Text("", style: TextStyle(fontSize: 1));
  Text passwordNotifcation = Text("", style: TextStyle(fontSize: 1));

  bool _pwordObscure = true;
  bool _pword2Obscure = true;

  void initState() {
    _email.addListener(() {
      String domain = _email.text.substring(_email.text.indexOf("@"));
      String dot_domain = domain.substring(domain.indexOf("."));

      if(dot_domain.compareTo(".edu") != 0) {
        super.setState((){});
        emailNotification = Text("Must be a .edu email!", style: TextStyle(color: Colors.red, fontFamily: "Poppins", fontSize: 18));
      }
      else {
        emailNotification = Text("Valid!", style: TextStyle(color: Colors.green, fontFamily: "Poppins", fontSize: 18));
        super.setState((){});
      }
    });
    _pword2.addListener(() {
      String password1 = _pword.text;
      String password2 = _pword2.text;
      if(password1.compareTo(password2) != 0) {
        passwordNotifcation = Text("Passwords don't match!", style: TextStyle(color: Colors.red, fontFamily: "Poppins", fontSize: 18));
        super.setState((){});
      }
      else {
        passwordNotifcation = Text("Valid!", style: TextStyle(color: Colors.green, fontFamily: "Poppins", fontSize: 18));
        super.setState((){});
      }
    });
    super.initState();
  }

  void passwordButtonPressed(int num) {
    if(num == 0) {
      super.setState((){ _pwordObscure = !_pwordObscure; });
    }
    else if(num == 1) {
      super.setState((){ _pword2Obscure = !_pword2Obscure; });
    }
  }

  Future<String> _createUser(String email, String password) async{
    FirebaseUser user = (await _auth.createUserWithEmailAndPassword(email: email, password: password)).user;
    await user.sendEmailVerification();
    return user.uid;
  }

  Future<void> _createUserDocument(String uid, String name) async{
    DocumentReference postRef = Firestore.instance.collection('users').document(uid);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        return;
      }
    });
    await Firestore.instance.collection('users').document(uid)
        .setData({ 'name': name, 'user_id': '$uid', 'favorites': [], 'points': 0 });
  }

  Future<bool> _newUser(var context, String email, String password, String password2, String name) async{
    AlertDialog dialog = new AlertDialog(
        content: new Text("Loading")
    );
    showDialog(context: context, builder: (BuildContext context) => dialog);
    if (password.compareTo(password2) != 0){
      Navigator.pop(context);
      AlertDialog dialog = new AlertDialog(
          content: new Text("Passwords do not match.")
      );
      showDialog(context: context, builder: (BuildContext context) => dialog);
      return false; // If our strings aren't the same, don't allow them to continue, return a message that passwords don't match.
    }
    else{
      String id = await _createUser(email, password);
      _createUserDocument(id, name);
      Navigator.pop(context);
      _handleSignIn(context, email, password);
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Container signupScreen;

    TextField email = TextField(controller: _email, style: TextStyle(fontFamily: 'Poppins'), decoration: InputDecoration(fillColor: textFieldColor, filled: true), keyboardType: TextInputType.emailAddress,);
    TextField name = TextField(controller: _name, style: TextStyle(fontFamily: 'Poppins'), decoration: InputDecoration(fillColor: textFieldColor, filled: true), keyboardType: TextInputType.text);
    TextField password = TextField(controller: _pword, style: TextStyle(fontFamily: 'Poppins'), decoration: InputDecoration(fillColor: textFieldColor, filled: true, suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye), onPressed: (){passwordButtonPressed(0);})), obscureText: _pwordObscure,);
    TextField password2 = TextField(controller: _pword2, style: TextStyle(fontFamily: 'Poppins'), decoration: InputDecoration(fillColor: textFieldColor, filled: true, suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye), onPressed: (){passwordButtonPressed(1);})), obscureText: _pword2Obscure,);

    RaisedButton signUp = RaisedButton(
        child: Text("REGISTER", style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 18)),
        color: Color(0xFF98BCBF),
        onPressed: (){_newUser(context, _email.text, _pword.text, _pword2.text, _name.text);}
    );

    signupScreen = Container(
      child: Column(
        children: [
          Align(child: Text("Email", style: TextStyle(fontSize: 27)), alignment: Alignment.topLeft,), Spacer(), email, Align(child: emailNotification, alignment: Alignment.topLeft,), Spacer(flex: 2),
          Align(child: Text("Password", style: TextStyle(fontSize: 27)), alignment: Alignment.topLeft,), Spacer(), password, Spacer(flex: 2),
          Align(child: Text("Confirm Password", style: TextStyle(fontSize: 27)), alignment: Alignment.topLeft,), Spacer(), password2, Align(child: passwordNotifcation, alignment: Alignment.topLeft,), Spacer(flex: 2),
          Align(child: Text("Name", style: TextStyle(fontSize: 27)), alignment: Alignment.topLeft,), Spacer(), name, Spacer(flex: 2),
          Align(child: signUp, alignment: Alignment.topRight,), Spacer(flex: 17)],
      ),
      padding: EdgeInsets.all(20),
    );

    return Scaffold(appBar:
        AppBar(
          title: Text("Register", style: TextStyle(fontSize: 27, color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: signupScreen);
  }
}
