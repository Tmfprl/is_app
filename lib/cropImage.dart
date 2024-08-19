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

  Future<void> _extractTextFromImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // API Key와 OAuth 2.0 토큰은 동시에 사용하지 않습니다.
      // 여기서는 OAuth 2.0 토큰을 사용하여 API 요청을 수행합니다.
      final apiKey = 'AIzaSyDeiGDvIwXCbOZGHk3xwx1gRY9WsYts51E';  // 만약 API Key를 사용할 경우
      final accessToken = 'ya29.a0AcM612zutLC5nkNGzNHr1g9_Vr-dUUcJoHoHUUTjVVW6A4RMianihixTaGoFx0B_LhOj-ab3xnw9fwgobXDMDXR_grwD7hPJIzlKrbEmaS8BsSQrpa-g1y2oTH9jjeXdgYkH06fApGPNAV3SeLSLGC-s5wOy3-2Xy_2HHplR7bx_KgaCgYKAZwSARASFQHGX2MiEj4vSAUgiGid1i6l5skKQw0181';  // OAuth 2.0 토큰

      // API 호출 URL, OAuth 2.0 사용 시 key 파라미터 제외
      final url = "https://vision.googleapis.com/v1/images:annotate";

      // 요청 본문 설정
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

      // POST 요청 수행
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $accessToken", // OAuth 2.0 인증 토큰
          "x-goog-user-project": "potato-431204", // Google Cloud 프로젝트 ID
          "Content-Type": "application/json; charset=utf-8"
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Ensure that 'fullTextAnnotation' exists in the response
        final text = jsonResponse['responses'][0]['fullTextAnnotation']?['text'] ?? 'No text found.';
        setState(() {
          _ocrText = text;
        });
      } else {
        final errorResponse = json.decode(response.body);
        setState(() {
          _ocrText = 'Error: ${errorResponse['error']['message']}';
        });
      }
    } catch (e) {
      setState(() {
        _ocrText = 'Failed to extract text. Error: $e';
      });
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
