import 'package:flutter/material.dart';
import 'package:is_app/logInPage.dart';


//메뉴페이지
class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainMenu()),
                );
              },
              child: Text('Scan (API 호출 테스트 중)'),
            ),
             ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('userinfo (아직 없음_회원가입페이지)'),
            ),
             ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('화원로그인 관리'),
            ),
          ],
        ),
      ),
    );
  }

}