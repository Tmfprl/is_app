import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:is_app/common/cropImage.dart';
import 'package:is_app/config/DBConnect.dart';
import 'package:is_app/config/StorageService.dart';
import 'package:is_app/ingredientListScan/ViewIngredientInfo.dart';

/// ingredient scan main funtion
///
/// @author : 박경은
///
/// method 
/// : pickImage()
/// : _showIngredientTypeDialog()
/// : _fetchAllIngredientInfo()
/// : fetchIngredientInfo()
/// : _processExtractedText()
/// : cropImages()
/// : _buildButton()
///
/// update history 
/// : 2024.10.31_add code info
///

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});
  
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  // final _storageService = StorageService();
  final _databaseService = DatabaseService();
  XFile? image;
  CroppedFile? croppedFile;
  final ImagePicker picker = ImagePicker();
  String? extractedText;
  List<String> ingredients = []; 
  String? selectedIngredientInfo; // 선택된 성분 정보 저장
  String? selectedTable; // 선택된 성분표 종류를 저장할 변수

  // 이미지 선택 및 텍스트 추출 후 카테고리 선택
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
                // 텍스트 추출 후 성분 리스트 생성
              _processExtractedText(extractedText!, 'cosmetic'); // 임의로 'cosmetic' 카테고리 지정
            
                // 텍스트 추출 후 카테고리 선택
                _showIngredientTypeDialog(ingredients.first); // 카테고리 선택 팝업 호출
              },
            ),
          ),
        );
      }
    } catch (e) {
      print('Error picking image: $e'); // 에러 핸들링
    }
  }

  // 카테고리 선택 다이얼로그
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
                  Navigator.pop(context); // 다이얼로그 닫기
                  setState(() {
                    selectedTable = 'cosmetic_ingredient'; // 선택한 성분표 종류
                  });
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const ViewInfo()),
                  // );
                },
                child: Text('화장품 성분표'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // 다이얼로그 닫기
                  setState(() {
                    selectedTable = 'medical_items'; // 선택한 성분표 종류
                  });
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const ViewInfo()),
                  // );
                },
                child: Text('의약품 성분표'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // 다이얼로그 닫기
                  setState(() {
                    selectedTable = 'chemical_ingredient'; // 선택한 성분표 종류
                  });
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const ViewInfo()),
                  // );
                },
                child: Text('화학약품 성분표'),
              ),
            ],
          ),
          
        );
      },
    );
      if (selectedType != null) {
      // 선택된 성분표 종류를 가지고 메인 화면으로 돌아가기
      fetchIngredientInfo(selectedType);
    }
  }


  // 선택한 카테고리에 따라 성분 정보를 가져오는 함수
  Future<void> _fetchAllIngredientInfo(String ingredient, tableName) async {
    for (String ingredient in ingredients) {
      await _fetchAllIngredientInfo(ingredient.trim(), tableName); // 선택된 카테고리에 맞게 조회
    }
  }

  // DB에서 성분 정보 조회 (카테고리별로 다른 테이블 조회)
  Future<void> fetchIngredientInfo(String ingredient) async {
    if (selectedTable != null) {
      var ingredientInfo = await _databaseService.getIngredientInfoFromDB(ingredient.trim(), selectedTable!);

      if (ingredientInfo != null) {
        setState(() {
          selectedIngredientInfo =  ingredientInfo; // 성분 정보가 있을 때 반환  
        });
      } else {
        setState(() {
          selectedIngredientInfo =  "해당 성분에 대한 정보가 없습니다."; // 성분 정보가 없을 때 메시지 반환
        });
      }
    } else {
      setState(() {
          selectedIngredientInfo =  "성분표 종류를 먼저 선택하세요."; // 선택된 테이블이 없는 경우 메시지 반환
        });
    }
  }
  

  // 성분 텍스트를 처리하는 함수
  void _processExtractedText(String tableName, String columnName) {
    // 필터링할 단어 목록 정의 (제거하고자 하는 단어들)
    List<String> wordsToExclude = ['전성분', '보존제', '기타물질', '양쪽성이온계', '음이온계', '사용방법', '4 ppm'];

    // "전성분"과 다른 불필요한 단어들을 제거
    String cleanedText = extractedText ?? '';

    for (String word in wordsToExclude) {
      cleanedText = cleanedText.replaceAll(RegExp('$word[\s]*', caseSensitive: false), '');
    }

    // 줄바꿈 및 공백 정리
    cleanedText = cleanedText
        .replaceAll(RegExp(r'[\n\r\t]'), '')  // 줄바꿈과 탭을 공백으로 변환
        .replaceAll(RegExp(r'\s+'), ' ')  // 여러 개의 공백을 하나로 변환
        .replaceAll('[', '') // '['를 '대체할 문자1'로
        .replaceAll(']', '') // ']'를 '대체할 문자2'로
        .replaceAll('1,', '') // '1'을 '대체할 문자3'로
        .replaceAll(':', ', ')
        .replaceAll('•', '')
        .replaceAll('·', ', ')
        .replaceAll('.', ', ')
        .replaceAll('(', ', ')
        .replaceAll(')', ', ')
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

  // 알러지 체크하고 다이얼로그를 띄우는 메소드
  void _checkAndNotifyBeforeButton(List<String> ingredient)async {
    // 사용자의 알러지 정보 조회을 위한 아이디 가져오기
    // String? userId = await _storageService.getUserInfo('usr_id');
    print(ingredient);

    List<String> allergies = await _databaseService.getUserAllergies(ingredient);
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) { // dialogContext 사용
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
                Navigator.of(dialogContext).pop(); // 다이얼로그 닫기
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
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
        title: Text('Ingrdient Search'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30, width: double.infinity),
          _buildButton(),
          const SizedBox(height: 10),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: 350,
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  hintText: '검색',
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
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _checkAndNotifyBeforeButton(ingredients), // 알러지 성분 확인 버튼
            child: Text('check my allergy'),
          ),
          const SizedBox(height: 20),
            Expanded(
              child: ingredients.isNotEmpty
                  ? ListView.builder(
                      itemCount: ingredients.length,
                      itemBuilder: (context, index) {
                        // 공백이 아닌 경우에만 버튼 생성
                        if (ingredients[index].trim().isNotEmpty) {
                          return ElevatedButton(
                            onPressed: () {
                              fetchIngredientInfo(ingredients[index]);
                            },
                            child: Text(
                              ingredients[index] == "2-헥산다이올" 
                                ? "1, 2-헥산다이올"  // 조건이 맞으면 "1,2-헥산다이올" 버튼을 생성
                                : ingredients[index], // 조건이 아니라면 원래 성분명 사용 
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                          
                        } else {
                          // 공백 성분명을 건너뛰기 위해 빈 SizedBox 반환
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




