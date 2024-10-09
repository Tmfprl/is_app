import 'package:flutter/material.dart';
import 'storage_service.dart';
import 'package:is_app/logInPage.dart';

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

  Future<void> _userInfo(BuildContext content) async {

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('UserInfo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _logout(context),
                child: Text('Logout'),
              ),
              ElevatedButton(
                onPressed: () => _logout(context),
                child: Text('My Infomation(아직)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
