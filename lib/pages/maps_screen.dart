import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:planttag/models/gbif_model.dart';

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
          onTap: () {
            
          },
            icon: BitmapDescriptor.fromBytes(markIcons),
            markerId: MarkerId(treeSpeciesModelList[i].rfid ?? ""),
            position: LatLng(treeSpeciesModelList[i].latitude ?? 0,
                treeSpeciesModelList[i].longitude ?? 0),
            infoWindow: InfoWindow(title: "shfldsjf")));
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

  Future<List<TreeSpeciesModel>> getStarted_readData() async {
    List<TreeSpeciesModel> productList = [];
    print("sdjkfhldskfhd");
    await FirebaseFirestore.instance
        .collection("tags")
        // .where("latitude" ,isEqualTo: _currentPosition?.latitude.toDouble())
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((product) {
        var _product = product.data();
        print(_product);
        productList.add(TreeSpeciesModel.fromJson(_product));
      });
    });
    print(productList[0].gbifid);
    // print(q["key"]);
    return productList;
  }

  final Dio _dio = Dio();
  Future<dynamic> getCharacter(String character) async {
    // List<GbifModel> gbif = [];
    String baseUrl = 'https://api.gbif.org/v1/species/$character';
    print(baseUrl);

    var url = Uri.parse(baseUrl);
    var response = await http.get(url);
    print(response.body.isNotEmpty);
    if (response.body.isNotEmpty) {
      var responseBody = jsonDecode(response.body);
      print(responseBody);
      // if (responseBody["synonym"] == false) {
      print("$responseBody fdhsfjhdslfkdjflisdkfkjs");
      print("skdlfjsdklfjsdfjsdjkfkjsdjsdjfdjs");
        return responseBody;
      // } 
      // else {
      //   print("Failed ");
      //   return "";
      // }
    } else {
      print("Failed");
      return "";
      //throw exception and catch it in UI
    }
  }

  // Dio get dio => _dio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition ??
                          const LatLng(22.056800, 78.937300),
                      zoom: 25.0,
                    ),
                    markers: Set<Marker>.of(_markers),
                  ),
                  FutureBuilder<List<TreeSpeciesModel>>(
                      future: getStarted_readData(),
                      builder: (context, snapshot) {
                        print(snapshot.data);
                        if (snapshot.hasData) {
                          List<TreeSpeciesModel> productList =
                              snapshot.data ?? [];
                          print(productList);
                          return DraggableScrollableSheet(
                              initialChildSize: 0.25,
                              minChildSize: 0.25,
                              maxChildSize: 1,
                              snapSizes: [0.5, 1],
                              snap: true,
                              builder:
                                  (BuildContext context, scrollController) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0).h,
                                  child: Container(
                                    color: Colors.white,
                                    child: ListView(
                                      controller: scrollController,
                                      children: [
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        FutureBuilder<dynamic>(
                                            future: getCharacter(productList[0]
                                                .gbifid
                                                .toString()),
                                            builder: (context, snapshot) {
                                              print(snapshot.data);
                                              if (snapshot.hasData) {
                                                // List<GbifModel> productList1 =
                                                //     snapshot.data ?? [];
                                                // print(productList1);
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Scientific Name: "
                                                              .capitalize ??
                                                          "",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                              color: Colors.green,
                                                          fontSize: 17),
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    customval(snapshot.data["scientificName"].toString()),
                                                  ],
                                                );
                                              } else {
                                                return CircularProgressIndicator();
                                              }
                                            }),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Image.network(
                                          productList[0].imgurl.toString(),
                                          height: 160,
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 100.w,
                                              child: Text(
                                                "Organs:",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green,
                                                    fontSize: 17),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            customval(productList[0]
                                                    .organs
                                                    .toString()
                                                    .capitalize ??
                                                ""),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 100.w,
                                              child: Text(
                                                "Longitude:",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.green,
                                                    fontSize: 17),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            customval(productList[0]
                                                .longitude
                                                .toString())
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 100.w,
                                              child: Text(
                                                "Latitude:",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.green,
                                                    fontSize: 17),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            customval(
                                              productList[0]
                                                  .latitude
                                                  .toString(),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        } else {
                          return CircularProgressIndicator();
                        }
                      })
                ],
              ));
  }

  Widget customval(String val) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(val,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15)),
    );
  }
}
