import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:planttag/models/tree_species_model.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key}) : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  List<TreeSpeciesModel> treeSpeciesModelList = [];
  late GoogleMapController mapController;

  LatLng? _currentPosition;
  bool _isLoading = true;
  final List<Marker> _markers = <Marker>[];

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  // loadData() async{
  //   for(int i=0 ;i<images.length; i++){
  //     final Uint8List markIcons = await getImages(images[i], 100);
  //     // makers added according to index
  //     _markers.add(
  //         Marker(
  //           // given marker id
  //           markerId: MarkerId(i.toString()),
  //           // given marker icon
  //           icon: BitmapDescriptor.fromBytes(markIcons),
  //           // given position
  //           position: _latLen[i],
  //           infoWindow: InfoWindow(
  //             // given title for marker
  //             title: 'Location: '+i.toString(),
  //           ),
  //         )
  //     );
  //     setState(() {
  //     });
  //async /   }
  // }

  getMarkerLocations() async {
    final db = FirebaseFirestore.instance;
    final docRef = db.collection("tags");
    await docRef.get().then((QuerySnapshot querySnapshot) async {
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        treeSpeciesModelList.add(TreeSpeciesModel.fromJson(docSnapshot.data()));
      }

      final Uint8List markIcons = await getImages("images/1.png", 50);

      for (int i = 0; i < treeSpeciesModelList.length; i++) {
        _markers.add(Marker(
          icon: BitmapDescriptor.fromBytes(markIcons),
          markerId: MarkerId(treeSpeciesModelList[i].rfid ?? ""),
          position: LatLng(treeSpeciesModelList[i].latitude ?? 0,
              treeSpeciesModelList[i].longitude ?? 0),
        ));
      }
    });
  }

  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
      _currentPosition = location;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    getMarkerLocations();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentPosition ?? const LatLng(22.056800, 78.937300),
              zoom: 25.0,
            ),
            markers: Set<Marker>.of(_markers),
          );
  }
}
