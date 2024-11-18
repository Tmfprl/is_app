import 'package:flutter/material.dart';
import 'package:is_app/config/DBConnect.dart';

class ViewInfo extends StatefulWidget {
  final String medicineName; // 검색된 의약품 이름

  const ViewInfo({Key? key, required this.medicineName})
      : super(key: key);

  @override
  _MedicineInfoPageState createState() => _MedicineInfoPageState();
}

class _MedicineInfoPageState extends State<ViewInfo> {
  // 질문 항목
  final List<Map<String, String>> questions = [
    {"efcyQesitm": "이 약의 효능은 무엇입니까?"},
    {"useMethodQesitm": "이 약은 어떻게 사용합니까?"},
    {"atpnWarnQesitm": "이 약을 사용하기 전에 반드시 알아야 할 내용은 무엇입니까?"},
    {"atpnQesitm": "이 약의 사용상 주의사항은 무엇입니까?"},
    {"intrcQesitm": "이 약을 사용하는 동안 주의해야 할 약 또는 음식은 무엇입니까?"},
    {"seQesitm": "이 약은 어떤 이상반응이 나타날 수 있습니까?"},
    {"depositMethodQesitm": "이 약은 어떻게 보관해야 합니까?"}
  ];
  final _databaseService = DatabaseService();

  // 데이터 저장
  Map<String, String> medicineData = {};

  @override
  void initState() {
    super.initState();
    _fetchMedicineData();
  }

  // DB에서 데이터를 가져오는 메서드
  Future<void> _fetchMedicineData() async {
    try {
      for (var question in questions) {
        String columnName = question.keys.first;
        String? data = await _databaseService.medisenInfo(columnName, widget.medicineName);
        setState(() {
          print(columnName);
          print(widget.medicineName);
          medicineData[columnName] = data ?? "정보가 없습니다.";
        });
      }
    } catch (e) {
      print("Error fetching medicine info: $e");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.medicineName} 정보'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          String columnName = questions[index].keys.first;
          String question = questions[index].values.first;
          String answer = medicineData[columnName] ?? "로딩 중...";

          return ExpansionTile(
            title: Text(
              question,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            children: <Widget>[
              Divider(height: 1, color: Colors.grey.shade300),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  answer,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
