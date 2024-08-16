import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:is_app/imageModule.dart';

class cropimagePage extends StatefulWidget {
  final CroppedFile cropImage;
  final Function(String) onTextExtracted; // 텍스트를 메인화면으로 전달하기 위한 콜백 함수
  const cropimagePage({super.key, required this.cropImage, required this.onTextExtracted});
  
  @override
  State<cropimagePage> createState() => _cropimagePageState();
}

class _cropimagePageState extends State<cropimagePage> {
  String? _ocrText;

  Future<void> _extractTextFromImage(File imageFile) async{
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    final apiKey = 'AIzaSyDeiGDvIwXCbOZGHk3xwx1gRY9WsYts51E0';
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
            }
          ]
        }
      ]
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {
      "Authorization": "ya29.a0AcM612xqO3ycZF4KzV7qoVq0ZqPPBPWQsxeZ-DTs6gYM8xzbA72vKHodxEh_2yHj3Ozjl_1M7Hm5_IrPsxgGbob8LwVSXdGY6l6kHaumh37lVojb7el2r5R50kJOrH1GGaCgNGvspc1Zzag7CZz7Z-7I5a7hBRt6UxSQGO6vTylzRwaCgYKAbISARASFQHGX2MiitB2ZeuH-1ci5VYXfeDMWQ0181", // gcloud auth print-access-token으로 얻은 토큰 사용
      "x-goog-user-project": "potato-431204",
      "Content-Type": "application/json; charset=utf-8"
    },
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final text = jsonResponse['responses'][0]['fullTextAnnotation']['text'];

      setState(() {
        _ocrText = text ?? 'Failed to extract text.';
      });
      
    } else {
      setState(() {
      _ocrText = 'Failed to extract text.';
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
                child: Image(
                  image: FileImage(
                    File(widget.cropImage.path)
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _ocrText != null
              ?Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _ocrText!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              ) : const CircularProgressIndicator(),
          ],
        )
      ),
    );
  }
}