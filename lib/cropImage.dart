import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:is_app/imageModule.dart';

class CropImagePage extends StatefulWidget {
  final CroppedFile cropImage;
  final Function(String) onTextExtracted; // 텍스트를 메인화면으로 전달하기 위한 콜백 함수

  const CropImagePage({super.key, required this.cropImage, required this.onTextExtracted});
  
  @override
  State<CropImagePage> createState() => _CropImagePageState();
}

class _CropImagePageState extends State<CropImagePage> {
  String? _ocrText;

  // API 키를 여기에 입력하세요.
  final String apiKey = 'AIzaSyDeiGDvIwXCbOZGHk3xwx1gRY9WsYts51E'; // 본인의 API 키로 교체

  Future<void> _extractTextFromImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      print("Image bytes loaded: ${bytes.length} bytes"); // 이미지 로드 확인
      final base64Image = base64Encode(bytes);
      print("Base64 encoded image created");

      // API 키를 URL의 파라미터로 추가
      final url = "https://vision.googleapis.com/v1/images:annotate?key=$apiKey";

      final body = jsonEncode({
        "requests": [
          {
            "image": {
              "content": base64Image,
            },
            "features": [
              {
                "type": "TEXT_DETECTION",
                "maxResults": 1
              }
            ]
          }
        ]
      });
      print("Request body created: $body"); // 요청 본문 확인

      // API 호출
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json; charset=utf-8"
        },
        body: body,
      );

      print("Response status: ${response.statusCode}"); // 응답 상태 코드 확인
      print("Response body: ${response.body}"); // 응답 내용 확인

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("API Response: $jsonResponse");

        // 응답에서 추출한 텍스트 가져오기
        final text = jsonResponse['responses'][0]['fullTextAnnotation']?['text'] ?? 'No text found.';

        setState(() {
          _ocrText = text;
        });
      } else {
        final errorResponse = json.decode(response.body);
        setState(() {
          _ocrText = 'Error: ${errorResponse['error']['message']}';
        });
        print("Error response: ${errorResponse['error']['message']}"); // 에러 메시지 확인
      }
    } catch (e) {
      setState(() {
        _ocrText = 'Failed to extract text. Error: $e';
      });
      print("Exception: $e"); // 예외 확인
    }
  }

  @override
  void initState() {
    super.initState();
    _extractTextFromImage(File(widget.cropImage.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cropped Image'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: InteractiveViewer(
                child: Image.file(File(widget.cropImage.path)),
              ),
            ),
            const SizedBox(height: 20),
            _ocrText != null
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _ocrText!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              ) : const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
