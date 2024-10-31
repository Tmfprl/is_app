import 'package:flutter/material.dart';

class ViewInfo extends StatelessWidget {
  final String ingredient;
  final String selectedTable;

  const ViewInfo({
    Key? key,
    required this.ingredient,
    required this.selectedTable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 선택된 성분과 테이블 정보를 이용하여 데이터를 가져오고 표시합니다.
    return Scaffold(
      appBar: AppBar(
        title: Text('성분 정보'),
      ),
      body: Center(
        child: Text('선택한 성분: $ingredient\n선택한 테이블: $selectedTable'),
      ),
    );
  }
}
