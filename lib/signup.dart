//회원가입 페이지

import 'package:flutter/material.dart';
import 'package:is_app/config/DBConnect.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:is_app/logInPage.dart'; 

class signupPage extends StatefulWidget {
  const signupPage({super.key});

  @override
  State<signupPage> createState() => _signupPageState();
}

class _signupPageState extends State<signupPage> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _databaseService = DatabaseService();
  
  Future<void> _signup() async {
  final id = _usernameController.text;
  final pw = _passwordController.text;

  try {
    await _databaseService.insertUser(id, pw);

    // Verify if the user was inserted
    bool userExists = await _databaseService.checkUserExists(id);
    if (userExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign up successful!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign up failed. Please try again.')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An error occurred: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign up')),
      body: Padding(padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'ID'),
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _signup, 
            child: Text('Sign up'),
          ),
        ],
      ),
      ),
    );
  }
}
