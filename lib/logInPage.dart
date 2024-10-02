import 'package:flutter/material.dart';
import 'package:is_app/config/DBConnect.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:is_app/memu.dart'; // 메인 메뉴 페이지
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    final savedUsername = await _storageService.read(key: 'ID');
    final savedPassword = await _storageService.read(key: 'PW');

    if (savedUsername != null && savedPassword != null) {
      final isValid = await _databaseService.validateUser(savedUsername, savedPassword);
      if (isValid) {

        // 자동 로그인 성공 시 메인 메뉴로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainMenu()),
        );
      }
    }
  }

Future<void> _login() async {
  setState(() {
    _isLoading = true;
  });

  try {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // DB에 사용자 검증 요청
    final isValid = await _databaseService.validateUser(username, password);

     
    if (isValid) {
      await _storageService.write(key: 'ID', value: username);
      await _storageService.write(key: 'PW', value: password);

      // 로그인 성공 시 메인 메뉴로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainMenu()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password.')),
      );
    }
  } catch (e) {
    // 데이터베이스 연결 오류 처리
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to login. Please check your connection: $e')),
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

  Future<void> _navigateToSignup() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => signupPage()),
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
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
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
