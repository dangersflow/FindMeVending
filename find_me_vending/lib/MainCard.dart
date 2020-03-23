import 'package:flutter/material.dart';
import 'package:findmevending/custom_icons_icons.dart';
import 'package:flutter_icons/flutter_icons.dart';


//cards are cool :)
class MainCard extends StatefulWidget {
  MainCard({this.title, this.colorGradient, this.icon});
  String title;
  List<Color> colorGradient;
  Icon icon;

  @override
  _MainCardState createState() => _MainCardState();
}

class _MainCardState extends State<MainCard> {
  @override
  //this may be a little jank, but it's a wip lol
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: 200,
        width: 180,
        child: Card(
          child: Container(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Drinks", style: TextStyle(fontFamily: 'Poppins', fontSize: 20, color: Colors.white),)
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(child: widget.icon,)
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                Row(
                  children: <Widget>[
                    Container(child: Icon(CustomIcons.heart_filled, color: Colors.white,),)
                  ],
                  mainAxisAlignment: MainAxisAlignment.end,
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: widget.colorGradient
                ),
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      )
    );
  }
}

