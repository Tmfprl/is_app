import 'package:flutter/material.dart';
import 'package:is_app/config/DBConnect.dart';
import 'package:is_app/before/logInPage.dart';

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

      try {
        await _databaseService.validateUser(id, pw);

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 타이틀 Section (회원가입 -> Sign up으로 변경, 볼드체로 수정)
            SizedBox(height: 50),
            Row(
              children: [
                Text(
                  '    Sign up',  // '회원가입'을 'Sign up'으로 변경
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

            // 회원가입 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 회원가입 버튼
                Expanded(
                  child: ElevatedButton(
                    onPressed: _signup,
                    child: Text(
                      'Sign up',
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
              ],
            ),

            SizedBox(height: 20), // 아래쪽 여백
          ],
        ),
      ),
    );
  }
}
