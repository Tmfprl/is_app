import 'package:flutter/material.dart';
import 'package:is_app/config/DBConnect.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:is_app/config/StorageService.dart';
import 'package:is_app/memu.dart'; // 메인 메뉴 페이지
import 'package:is_app/before/signup.dart';

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
  final _storage = StorageService();
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

// 회원가입 페이지로 넘어가는 모듈
  Future<void> _navigateToSignup() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => signupPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 타이틀 Section (로그인 -> Login으로 변경, 볼드체로 수정)
            SizedBox(height: 50),
            Row(
              children: [
                Text(
                  '    Login',  // '로그인'을 'Login'으로 변경
                  style: TextStyle(
                    color: Color.fromARGB(255, 212, 151, 171),  // 텍스트 색을 검정색으로 설정
                    fontSize: 25,
                    
                    fontWeight: FontWeight.bold,  // 볼드체로 설정
                  ),
                ),
              ],
            ),

            SizedBox(height: 5),


            Divider(
              color: Color.fromARGB(255, 212, 151, 171),  // 선 색상 설정
              thickness: 1,  // 선 두께 설정
              indent: 30, // 왼쪽 여백
              endIndent: 30, // 오른쪽 여백
            ),

            SizedBox(height: 40), // 더 많은 여백 추가하여 입력란을 아래로 내림

            // ID TextField
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: 350,
                height: 40,
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            SizedBox(height: 16), // ID와 Password 입력란 사이 여백 추가

            // Password TextField
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: 350,
                height: 40,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Spacer 위젯을 이용하여 버튼을 아래쪽으로 배치
            Spacer(),

            // 로그인 및 회원가입 버튼을 가로로 정렬 (Row 위젯 사용)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 로그인 버튼
                Expanded(
                  child: ElevatedButton(
                    onPressed: _login,
                    child: Text(
                      '로그인',
                      style: TextStyle(color: Colors.white), // 버튼 텍스트 색을 흰색으로 변경
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 212, 151, 171),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16), // 버튼 간격
                // 회원가입 버튼
                Expanded(
                  child: ElevatedButton(
                    onPressed: _navigateToSignup,
                    child: Text(
                      '회원가입',
                      style: TextStyle(color: Colors.white), // 버튼 텍스트 색을 흰색으로 변경
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 157, 174, 167),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // 아래쪽 여백
          ],
        ),
      ),
    );
  }
}
