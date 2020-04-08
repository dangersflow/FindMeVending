import 'package:flutter/material.dart';
import 'package:findmevending/MainCard.dart';
import 'package:findmevending/custom_icons_icons.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:findmevending/loginSignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';

//map to select gradients based on type
Map<int, List<Color>> gradientSelect =
{
  //snacks
  1: [const Color(0xFFF69D9D), const Color(0xFFF8B195)],
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
  1: Icon(CustomIcons.snack, size: 100,),
  //drinks
  2: Icon(CustomIcons.soda, size: 100,),
  //restrooms
  3: Icon(CustomIcons.lavatory, size: 100,),
  //water bottle fillers
  4: Icon(CustomIcons.water, size: 100,)
};

//testing stuff, though this is not going to be how the real thing looks like
List<List<dynamic>> list = [
  ["Drinks", 2],
  ["Snacks", 1],
  ["Restrooms", 3],
  ["Water", 4],
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


class HomeScreen extends StatefulWidget {
  HomeScreen({this.key});

  PageStorageKey key;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
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
    );
  }
}
