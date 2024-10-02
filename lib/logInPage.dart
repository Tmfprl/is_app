import 'package:flutter/material.dart';
import 'package:is_app/config/DBConnect.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:is_app/memu.dart';  // 메인 메뉴 페이지
import 'package:is_app/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _storageService = FlutterSecureStorage();
  final _databaseService = DatabaseService();

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final isValid = await _databaseService.validateUser(username, password);

     
    if (isValid) {
      await _storageService.write(key: 'ID', value: username);
      await _storageService.write(key: 'PW', value: password);

      // 로그인 성공 후 메인 메뉴로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainMenu()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password.')),
      );
    }
  }
  
  //signup module
  Future<void> _navigateToSignup() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SingupPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              onPressed: _login,
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: _navigateToSignup,
              child: Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }
}
