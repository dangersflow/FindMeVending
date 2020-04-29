import 'package:flutter/material.dart';
import 'package:map_markers/map_markers.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:user_location/user_location.dart';
import 'package:latlong/latlong.dart';
import 'package:findmevending/organizing_classes/VendingEntry.dart';
import 'package:findmevending/organizing_classes/ItemEntry.dart';
import 'package:findmevending/organizing_classes/FountainEntry.dart';
import 'package:findmevending/organizing_classes/RestroomEntry.dart';
import 'package:findmevending/organizing_classes/LocationEntry.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';

List<String> types = <String>["Food Vending", "Drink Vending", "Restroom", "Water Fountain"];
Color textFieldColor = Colors.grey[350];
InputDecoration dec = InputDecoration(filled: true, fillColor: textFieldColor, border: OutlineInputBorder());

class NewPinScreen extends StatefulWidget {
  @override
  _NewPinScreenState createState() => _NewPinScreenState();
}

class _NewPinScreenState extends State<NewPinScreen> {
  int _selection = 0;
  TextEditingController buildingCode = TextEditingController();
  List<TextEditingController> itemsControllers = [TextEditingController()];
  List<Widget> items = <Widget>[TextField()];
  TextEditingController locationInstructions = TextEditingController();
  int lastLength = 0;
  bool initiate = false;
  List<Widget> statusBoxes = [];
  List<bool> statuses = [];
  MapController mapController = MapController();
  UserLocationOptions userLocationOptions;

  Marker locSelected;
  LatLng point;
  var _image;
  String _imageURL;

  Future<void> submit() async{
    await uploadFile();
    Entry entry;
    if(_selection == 0 || _selection == 1) {
      while(itemsControllers[itemsControllers.length-1].text.length == 0) {
        itemsControllers.removeAt(itemsControllers.length-1);
      }
      List<Item> items = [];
      for(int i = 0; i < itemsControllers.length; i++) {
        items.add(Item("", itemsControllers[i].text, false));
      }
      entry = VendingEntry("", _selection, point.latitude, point.longitude, _imageURL, this.buildingCode.text, this.locationInstructions.text, items, statuses);
    }
    else if(_selection == 2) {
      entry = RestroomEntry("", point.latitude, point.longitude, _imageURL, this.buildingCode.text, this.locationInstructions.text, statuses);
    }
    else {
      entry = WaterFountainEntry("", point.latitude, point.longitude, _imageURL, this.buildingCode.text, this.locationInstructions.text, statuses);
    }

    if(entry.createEntryDocument() != 0) {
      print("ERROR");
    }

    masterlistEntries.add(entry);
  }

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance.ref().child('${Path.basename(_image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    _imageURL = await storageReference.getDownloadURL();
    _imageURL = _imageURL.toString();
    print(_imageURL);
  }

  void initState() {
    itemsControllers[itemsControllers.length-1].addListener(() {
      if (itemsControllers[itemsControllers.length-1].text.length == 1 && lastLength == 0) {
        generateItemFields(add: true);
      }

      lastLength = itemsControllers[itemsControllers.length-1].text.length;
    });
    super.initState();
  }

  void changeSelection(int value) {
    _selection = value;

    items.clear();
    itemsControllers.clear();
    itemsControllers.add(TextEditingController());
    generateItemFields();
    statuses.clear();
    statusBoxes.clear();
    generateStatuses(newSelection: true);

    setState(() {});
  }

  void updateLocationSelected(LatLng point) {
    this.point = point;
    locSelected = new Marker(height: 100, width: 120, point: point,
      builder: (ctx) =>
      new BubbleMarker(
      bubbleColor: colorSelect[_selection],
      bubbleContentWidgetBuilder: (BuildContext context) {
      return Text(locationInstructions.text);
      },
      widgetBuilder: (BuildContext context) {
      return Icon(Icons.location_on,
      color: colorSelect[_selection]);
      }
      ),
    );
    super.setState((){});
  }

  void generateStatuses({bool newSelection = false}) {
    if(newSelection) {
      if (_selection == 0 || _selection == 1) {
        for (int i = 0; i < vendingStatuses.length; i++) {
          statuses.add(false);
        }
      }
      else if (_selection == 2) {
        for (int i = 0; i < restroomStatuses.length; i++) {
          statuses.add(false);
        }
      }
      else if (_selection == 3) {
        for (int i = 0; i < fountainStatuses.length; i++) {
          statuses.add(false);
        }
      }
    }

    statusBoxes.clear();

    if(_selection == 0 || _selection == 1) {
      for(int i = 0; i < statuses.length; i++) {
        statusBoxes.add(Container(child: Row(children: <Widget>[
          Checkbox(value: statuses[i], onChanged: (bool j){ generateStatuses(); super.setState(() { statuses[i] = j;});}),
          Text("${vendingStatuses[i]}", style: TextStyle(fontFamily: 'Poppins', fontSize: 18)),
        ])));
      }
    }
    else if(_selection == 2) {
      for(int i = 0; i < statuses.length; i++) {
        statusBoxes.add(Container(child: Row(children: <Widget>[
          Checkbox(value: statuses[i], onChanged: (bool j){ generateStatuses(); super.setState(() { statuses[i] = j;});}),
          Text("${restroomStatuses[i]}", style: TextStyle(fontFamily: 'Poppins', fontSize: 18)),
        ])));
      }
    }
    else if(_selection == 3) {
      for(int i = 0; i < statuses.length; i++) {
        statusBoxes.add(Container(child: Row(children: <Widget>[
          Checkbox(value: statuses[i], onChanged: (bool j){ generateStatuses(); super.setState(() { statuses[i] = j;});}),
          Text("${fountainStatuses[i]}", style: TextStyle(fontFamily: 'Poppins', fontSize: 18)),
        ])));
      }
    }
  }

