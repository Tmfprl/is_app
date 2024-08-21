import 'package:flutter/material.dart';
import 'storage_service.dart';

class SettingsScreen extends StatelessWidget {
  final _storageService = StorageService();

  Future<void> _logout(BuildContext context) async {
    await _storageService.deleteUserInfo('username');
    await _storageService.deleteUserInfo('password');
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
