import 'package:flutter/material.dart';
import 'package:is_app/before/logInPage.dart';
import 'package:is_app/ingredientListScan/imageModule.dart';
import 'package:is_app/before/signup.dart';
import 'package:is_app/user/userInfo.dart';
import 'package:is_app/user/userAllergyData.dart';
import 'package:is_app/user/settingsScreen.dart';
import 'package:is_app/ingredientListScan/ingredientFind.dart';

///  Main Menu Page 
/// 
/// function 
/// : navigate to user information setting page - SettingsScreen.dart
/// : navigate to ingredient scan page - CameraPage.dart
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
      appBar: AppBar(
        title: Text(
          'Main Menu',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 212, 151, 171),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // 세로 중앙 정렬
            children: [
              // GridView로 버튼들을 격자 형식으로 배열
              GridView.count(
                shrinkWrap: true,  // GridView가 전체 화면을 차지하지 않도록 함
                crossAxisCount: 2,  // 2열로 배열
                crossAxisSpacing: 16.0,  // 열 사이의 간격
                mainAxisSpacing: 16.0,  // 행 사이의 간격
                childAspectRatio: 1,  // 버튼을 정사각형으로 만들기 위해 비율 1로 설정
                children: [
                  // 성분표 스캔 버튼
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CameraPage()),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/Scan_logo.png',
                          width: 50,  // 아이콘 크기
                          height: 50, // 아이콘 크기
                        ),
                        SizedBox(height: 30),
                        Text(
                          '성분표 스캔',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,  // 글씨 크기 조정
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 212, 151, 171),
                      fixedSize: Size(200, 200),  // 버튼 크기 설정 (200x200 정사각형)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),

                  // 나의 알러지 버튼
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => userAllergyData()),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning_amber_outlined,
                          size: 50,
                          color: Colors.white,
                        ),
                        SizedBox(height: 30),
                        Text(
                          '나의 알러지',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,  // 글씨 크기 조정
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 212, 151, 171),
                      fixedSize: Size(200, 200),  // 버튼 크기 설정 (200x200 정사각형)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),

                  // 약품 검색 버튼
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Ingredientfind()),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 50,
                          color: Colors.white,
                        ),
                        SizedBox(height: 30),
                        Text(
                          '약품 검색',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,  // 글씨 크기 조정
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 212, 151, 171),
                      fixedSize: Size(200, 200),  // 버튼 크기 설정 (200x200 정사각형)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),

                  // 설정 버튼
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsScreen()),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.settings,
                          size: 50,
                          color: Colors.white,
                        ),
                        SizedBox(height: 30),
                        Text(
                          '설정',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,  // 글씨 크기 조정
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 212, 151, 171),
                      fixedSize: Size(200, 200),  // 버튼 크기 설정 (200x200 정사각형)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
