import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:is_app/cropImage.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});
  
  
  
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {

  XFile? image;
  CroppedFile? croppedFile;
  final ImagePicker picker = ImagePicker();
  String? extractedText;

  void pickImage(bool pickGalleryImage) async {
    if (pickGalleryImage == true) {
      image = await picker.pickImage(source: ImageSource.gallery);
    } else {
      image = await picker.pickImage(source: ImageSource.camera);
    }

    if (image != null) {
      final croppedImage = await cropImages(image);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => cropimagePage(
                cropImage: croppedImage,
                onTextExtracted: (text) {
                  setState(() {
                    extractedText = text;
                  });
                  Navigator.pop(context); // 텍스트 추출 후 메인 화면으로 돌아가기
                },
              )),
        ),
      );
    }
  }

  Future<CroppedFile> cropImages(XFile? image) async{
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      uiSettings: [
        AndroidUiSettings(
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
      ],
    );
    return croppedFile!;
  }

  
  _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
          pickImage(false);
          }, 
        child: Text('camera')
        ),
        SizedBox(width: 30),
        ElevatedButton(
          onPressed: () {
            pickImage(true);
          }, 
          child: Text('gallery'))
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Camera module'),
      centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 50, width: double.infinity),
          _buildButton(),
          const SizedBox(height: 30),
          extractedText != null
            ? Container(
              padding: const EdgeInsets.all(8.0),
              color: const Color(0xffe2e5e8),
              child: Text(
                extractedText!,
                style: TextStyle(fontSize: 16),
              ),
            ) 
            : Container(
              padding: const EdgeInsets.all(8.0),
              color: Color(0xffe2e5e8),
              child: const Text(
                "No text extracted",
                style: TextStyle(fontSize: 16),
              ),
            )
        ],
      ),
    );
  }
  



}