  void generateItemFields({bool add=false, int remove}) {
    if(add) {
      itemsControllers.add(TextEditingController());
    }

    if (remove != null) {
      itemsControllers.removeAt(remove);
      if(itemsControllers.length == 0) {
        itemsControllers.add(TextEditingController());
      }
    }

    items.clear();

    for(int i = 0; i < itemsControllers.length; i++){
      IconButton button;
      if(itemsControllers[i].text.length == 0) {
        button = IconButton(icon: Icon(Icons.add), onPressed: () { generateItemFields(add: true); });
      }
      else {
        button = IconButton(icon: Icon(Icons.clear), onPressed: () { generateItemFields(remove: i); });
      }
      items.add(TextField(controller: itemsControllers[i], style: TextStyle(fontFamily: 'Poppins'), decoration: InputDecoration(filled: true, fillColor: textFieldColor, border: OutlineInputBorder(), suffixIcon: button),));
    }

    itemsControllers[itemsControllers.length-1].addListener(() {
      if (itemsControllers[itemsControllers.length-1].text.length == 1 && lastLength == 0) {
        generateItemFields(add: true);
      }

      lastLength = itemsControllers[itemsControllers.length-1].text.length;
    });

    super.setState((){});
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    String dateTime = DateTime.now().toString().replaceAll(":", "_").replaceAll("-", "_").replaceAll(".", "_");
    image = await image.rename(Path.dirname(image.path)+dateTime+".jpg");

    setState((){
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<EntryList>(context, listen: false).reopen();

    userLocationOptions = UserLocationOptions(
      context: context,
      mapController: mapController,
      markers: [],
      updateMapLocationOnPositionChange: false,
      //since it'll be mostly used at school, this could be convenient
      zoomToCurrentLocationOnLoad: false,
    );

    if (!initiate) {
      locSelected = new Marker(height: 100, width: 120, point: LatLng(0, 0),
        builder: (ctx) =>
        new BubbleMarker(
            bubbleColor: colorSelect[_selection],
            bubbleContentWidgetBuilder: (BuildContext context) {
              return Text(locationInstructions.text);
            },
            widgetBuilder: (BuildContext context) {
              return Icon(Icons.location_on,
                  color: colorSelect[_selection]);
            }
        ),
      );
      generateItemFields();
      super.setState((){});
      initiate = true;
    }
    generateStatuses();

    return Scaffold(
        appBar: AppBar(
            title: Text("Create a Pin", style: TextStyle(fontSize: 27, color: Colors.white)),
            iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: ListView(shrinkWrap: true, children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    color: Colors.red,
                    width: (MediaQuery.of(context).size.width/2)-(MediaQuery.of(context).size.width/12),
                    height: (MediaQuery.of(context).size.height/3),
                    child: FlutterMap(
                      options: new MapOptions(
                        center: new LatLng(26.306167, -98.173148),
                        zoom: 16.0,
                        plugins: [
                          UserLocationPlugin(),
                        ],
                        onTap: updateLocationSelected,
                      ),
                      layers: [
                        new TileLayerOptions(
                          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c'],
                        ),
                        new MarkerLayerOptions(
                          markers: [locSelected],
                        ),
                        userLocationOptions,
                      ],
                      mapController: mapController,
                    ),
                  ),
                  Spacer(),
                  InkWell(child: Container(
                      color: Colors.blue,
                      width: (MediaQuery.of(context).size.width/2)-(MediaQuery.of(context).size.width/12),
                      height: (MediaQuery.of(context).size.height/3),
                      child: _image == null?Center(child: Text("Tap me to \ntake a photo!", style: TextStyle(fontFamily: "Poppins", fontSize: 16, color: Colors.white))):Image.file(_image),
                    ),
                    onTap: ((){getImage();})
                  )
                ]
            ),
            Align(child: Text("Type", style: TextStyle(fontSize: 32), ), alignment: Alignment.topLeft,),
            GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: types.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Container(child:
                Row(children: <Widget>[
                      Radio(value: index, groupValue: _selection, onChanged: changeSelection,),
                      Text(types[index], style: TextStyle(fontFamily: 'Poppins', fontSize: 18))
              ]
              ));
            }),
            Align(child: Text("Building Code", style: TextStyle(fontSize: 32), ), alignment: Alignment.topLeft,),
            TextField(controller: buildingCode, style: TextStyle(fontFamily: 'Poppins'), decoration: dec,),
            Align(child: Text("Location Instructions", style: TextStyle(fontSize: 32), ), alignment: Alignment.topLeft,),
            Align(child: Text("More Specific Instructions of how to get there.", style: TextStyle(fontSize: 14, fontFamily: 'Poppins'), ), alignment: Alignment.topLeft,),
            Align(child: Text("Example: At the end of the last hallway to the right while walking toward the library.", style: TextStyle(fontSize: 14, fontFamily: 'Poppins'), ), alignment: Alignment.topLeft,),
            TextField(controller: locationInstructions, style: TextStyle(fontFamily: 'Poppins'), decoration: dec,),
            (_selection == 0 || _selection == 1)?Align(child: Text("Included", style: TextStyle(fontSize: 32), ), alignment: Alignment.topLeft,):Text("", style: TextStyle(fontSize: 1)),
            (_selection == 0 || _selection == 1)?Column(children: items):Text("", style: TextStyle(fontSize: 1)),
            Column(children: statusBoxes),
            Align(alignment: Alignment.topRight, child: RaisedButton(
              child: Text("SUBMIT", style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 18)),
            color: Color(0xFF98BCBF),
            onPressed: ((){submit(); Navigator.pop(context);})
            ))
    ]),
    ));
  }
}
