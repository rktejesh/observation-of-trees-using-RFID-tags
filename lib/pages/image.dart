import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import '../models/upload_files_data.dart';
import 'image_preview.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key});
  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? _imageFile;
  Uint8List? img;
  final picker = ImagePicker();
  var formData;
  bool isLoading = false;
  SnackBar snackBar = SnackBar(
    content: Container(),
  );
  late Response response;
  var dio = Dio();
  Future pickImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 30,
    );
    final imagedata = await pickedFile?.readAsBytes();
    setState(() {
      _imageFile = File(pickedFile!.path);
      img = imagedata;
    });
  }

  Future<void> _cropImage() async {
    if (_imageFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: _imageFile!.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Edit',
            toolbarColor: const Color(0Xff15609c),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _imageFile = File(croppedFile.path);
        });
      }
    }
  }

  var idcard;

  @override
  Widget build(BuildContext context) {
    UploadFilesData upload;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0Xff15609c),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              width: 12,
            ),
            Text("Plant Tag", style: TextStyle(fontSize: 21)),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Text(
              "Capture Your Image",
              style: TextStyle(
                color: Color(0Xff15609c),
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: _imageFile != null
                    ? kIsWeb
                    ? Image.memory(img!)
                    : Image.file(_imageFile!)
                    : TextButton(
                  onPressed: pickImage,
                  child: const Icon(
                    Icons.add_a_photo,
                    color: Color(0Xff15609c),
                    size: 50,
                    semanticLabel: "Take Picture",
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              child: _imageFile != null
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: const Icon(
                      Icons.add_a_photo,
                      color: Color(0Xff15609c),
                      size: 30,
                    ),
                    onTap: () {
                      setState(() {
                        _imageFile = null;
                      });
                    },
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  GestureDetector(
                    child: const Icon(
                      Icons.edit,
                      color: Color(0Xff15609c),
                      size: 30,
                    ),
                    onTap: () {
                      _cropImage();
                    },
                  )
                ],
              )
                  : const Text(""),
            ),

            const SizedBox(
              height: 60,
            ),
            //uploadImageButton(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: const EdgeInsets.all(12),
                    minimumSize:
                    Size(MediaQuery.of(context).size.width, 38),
                    alignment: Alignment.center,
                    backgroundColor: const Color(0xFF14619C)),
                onPressed: () async => {
                  setState(() {
                    isLoading = true;
                  }),
                  if (_imageFile != null)
                    {
                      formData = FormData.fromMap({
                        'file': await MultipartFile.fromFile(
                            _imageFile!.path,
                            filename: "image")
                      }),
                      // response = await UploadFiles().uploadImage(formData),
                      setState(() {
                        isLoading = false;
                      }),
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ImagePlaceholder(bytes: response.data)),
                      )
                    }
                  else
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Image not selected')),
                      ),
                    }
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget uploadImageButton(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
          margin: const EdgeInsets.only(
              top: 30, left: 20.0, right: 20.0, bottom: 20.0),
          child: ElevatedButton(
            onPressed: () {},
            child: const Text(
              "Upload Image",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
