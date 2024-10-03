import 'package:flutter/material.dart';
import 'package:is_app/logInPage.dart';
import 'package:is_app/imageModule.dart';
import 'package:is_app/signup.dart';

// 메뉴 페이지
class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Main Menu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // 여기에 페이지 전환만 설정
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraPage()),
                );
              },
              child: Text('Scan (API 호출 테스트 중)'),
            ),
            ElevatedButton(
              onPressed: () {
                // CropImagePage로 이동만 설정
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => signupPage()),
                );
              },
              child: Text('User Info (회원가입 페이지)'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (context) => signupPage()),
                );
              },
              child: Text('회원 로그인 관리'),
            ),
          ],
        ),
      ),
    );
  }
}
