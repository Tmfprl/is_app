import 'package:flutter/material.dart';
import 'package:is_app/memu.dart';
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
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pushReplacement(
        //       context,
        //        MaterialPageRoute(builder: (context) => MainMenu()),
        //        );
        //    },
        // ),
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
            ],
          ),
        ),
      ),
    );
  }
}
