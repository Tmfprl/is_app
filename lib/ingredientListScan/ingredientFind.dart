import 'package:flutter/material.dart';
import 'package:is_app/memu.dart';

/// search medisen info 
/// 
/// @author : 박경은
///
/// funtion
///
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});
/// select mediItem table for search medical items _ select by medisen name 
/// search result show 
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Ingredientfind extends StatelessWidget {
  const Ingredientfind({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('약품 검색')),
      body: Center(
        child: Text('여기서 약품 검색 기능을 구현합니다.'),
      ),
    );
  }
}
