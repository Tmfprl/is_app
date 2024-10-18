import 'package:flutter/material.dart';
import 'package:is_app/splashscreen.dart'; // SplashScreen을 가져옵니다.
import 'package:is_app/config/DBConnect.dart';
import 'package:is_app/memu.dart';
import 'package:is_app/logInPage.dart'; // LoginScreen을 가져옵니다.

void main() {
  DatabaseService();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // 스플래시 화면으로 변경
    );
  }
}
