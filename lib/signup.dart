//회원가입 페이지

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:is_app/config/DBConnect.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:is_app/logInPage.dart'; 

class SingupPage extends StatefulWidget {
  const SingupPage({super.key});

  @override
  State<SingupPage> createState() => _SingupPageState();
}

class _SingupPageState extends State<SingupPage> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _databaseService = DatabaseService();

  Future<void> _singup() async {
    final ID = _usernameController.text;
    final PW = _passwordController.text;

    try {
      await _databaseService.insertUser(ID, PW);
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => LoginScreen()),
        );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sing up Failed')),
      );
    }
  
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sing up')),
      body: Padding(padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'ID'),
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Psaaword'),
            obscureText: true,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _singup, 
            child: Text('Sign up'),
          ),
        ],
      ),
      ),
    );
  }
}