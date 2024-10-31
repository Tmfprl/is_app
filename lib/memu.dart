import 'package:flutter/material.dart';
import 'package:is_app/before/logInPage.dart';
import 'package:is_app/ingredientListScan/imageModule.dart';
import 'package:is_app/before/signup.dart';
import 'package:is_app/user/userInfo.dart';
import 'package:is_app/user/userAllergyData.dart';
import 'package:is_app/user/settingsScreen.dart';


///  Main Menu Page 
/// 
/// funtion 
/// : navigate to user infomation setting page - SettingsScreen.dart
/// : navigate to ingerdient scan page - CameraPage.dart
/// : navigate to user allergy list page - userAllergyData.dart
/// 
/// update history 
/// : 2024.10.31_add code info

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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // 여기에 페이지 전환만 설정
                  Navigator.push(
                    context,
                    // CropImagePage로 이동만 설정
                    MaterialPageRoute(builder: (context) => CameraPage()),
                  );
                },
                child: Text('Scan (API 호출 테스트 중)'),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context, 
              //       MaterialPageRoute(builder: (context) => UserInfo()),
              //     );
              //   },
              //   child: Text('User Info (회원가입 페이지)'),
              // ),
              ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => userAllergyData()), // 이동할 페이지를 지정합니다.
                );
              },
              child: Text('나의 알러지 데이터'),
            ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
                child: Text('회원 로그인 관리'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
