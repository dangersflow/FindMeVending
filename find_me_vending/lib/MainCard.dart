import 'package:findmevending/mapScreen.dart';
import 'package:findmevending/organizing_classes/LocationEntry.dart';
import 'package:flutter/material.dart';
import 'package:findmevending/custom_icons_icons.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:findmevending/main.dart';

import 'custom_icons_icons.dart';


//cards are cool :)
class MainCard extends StatefulWidget {
  MainCard({this.title, this.colorGradient, this.icon, this.type, this.callback});
  String title;
  List<Color> colorGradient;
  Icon icon;
  bool liked = false;
  int type;
  Function(int, MapScreen) callback;

  @override
  _MainCardState createState() => _MainCardState();
}

class _MainCardState extends State<MainCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: SizedBox(
          height: 220,
          width: 180,
          child: Card(
            child: Container(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        child: Text(widget.title, style: TextStyle(fontFamily: 'Poppins', fontSize: 20, color: Colors.white),),
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      )
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
                      Container(
                        child: IconButton(
                          icon: widget.liked ? Icon(CustomIcons.heart_filled, color: Colors.white,) : Icon(CustomIcons.heart, color: Colors.white,),
                          highlightColor: Colors.black,
                          onPressed: () => {
                            setState(() => {
                              widget.liked = !widget.liked
                            })
                          },
                        ),
                        width: 30,
                        height: 30,
                      )
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
            elevation: 3.0,
          ),
        ),
      ),
      onTap: (){
        //showDialog(context: context, builder: (BuildContext context) => AlertDialog(title: Text(widget.title + " was pressed!"),));
        if(widget.title == "Snacks")
          widget.callback(2, MapScreen(masterList: entries, waterSelected: false, restroomSelected: false, drinksSelected: false,));
        else if(widget.title == "Drinks")
          widget.callback(2, MapScreen(masterList: entries, waterSelected: false, restroomSelected: false, snacksSelected: false,));
        else if(widget.title == "Restrooms")
          widget.callback(2, MapScreen(masterList: entries, waterSelected: false, snacksSelected: false, drinksSelected: false,));
        else if(widget.title == "Water")
          widget.callback(2, MapScreen(masterList: entries, restroomSelected: false, snacksSelected: false, drinksSelected: false,));
      },
    );
  }
}

