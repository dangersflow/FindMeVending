import 'package:flutter/material.dart';
import 'package:findmevending/MainCard.dart';
import 'package:findmevending/custom_icons_icons.dart';
import 'package:flutter_icons/flutter_icons.dart';

//important variables

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

//map to select gradients based on type
Map<int, List<Color>> gradientSelect =
  {
    //snacks
    1: [const Color(0xFF9909C), const Color(0xFFF8B195)],
    //drinks
    2: [const Color(0xFF9192FB), const Color(0xFFEAC0FF)],
    //restrooms
    3: [const Color(0xFF5AEF93), const Color(0xFFDFF494)],
    //water bottle fillers
    4: [const Color(0xFF87DFFC), const Color(0xFFA9A9F6)]
  };

Map<int, Icon> iconSelect =
  {
    //snacks
    1: Icon(CustomIcons.snacks, size: 100,),
    //drinks
    2: Icon(CustomIcons.soda, size: 100,),
    //restrooms
    3: Icon(CustomIcons.restroom, size: 100,),
    //water bottle fillers
    4: Icon(CustomIcons.water, size: 100,)
  };

//testing stuff!
List<List<dynamic>> list = [
  ["Coke", 2],
  ["Doritos", 1],
  ["Restrooms", 3],
  ["Water", 4],
  ["Diet Coke", 2]
];

List<List<dynamic>> listTest = [
  ["Cherry Coke", 2],
  ["Cookies", 1],
  ["Water", 4],
  ["Hot Cheetos", 1],
  ["Coke", 2]
];

List<List<dynamic>> listTest2 = [
  ["Diet Coke", 2],
  ["Honey Bun", 1],
  ["Water", 4],
  ["Sprite", 2],
  ["Lay's", 2]
];

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FindMeVending',
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
      home: MyHomePage(title: 'FindMeVending'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //stuff for bottom nav bar
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            child: Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.

              // space between may not be that suitable (just a thought)
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //this is where the main cards are going to go
                //have 3 different card arrays for Near You, Recommended, and Trending?
                Text("Near You", style: TextStyle(fontSize: 30),),
                //this is just a test card, we'd probably want a gridview here for each main thing
                GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: list.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return MainCard(title: list[index][0], icon: iconSelect[list[index][1]], colorGradient: gradientSelect[list[index][1]],);
                    }
                    ),
                Container(
                  child: Divider(color: Colors.black, height: 50, ),
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                ),
                Text("Trending", style: TextStyle(fontSize: 30),),
                //cards
                GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: list.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return MainCard(title: listTest[index][0], icon: iconSelect[listTest[index][1]], colorGradient: gradientSelect[listTest[index][1]],);
                    }
                ),
                Container(
                  child: Divider(color: Colors.black, height: 50, ),
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                ),
                Text("Recommended", style: TextStyle(fontSize: 30),),
                //cards
                GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: list.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return MainCard(title: listTest2[index][0], icon: iconSelect[listTest2[index][1]], colorGradient: gradientSelect[listTest2[index][1]],);
                    }
                )
              ],
            ),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          )
        ],
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 130,
              //ListTile in the header is kinda wonked, will fix
              child: DrawerHeader(
                child: Container(child: ListTile(
                  leading: IconButton(icon: Icon(Icons.arrow_back, size: 27, color: Colors.white,)),
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
              onTap: () => {},
            ),
            ListTile(
              leading: Icon(CustomIcons.user_plus_solid, color: Colors.black,),
              title: Text("Register", style: TextStyle(fontSize: 15, fontFamily: 'Poppins'),),
              onTap: () => {},
            )
          ],
        ),
      ),
    );
  }
}
