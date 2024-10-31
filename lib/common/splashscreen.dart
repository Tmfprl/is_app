import 'package:flutter/material.dart';
import 'package:is_app/main.dart'; // LoginScreen을 가져옵니다.
import 'package:is_app/logInPage.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 3초 후에 로그인 화면으로 이동
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()), // LoginScreen으로 변경
      );
    });

    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/IS_logo.png', // 로딩 이미지
          fit: BoxFit.cover, // 이미지를 화면에 꽉 차게
          width: double.infinity, // 너비를 화면 전체로
          height: double.infinity, // 높이를 화면 전체로
        ),
      ),
    );
  }
}
