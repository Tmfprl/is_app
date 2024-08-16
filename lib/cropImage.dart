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

      final apiKey = 'AIzaSyDeiGDvIwXCbOZGHk3xwx1gRY9WsYts51E'; // API 키를 환경 변수나 안전한 곳에서 관리해야 합니다.
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

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ya29.a0AcM612xvEPa-xTCiItMaVzfxn5aydyBZO46UGF6XDYBDIQfqoQnU7TATLzoXmn7D-TKcCvJtv-3sFCrki6ARAlsH-7XQ46R7m5RPs8OveTumLYtUNDPegduODTzakMbHQyt0H0XDjgzXPaLSuLj0hZ5DoVRdJHCewsj7yx-9WtrfaQaCgYKAZoSARASFQHGX2MiEmhWmTK2MB01bFACrH066g0181", // OAuth 2.0 인증 토큰
          "x-goog-user-project": "potato-431204",
          "Content-Type": "application/json; charset=utf-8"
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Ensure that 'fullTextAnnotation' exists in the response
        final text = jsonResponse['responses'][0]['fullTextAnnotation']?['text'] ?? 'No text found.';
        setState(() {
          _ocrText = text ?? 'Failed to extract text.';
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
