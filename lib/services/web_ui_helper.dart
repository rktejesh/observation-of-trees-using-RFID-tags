import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

List<PlatformUiSettings>? buildUiSettings(BuildContext context) {
  return [
    WebUiSettings(
      context: context,
      presentStyle: CropperPresentStyle.page,
      enableExif: true,
      enableZoom: true,
      showZoomer: true,
    ),
  ];
}