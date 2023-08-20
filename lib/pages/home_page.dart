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
import 'package:planttag/pages/species_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TreeSpeciesModel> treeSpeciesModelList = [];

  Map<String, int> gbifList = {};
  bool _isLoading = true;

  Future<List<TreeSpeciesModel>> getMarkerLocations() async {
    final db = FirebaseFirestore.instance;
    final docRef = db.collection("tags");
    await docRef.get().then((QuerySnapshot querySnapshot) async {
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        TreeSpeciesModel temp = TreeSpeciesModel.fromJson(docSnapshot.data());
        treeSpeciesModelList.add(temp);
        gbifList[temp.gbifid ?? ""] = 1 + (gbifList[temp.gbifid ?? ""] ?? 0);
      }
      return treeSpeciesModelList;
    });
    return treeSpeciesModelList;
  }

  Future<dynamic> getCharacter(String character) async {
    // List<GbifModel> gbif = [];
    String baseUrl = 'https://api.gbif.org/v1/species/$character';
    print(baseUrl);

    var url = Uri.parse(baseUrl);
    var response = await http.get(url);
    // print(response.body.isNotEmpty);
    if (response.body.isNotEmpty) {
      var responseBody = jsonDecode(response.body);
      // print(responseBody);
      // if (responseBody["synonym"] == false) {
      // print("$responseBody fdhsfjhdslfkdjflisdkfkjs");
      // print("skdlfjsdklfjsdfjsdjkfkjsdjsdjfdjs");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<TreeSpeciesModel>>(
            future: getMarkerLocations(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<TreeSpeciesModel> productList = snapshot.data ?? [];
                print(productList);
                return ListView.builder(
                    itemCount: gbifList.keys.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                          future: getCharacter(gbifList.keys.elementAt(index)),
                          builder: (context, snapshot) {
                            if(snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.hasData) {
                                Map<String, dynamic> mp = snapshot.data;
                                return ListTile(
                                  title: Text(snapshot.data["scientificName"].toString()),
                                  trailing: Text(gbifList.values.elementAt(index).toString()),
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SpeciesScreen(mp: mp,)));
                                  },
                                );
                              } else {
                                return const Center(child: SizedBox());
                              }
                            } else {
                              return const Center(child: SizedBox(),);
                            }
                      });
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            })
    );
  }

  Widget customval(String val) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(val,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15)),
    );
  }
}
