import 'dart:io';

import 'package:flutter/scheduler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planttag/models/detect_species_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:planttag/pages/Choose_image.dart';

class ConfirmSpeciesScreen extends StatefulWidget {
  final List<XFile>? pickedFile;
  final String organ;
  final Results result;
  final List<String> imgUrls;
  const ConfirmSpeciesScreen(
      {Key? key,
      required this.pickedFile,
      required this.organ,
      required this.result, required this.imgUrls})
      : super(key: key);

  @override
  State<ConfirmSpeciesScreen> createState() => _ConfirmSpeciesScreenState();
}

class _ConfirmSpeciesScreenState extends State<ConfirmSpeciesScreen> {
  DatabaseReference database = FirebaseDatabase.instance.ref();
  Reference storage = FirebaseStorage.instance.ref();
  FirebaseFirestore db = FirebaseFirestore.instance;

  bool loading = false;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      permission = await Geolocator.requestPermission();
      permission = await Geolocator.checkPermission();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plant Tag"),
      ),
      body: FutureBuilder(
          future: _determinePosition(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.file(
                        File(widget.pickedFile![0].path),
                        errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) =>
                            const Center(
                                child:
                                    Text('This image type is not supported')),
                      ),
                      ListTile(
                        dense: false,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.result.species?.scientificName ?? "",
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.result.species?.family?.scientificName ??
                                  "",
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.result.species?.commonNames != null &&
                                widget.result.species?.commonNames?.length != 0)
                              Text(
                                  widget.result.species?.commonNames?[0] ?? ""),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                OutlinedButton(
                                    onPressed: null,
                                    child: Text(
                                        "${((widget.result.score ?? 0) * 100).toStringAsPrecision(2)} %"))
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                            "Coordinates: ${snapshot.data!.latitude} ${snapshot.data!.longitude}"),
                      ),
                      loading ? const CircularProgressIndicator() : StreamBuilder(
                        stream: database.onValue,
                        builder: (context, snap) {
                          if (snap.hasData &&
                              !snap.hasError &&
                              snap.data?.snapshot.value != null) {
                            Map? data = snap.data?.snapshot.value as Map?;
                            List<String?> item = [];

                            data?["tags"].forEach((ele) {
                              item.add(ele);
                            });
                            return ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: item.length,
                                itemBuilder: (context, index) {
                                  if(item[index] != null) {
                                    return ListTile(
                                      title: Text(item[index] ?? ""),
                                      onTap: () async {
                                        setState(()  {
                                          loading = true;
                                        });
                                        File file = File(widget.pickedFile![0].path);
                                        try {
                                          print("${widget.pickedFile![0].name}_${DateTime.now().millisecondsSinceEpoch}");
                                          final ref = storage.child("${widget.pickedFile![0].name}_${DateTime.now().millisecondsSinceEpoch}");
                                          await ref.putFile(file).then((p0) async {
                                            String downloadUrl = await ref.getDownloadURL();
                                            final data = <String, dynamic>{
                                              "rfid": item[index],
                                              "gbif-id": widget.result.gbif?.id,
                                              "latitude": snapshot.data!.latitude,
                                              "longitude": snapshot.data!.longitude,
                                              "user-id": FirebaseAuth.instance.currentUser?.uid,
                                              "img-url": downloadUrl,
                                              "organs": widget.organ,
                                              "timestamp": DateTime.now().millisecondsSinceEpoch,
                                              "ref-images": widget.imgUrls
                                            };
                                            db.collection("tags").doc(item[index] ?? "").set(data).then((value) {
                                              // print('DocumentSnapshot added with ID: ${doc.id}');
                                              database.child("tags/$index").set(null).then((value) {
                                                setState(() {
                                                  loading = false;
                                                });
                                                // Navigator.of(context).popUntil(ModalRoute.withName('/root'));
                                                Get.offAll(() => const ChooseImageScreen());
                                              });
                                            });
                                          });
                                        } on FirebaseException catch (e) {
                                          print(e);
                                        }
                                      },
                                    );
                                  }
                                  else {
                                    return const SizedBox();
                                  }
                                });
                          } else {
                            return const Text("No data");
                          }
                        },
                      )
                    ],
                  ),
                );
              } else {
                return const Text("Error");
              }
            } else {
              return const Text("error");
            }
          }),
    );
  }
}
