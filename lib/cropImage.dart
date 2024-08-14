import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:is_app/imageModule.dart';

class cropimagePage extends StatefulWidget {
  final CroppedFile cropImage;
  const cropimagePage({super.key, required this.cropImage});
  

  @override
  State<cropimagePage> createState() => _cropimagePageState();
}

class _cropimagePageState extends State<cropimagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cropped Image'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: InteractiveViewer(
              child: Image(
            image: FileImage(
              File(widget.cropImage.path),
            ),
          )),
        ),
      ),
    );
  }
}