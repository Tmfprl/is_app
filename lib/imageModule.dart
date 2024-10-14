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
  String? selectedIngredientInfo; // 선택된 성분 정보 저장

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

  // DB에서 개별 성분 정보를 가져오는 함수
  Future<void> fetchIngredientInfo(String ingredient) async {
    // DB에서 성분 정보 가져오기
    var ingredientInfo = await _databaseService.getIngredientInfoFromDB(ingredient.trim());

    if (ingredientInfo != null) {
      setState(() {
        selectedIngredientInfo = ingredientInfo;
      });
    } else {
      setState(() {
        selectedIngredientInfo = "해당 성분에 대한 정보가 없습니다.";
      });
    }
  }

  // 성분 텍스트를 처리하고 DB에서 성분 정보를 가져오는 함수
  void _processExtractedText(String extractedText) {
    // 필터링할 단어 목록 정의 (제거하고자 하는 단어들)
    List<String> wordsToExclude = ['전성분'];

    // "전성분"과 다른 불필요한 단어들을 제거
    String cleanedText = extractedText;

    for (String word in wordsToExclude) {
      cleanedText = cleanedText.replaceAll(RegExp('$word[\s]*', caseSensitive: false), '');
    }

    // 줄바꿈 및 공백 정리
    cleanedText = cleanedText
        .replaceAll(RegExp(r'[\n\r\t]'), ' ')  // 줄바꿈과 탭을 공백으로 변환
        .replaceAll(RegExp(r'\s+'), ' ')  // 여러 개의 공백을 하나로 변환
        .trim();

    // 성분을 콤마와 공백으로 분리하여 리스트로 만듦
    ingredients = cleanedText.split(RegExp(r',\s*'));
    print("Extracted Ingredients: $ingredients");

    // 각 성분의 정보를 데이터베이스에서 조회
    for (String ingredient in ingredients) {
      fetchIngredientInfo(ingredient.trim()); // 각 성분명에 대해 정보 조회
    }
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
        title: Text('Camera module'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 50, width: double.infinity),
          _buildButton(),
          const SizedBox(height: 30),
          Expanded(
            child: ingredients.isNotEmpty
                ? ListView.builder(
                    itemCount: ingredients.length,
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        onPressed: () {
                          fetchIngredientInfo(ingredients[index]); // 개별 성분명(문자열)을 전달
                        },
                        child: Text(
                          ingredients[index],
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    },
                  )
                : Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color(0xffe2e5e8),
                    child: const Text(
                      "No ingredients extracted",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: const Color(0xffe2e5e8),
            child: selectedIngredientInfo != null
                ? Text(
                    selectedIngredientInfo!,
                    style: TextStyle(fontSize: 16),
                  )
                : const Text(
                    "성분 정보를 선택하세요.",
                    style: TextStyle(fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }
}
