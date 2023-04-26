import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planttag/data/api_helper.dart';
import 'package:planttag/models/detect_species_model.dart';
import 'package:planttag/pages/confirm_species_screen.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';

class ChooseSpeciesScreen extends StatefulWidget {
  final List<XFile>? pickedFile;
  final String organ;
  const ChooseSpeciesScreen({Key? key, this.pickedFile, required this.organ})
      : super(key: key);

  @override
  State<ChooseSpeciesScreen> createState() => _ChooseSpeciesScreenState();
}

class _ChooseSpeciesScreenState extends State<ChooseSpeciesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plant Tag"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(
              File(widget.pickedFile![0].path),
              errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) =>
                  const Center(child: Text('This image type is not supported')),
            ),
            FutureBuilder<DetectSpeciesModel?>(
              future: DioClient.instance
                  .detectSpecies(widget.pickedFile, widget.organ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.done) {
                  List<Results> results;
                  if (snapshot.hasData) {
                    results = snapshot.data?.results ?? [];
                    return ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: results.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          List<String> imageUrls = [];
                          List<Image> assets = [];
                          List<ImageGalleryHeroProperties> heroProperties = [];
                          results[index].images?.forEach((element) {
                            assets.add(Image.network(
                              element.url?.o ?? "",
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ));
                            heroProperties.add(ImageGalleryHeroProperties(
                                tag: element.url?.o ?? ""));
                            imageUrls.add(element.url?.o ?? "");
                          });
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: assets.length,
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (ctx, ind) {
                                    return InkWell(
                                      onTap: () => SwipeImageGallery(
                                              context: context,
                                              children: assets,
                                              heroProperties: heroProperties)
                                          .show(),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child: Hero(
                                          tag: heroProperties[ind],
                                          child: assets[ind],
                                        ),
                                      ),
                                    );
                                    // return assets[ind];
                                  },
                                ),
                              ),
                              ListTile(
                                isThreeLine: true,
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      results[index].species?.scientificName ??
                                          "",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      results[index]
                                              .species
                                              ?.family
                                              ?.scientificName ??
                                          "",
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (results[index].species?.commonNames !=
                                            null &&
                                        results[index]
                                                .species
                                                ?.commonNames
                                                ?.length !=
                                            0)
                                      Text(results[index]
                                              .species
                                              ?.commonNames?[0] ??
                                          ""),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        OutlinedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ConfirmSpeciesScreen(
                                                            organ: widget.organ,
                                                            result:
                                                                results[index],
                                                            pickedFile: widget
                                                                .pickedFile, imgUrls: imageUrls,
                                                          )));
                                            },
                                            child: const Text("Confirm")),
                                        OutlinedButton(
                                            onPressed: null,
                                            child: Text(
                                                "${((results[index].score ?? 0) * 100).toStringAsPrecision(2)} %"))
                                      ],
                                    )
                                  ],
                                ),
                                // trailing: Icon(Icons.info_outline),
                              )
                            ],
                          );
                        });
                  } else {
                    return const Text("error loading data");
                  }
                } else {
                  return const Text("error loading data");
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
