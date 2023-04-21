import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planttag/main.dart';
import 'package:planttag/pages/Choose_organ_screen.dart';

class ChooseImageScreen extends StatefulWidget {
  const ChooseImageScreen({super.key});

  @override
  State<ChooseImageScreen> createState() => _ChooseImageScreenState();
}

class _ChooseImageScreenState extends State<ChooseImageScreen> {
  List<XFile>? _imageFileList;

  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    if (isMultiImage) {
      try {
        final List<XFile> pickedFileList = await _picker.pickMultiImage();
        setState(() {
          _imageFileList = pickedFileList;
          Get.offAll(() => ChooseOrganScreen(pickedFile: _imageFileList));
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    } else {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
        );
        setState(() {
          _setImageFileListFromFile(pickedFile);
          Get.offAll(() => ChooseOrganScreen(pickedFile: _imageFileList));
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    }
  }

  @override
  void dispose() {
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: ListView.builder(
          key: UniqueKey(),
          itemBuilder: (BuildContext context, int index) {
            // Why network for web?
            // See https://pub.dev/packages/image_picker_for_web#limitations-on-the-web-platform
            return Semantics(
              label: 'image_picker_example_picked_image',
              child: kIsWeb
                  ? Image.network(_imageFileList![index].path)
                  : Image.file(
                      File(_imageFileList![index].path),
                      errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) =>
                          const Center(
                              child: Text('This image type is not supported')),
                    ),
            );
          },
          itemCount: _imageFileList!.length,
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                _onImageButtonPressed(
                  ImageSource.gallery,
                  context: context,
                  isMultiImage: true,
                );
              },
              heroTag: 'image1',
              tooltip: 'Pick Multiple Image from gallery',
              child: const Icon(
                Icons.photo,
                color: Colors.green,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ElevatedButton(
              onPressed: () {
                _onImageButtonPressed(ImageSource.camera, context: context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, shape: CircleBorder()),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: const Icon(
                  Icons.camera_alt,
                  size: 80,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Container(
              width: 56.0,
            ),
          ),
        ],
      );
    }
  }

  Widget _handlePreview() {
    return _previewImages();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.files == null) {
          _setImageFileListFromFile(response.file);
        } else {
          _imageFileList = response.files;
        }
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'PLANT TAG',
          style: TextStyle(
            color: Colors.green,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
            ? FutureBuilder<void>(
                future: retrieveLostData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: FloatingActionButton(
                              backgroundColor: Colors.white,
                              onPressed: () {
                                _onImageButtonPressed(
                                  ImageSource.gallery,
                                  context: context,
                                  isMultiImage: true,
                                );
                              },
                              heroTag: 'image1',
                              tooltip: 'Pick Multiple Image from gallery',
                              child: const Icon(
                                Icons.photo,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                _onImageButtonPressed(ImageSource.camera,
                                    context: context);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: CircleBorder()),
                              child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 80,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Container(
                              width: 56.0,
                            ),
                          ),
                        ],
                      );
                    case ConnectionState.done:
                      return _handlePreview();
                    case ConnectionState.active:
                      if (snapshot.hasError) {
                        return Text(
                          'Pick image/video error: ${snapshot.error}}',
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: FloatingActionButton(
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  _onImageButtonPressed(
                                    ImageSource.gallery,
                                    context: context,
                                    isMultiImage: true,
                                  );
                                },
                                heroTag: 'image1',
                                tooltip: 'Pick Multiple Image from gallery',
                                child: const Icon(
                                  Icons.photo,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  _onImageButtonPressed(ImageSource.camera,
                                      context: context);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: CircleBorder()),
                                child: Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 80,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Container(
                                width: 56.0,
                              ),
                            ),
                          ],
                        );
                      }
                  }
                },
              )
            : _handlePreview(),
      ),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}
