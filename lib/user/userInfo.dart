import 'package:flutter/material.dart';
import 'package:is_app/memu.dart';

class UserInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserInfo();
 

}

class _UserInfo extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Info')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainMenu())
            ); // 이전 페이지로 돌아가기
          },
          child: Text('Back to Menu'),
        ),
      ),
    );
  }
}