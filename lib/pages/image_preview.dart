import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImagePlaceholder extends StatefulWidget {
  final Uint8List bytes;
  const ImagePlaceholder({Key? key, required this.bytes}) : super(key: key);

  @override
  State<ImagePlaceholder> createState() => _ImagePlaceholderState();
}

class _ImagePlaceholderState extends State<ImagePlaceholder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.memory(widget.bytes),
        ),
      ),
    );
  }
}
