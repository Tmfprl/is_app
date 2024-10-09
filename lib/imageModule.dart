import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:is_app/cropImage.dart';
import 'package:is_app/config/DBConnect.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});
  
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final _databaseService = DatabaseService();
  XFile? image;
  CroppedFile? croppedFile;
  final ImagePicker picker = ImagePicker();
  String? extractedText;
  List<String> ingredients = []; 

  void pickImage(bool pickGalleryImage) async {
    try {
      image = pickGalleryImage
          ? await picker.pickImage(source: ImageSource.gallery)
          : await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        final croppedImage = await cropImages(image);
        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CropImagePage(
              cropImage: croppedImage,
              onTextExtracted: (text) {
                setState(() {
                  extractedText = text;
                });
                _processExtractedText(extractedText!); // 텍스트 처리 함수 호출
                Navigator.pop(context); // 텍스트 추출 후 메인 화면으로 돌아가기
              },
            ),
          ),
        );
      }
    } catch (e) {
      print('Error picking image: $e'); // 에러 핸들링
    }
  }

  Future<void> fetchIngredientInfo(List<String> ingredients) async {
    for (String ingredient in ingredients) {
      // DB에서 성분 정보 가져오기
      var ingredientInfo = await _databaseService.getIngredientInfoFromDB(ingredient.trim());

      if (ingredientInfo != null) {
        print("성분명: $ingredient, 정보: $ingredientInfo");
      } else {
        print("해당 성분에 대한 정보가 없습니다: $ingredient");
      }
    }
  }

  // 성분 텍스트를 처리하고 DB에서 성분 정보를 가져오는 함수
  void _processExtractedText(String extractedText) {
    // 성분을 콤마와 공백으로 분리하여 리스트로 만듦
    ingredients = extractedText.split(RegExp(r',\s*'));
    print("Extracted Ingredients: $ingredients");

    // 각 성분의 정보를 데이터베이스에서 조회
    fetchIngredientInfo(ingredients);
  }

  Future<CroppedFile> cropImages(XFile? image) async {
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
          onPressed: () => pickImage(false),
          child: Text('Camera'),
        ),
        SizedBox(width: 30),
        ElevatedButton(
          onPressed: () => pickImage(true),
          child: Text('Gallery'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Module'),
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
                ),
          const SizedBox(height: 20),
          Expanded( // ListView로 감싸기
          child: ingredients.isNotEmpty
              ? ListView.builder(
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      color: const Color(0xffe2e5e8),
                      child: Text(
                        ingredients[index],
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  },
                )
              : Container(),
          )
        ],
      ),
    );
  }
}
