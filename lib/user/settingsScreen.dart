import 'package:flutter/material.dart';
import 'package:is_app/memu.dart';
import '../config/StorageService.dart';
import 'package:is_app/before/logInPage.dart';

/// show user information & Log out
/// 
/// @author : 박경은
/// 
/// function 
/// : user infomation
/// : log out
/// 
/// update hitory

///  : 2024.10.31_add code info

class SettingsScreen extends StatelessWidget {
  final _storageService = StorageService();

  Future<void> _logout(BuildContext context) async {
    await _storageService.deleteUserInfo('ID');
    await _storageService.deleteUserInfo('PW');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<void> _userInfo(BuildContext content) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Info',
          style: TextStyle(
            color: Color.fromARGB(255, 212, 151, 171),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromARGB(255, 212, 151, 171)),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainMenu()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logout 버튼을 회원가입 페이지 스타일로 변경
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () => _logout(context),
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),  // 버튼 텍스트 색을 흰색으로 설정
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 157, 174, 167),  // 버튼 배경색
                  minimumSize: Size(200, 50),  // 버튼 가로 길이를 200으로 설정
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),  // 둥근 모서리
                  ),
                ),
              ),

              SizedBox(height: 20), // 여백 추가
            ],
          ),
        ),
      ),
    );
  }
}
