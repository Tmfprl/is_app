import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart'; 
import 'package:camera/camera.dart';
import 'package:is_app/imageModule.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraPage(),
    );
  }

  
}