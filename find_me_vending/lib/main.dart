import 'package:findmevending/NewPinScreen.dart';
import 'package:flutter/material.dart';
import 'package:findmevending/custom_icons_icons.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:findmevending/loginSignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:findmevending/homeScreen.dart';
import 'package:findmevending/profileScreen.dart';
import 'package:findmevending/mapScreen.dart';
import 'package:statusbar/statusbar.dart';
import 'package:findmevending/organizing_classes/UserEntry.dart';

//important variables
const String _appTitle = "FindMeVending";

//main material color
Map<int, Color> mainThemeColor =
{ 50:Color.fromRGBO(152,188,191, .1),
  100:Color.fromRGBO(152,188,191, .2),
  200:Color.fromRGBO(152,188,191, .3),
  300:Color.fromRGBO(152,188,191, .4),
  400:Color.fromRGBO(152,188,191, .5),
  500:Color.fromRGBO(152,188,191, .6),
  600:Color.fromRGBO(152,188,191, .7),
  700:Color.fromRGBO(152,188,191, .8),
  800:Color.fromRGBO(152,188,191, .9),
  900:Color.fromRGBO(152,188,191, 1),};

//material color to be used
MaterialColor mainColorSwatch = MaterialColor(0xFF98BCBF, mainThemeColor);

//main background color
Map<int, Color> mainBackgroundColor =
{ 50:Color.fromRGBO(236,236,236, .1),
  100:Color.fromRGBO(236,236,236, .2),
  200:Color.fromRGBO(236,236,236, .3),
  300:Color.fromRGBO(236,236,236, .4),
  400:Color.fromRGBO(236,236,236, .5),
  500:Color.fromRGBO(236,236,236, .6),
  600:Color.fromRGBO(236,236,236, .7),
  700:Color.fromRGBO(236,236,236, .8),
  800:Color.fromRGBO(236,236,236, .9),
  900:Color.fromRGBO(236,236,236, 1),};

//material color to be used
MaterialColor mainBackgroundSwatch = MaterialColor(0xFFECECEC, mainBackgroundColor);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appTitle,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: mainColorSwatch,
        fontFamily: 'Darker Grotesque',
      ),
      home: MyHomePage(title: _appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title = _appTitle, this.auth, this.user}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  FirebaseAuth auth;
  User user;

  void quickRefresh({User user, FirebaseAuth auth}) {
    user = user;
    auth = auth;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //stuff for bottom nav bar
  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StatusBar.color(Color(0xFF98BCBF));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(key: PageStorageKey("Page1"),),
    ProfileScreen(key: PageStorageKey("Page2"),),
    MapScreen(key: PageStorageKey("Page3"),)
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  void quickRefresh(){
    super.setState((){widget.quickRefresh();});
  }

  @override
  Widget build(BuildContext context) {
    if(widget.user != null) {
      if (widget.user.uid == "0000001" || widget.user.uid == null) {
       quickRefresh();
      }
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title, style: TextStyle(fontSize: 27),),
        leading: Builder(
          builder: (BuildContext context){
            return Container(child: IconButton(icon: Icon(Icons.menu, size: 27,), onPressed: () => Scaffold.of(context).openDrawer(),), padding: EdgeInsets.fromLTRB(0, 7, 0, 0),);
          },
        ),
        actions: <Widget>[
          Container(
            child: Icon(CustomIcons.heart_filled, size: 22,),
            padding: EdgeInsets.fromLTRB(0, 7, 20, 0),
          ),
          Container(
            child: Icon(Icons.search, size: 27,),
            padding: EdgeInsets.fromLTRB(0, 7, 20, 0),
          )
        ],
      ),
      body: PageStorage(
        child: _widgetOptions[_selectedIndex],
        bucket: bucket,

      ),
      //classic bottom nav bar :)
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 27,),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 27,),
            title: Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pin_drop, size: 27,),
            title: Text('Map'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
        backgroundColor: mainColorSwatch,

      ),
      backgroundColor: mainBackgroundSwatch,
      //cool drawer
      drawer: widget.auth==null?Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 130,
              //ListTile in the header is kinda wonked, will fix
              child: DrawerHeader(
                child: Container(child: ListTile(
                  title: Text("Guest", style: TextStyle(fontSize: 27),),
                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 15),)
                ),
                decoration: BoxDecoration(
                  color: mainColorSwatch,
                ),
              ),
            ),
            ListTile(
              leading: Icon(CustomIcons.sign_in_alt_solid, color: Colors.black,),
              title: Text("Log In", style: TextStyle(fontSize: 15, fontFamily: 'Poppins'),),
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));},
            ),
            ListTile(
              leading: Icon(CustomIcons.user_plus_solid, color: Colors.black,),
              title: Text("Register", style: TextStyle(fontSize: 15, fontFamily: 'Poppins'),),
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));},
            )
          ],
        ),
      ):
      Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 130,
              //ListTile in the header is kinda wonked, will fix
              child: DrawerHeader(
                child: Container(child: ListTile(
                  leading: IconButton(icon: Icon(Icons.arrow_back, size: 27, color: Colors.white,)),
                  // TODO: Fix name display, shows Template Message on first pass, but on moving to another page it updates to correct name. Something to do with futures
                  title: Text(widget.user == null || widget.user.name == null ? "Try again in a moment" : widget.user.name, style: TextStyle(fontSize: 27),),
                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 15),)
                ),
                decoration: BoxDecoration(
                  color: mainColorSwatch,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add, color: Colors.black,),
              title: Text("Make a Recommendation", style: TextStyle(fontSize: 15, fontFamily: 'Poppins'),),
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => NewPinScreen()));},
            ),
            ListTile(
              leading: Icon(Icons.pin_drop, color: Colors.black,),
              title: Text("Recommendations Map", style: TextStyle(fontSize: 15, fontFamily: 'Poppins'),),
              onTap: () => {},
            ),
            ListTile(
              leading: Icon(Icons.arrow_back, color: Colors.black,),
              title: Text("Log Out", style: TextStyle(fontSize: 15, fontFamily: 'Poppins'),),
              onTap: (){
                  widget.auth.signOut();
                  super.setState((){
                    widget.user = null;
                    widget.auth = null;
                  });
                },
            )
          ],
        ),
      ),
    );
  }
}
