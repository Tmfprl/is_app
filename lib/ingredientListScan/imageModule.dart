import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:is_app/common/cropImage.dart';
import 'package:is_app/config/DBConnect.dart';
import 'package:is_app/config/StorageService.dart';
import 'package:is_app/ingredientListScan/ViewIngredientInfo.dart';

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
  String? selectedIngredientInfo;
  String? selectedTable;
  String search = '';

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
                _processExtractedText(extractedText!, 'cosmetic');
                _showIngredientTypeDialog(ingredients.first);
              },
            ),
          ),
        );
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _showIngredientTypeDialog(String ingredient) async {
    String? selectedType = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("성분표 종류를 선택하세요"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    selectedTable = 'cosmetic_ingredient';
                  });
                },
                child: Text('화장품 성분표'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    selectedTable = 'medical_items';
                  });
                },
                child: Text('의약품 성분표'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    selectedTable = 'chemical_ingredient';
                  });
                },
                child: Text('화학약품 성분표'),
              ),
            ],
          ),
        );
      },
    );
    if (selectedType != null) {
      fetchIngredientInfo(selectedType);
    }
  }

  Future<String> fetchIngredientInfo(String ingredient) async {
    if (selectedTable != null) {
      var ingredientInfo = await _databaseService.getIngredientInfoFromDB(ingredient.trim(), selectedTable!);

      if (ingredientInfo != null) {
        return ingredientInfo;
      } else {
        return "해당 성분에 대한 정보가 없습니다.";
      }
    } else {
      return "성분표 종류를 먼저 선택하세요.";
    }
  }

  void _processExtractedText(String tableName, String columnName) {
    List<String> wordsToExclude = ['전성분', '보존제', '기타물질', '양쪽성이온계', '음이온계', '사용방법', '4 ppm'];
    String cleanedText = extractedText ?? '';

    for (String word in wordsToExclude) {
      cleanedText = cleanedText.replaceAll(RegExp('$word[\s]*', caseSensitive: false), '');
    }

    cleanedText = cleanedText
        .replaceAll(RegExp(r'[\n\r\t]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('1,', '')
        .replaceAll(':', ', ')
        .replaceAll('•', '')
        .replaceAll('·', ', ')
        .replaceAll('.', ', ')
        .replaceAll('(', ', ')
        .replaceAll(')', ', ')
        .trim();

    ingredients = cleanedText.split(RegExp(r',\s*'));
    print("Extracted Ingredients: $ingredients");

    for (String ingredient in ingredients) {
      fetchIngredientInfo(ingredient.trim());
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

  void _checkAndNotifyBeforeButton(List<String> ingredient) async {
    List<String> allergies = await _databaseService.getUserAllergies(ingredient);
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('알러지 정보'),
          content: Text(
            allergies.isNotEmpty
              ? '나의 알러지 성분이 포함되어있습니다: ${allergies.join(', ')}'
              : '알러지 성분이 포함되어 있지 않습니다.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showIngredientInfoDialog(BuildContext context, String ingredientInfo) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('성분 정보'),
          content: Text(
            ingredientInfo.isNotEmpty
                ? ingredientInfo
                : "성분 정보를 선택하세요.",
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _filterIngredients(String inputSearch) {
    setState(() {
      search = inputSearch;
    });
  }

  _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => pickImage(false),
          child: Text('Camera',
          style: TextStyle(
            color: Colors.white,  // 글자 색을 흰색으로 설정
            fontSize: 16,          // 폰트 사이즈 설정
          ),),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 212, 151, 171),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        SizedBox(width: 30),
        ElevatedButton(
          onPressed: () => pickImage(true),
          child: Text('Gallery',
          style: TextStyle(
            color: Colors.white,  // 글자 색을 흰색으로 설정
            fontSize: 16,          // 폰트 사이즈 설정
          ),),                
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 212, 151, 171),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '성분표 스캔',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 212, 151, 171),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30, width: double.infinity),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  hintText: '성분명 검색',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
                style: TextStyle(fontSize: 16),
                textAlignVertical: TextAlignVertical.center,
                onChanged: _filterIngredients,
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _checkAndNotifyBeforeButton(ingredients),
            child: Text(
              'check my allergy',
              style: TextStyle(
                color: Colors.white,  // 글자 색을 흰색으로 설정
                fontSize: 16,          // 폰트 사이즈 설정
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 212, 151, 171), // 버튼 배경색
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // 버튼 테두리 둥글게
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildButton(),
          Expanded(
            child: ingredients.isNotEmpty
                ? ListView.builder(
                    itemCount: ingredients.length,
                    itemBuilder: (context, index) {
                      if (ingredients[index].trim().isNotEmpty &&
                          (search.isEmpty || ingredients[index].toLowerCase().contains(search.toLowerCase()))) {
                        return ElevatedButton(
                          onPressed: () async {
                            String ingredientInfo = await fetchIngredientInfo(ingredients[index]);
                            _showIngredientInfoDialog(context, ingredientInfo);
                          },
                          child: Text(
                            ingredients[index] == "2-헥산다이올" 
                              ? "1, 2-헥산다이올"
                              : ingredients[index],
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 212, 151, 171),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  )
                : Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      "성분 정보가 없습니다.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
