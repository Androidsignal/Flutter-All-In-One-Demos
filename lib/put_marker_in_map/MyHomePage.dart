
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps/Constants.dart';
import 'package:google_maps/put_marker_in_map/LatLongModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Marker> allMarkers = [];

  GoogleMapController _controller;

  List<LatLongModel> categoryList = new List<LatLongModel>();

  bool isDone = false;

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    /*callApiForData();

    allMarkers.add(Marker(
        markerId: MarkerId('myMarker'),
        draggable: true,
        onTap: () {
          print('Marker Tapped');
        },
        position: LatLng(21.233654, 72.818233)));

    allMarkers.add(Marker(
        markerId: MarkerId('myMarker2'),
        draggable: true,
        onTap: () {
          print('Marker Tapped');
        },
        position: LatLng(21.236836, 72.814964)));*/

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Maps'),
        ),
        body: new Stack(children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(21.233654, 72.818233), zoom: 12.0),
              markers: Set.from(allMarkers),
              onMapCreated: mapCreated,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: movetoMarkers,
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.green),
                child: Icon(Icons.forward, color: Colors.white),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: movetoNewYork,
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.red),
                child: Icon(Icons.backspace, color: Colors.white),
              ),
            ),
          )
        ]),
      ),
    );
  }

  Future callApiForData() async {
    String result =
    await DefaultAssetBundle.of(context).loadString('assets/latlong.txt');
    print(result);
    Map resultData = json.decode(result);
    List latLongList = resultData["latLong"];
    categoryList = latLongList.map((c) => new LatLongModel.fromMap(c)).toList();
    print("Your Dat ===>? " + categoryList.length.toString());
    isDone = true;
    return categoryList;
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  movetoMarkers() async {
    Constants.progressDialog(true, context);
    await callApiForData();

    for (int i = 0; i < categoryList.length; i++) {
      Marker marker = new Marker(
          markerId: MarkerId("$i"),
          draggable: true,
          infoWindow: InfoWindow(title: "Marker $i"),
          position: LatLng(double.parse(categoryList[i].lat.toString()),
              double.parse(categoryList[i].long.toString())));
      allMarkers.add(marker);
    }
    Constants.progressDialog(false, context);

    setState(() {});
    /*allMarkers.add(Marker(
        markerId: MarkerId('myMarker2'),
        draggable: true,
        onTap: () {
          print('Marker Tapped');
        },
        position: LatLng(21.236836, 72.814964)));*/
  }

  movetoBoston() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(42.3601, -71.0589),
          zoom: 14.0,
          bearing: 45.0,
          tilt: 45.0),
    ));
  }

  movetoNewYork() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(40.7128, -74.0060), zoom: 12.0),
    ));
  }
}