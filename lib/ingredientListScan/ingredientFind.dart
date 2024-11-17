import 'package:flutter/material.dart';
import 'package:is_app/config/DBConnect.dart';
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
    return MaterialApp(
      home: MedicineSearchPage(),
    );
  }
}

class MedicineSearchPage extends StatefulWidget {
  @override
  _MedicineSearchPageState createState() => _MedicineSearchPageState();
}

class _MedicineSearchPageState extends State<MedicineSearchPage> {
  String searchQuery = ''; // 검색어
  List<String> allMedicines = []; // 모든 의약품 데이터
  List<String> searchResults = []; // 검색된 의약품 데이터
  final _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    fetchAllMedicines(); // 초기 데이터 로드(모든 약품 이름)
  }

  // 모든 의약품 데이터 로드
  Future<void> fetchAllMedicines() async {
    try {
      final medicines = await _databaseService.searchMedisen(''); // 빈 검색어로 전체 데이터 가져옴
      setState(() {
        allMedicines = medicines;
        searchResults = medicines; // 초기에는 전체 데이터 표시
      });
    } catch (error) {
      print('Error fetching all medicines: $error');
    }
  }

  // 검색 로직
  void searchMedicines(String query) async {
    setState(() {
      searchQuery = query;
    });

    if (query.isEmpty) {
      setState(() {
        searchResults = allMedicines; // 검색어가 비어 있으면 전체 목록 표시
      });
    } else {
      try {
        // 검색 결과를 비동기로 가져옴
        final results = await _databaseService.searchMedisen(query);

        setState(() {
          searchResults = results; // 검색 결과 업데이트
        });
      } catch (error) {
        print("Error searching medicines: $error");

        // 오류 발생 시 빈 결과로 처리
        setState(() {
          searchResults = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('약품 검색'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '약품 이름을 입력하세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                searchMedicines(query); // 검색어 변경 시 검색 로직 실행
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(searchResults[index]),
                    onTap: () {
                      _showMedicineDetails(context, searchResults[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 약품 상세 정보 다이얼로그
  void _showMedicineDetails(BuildContext context, String medicineName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$medicineName 정보'),
          content: Text('$medicineName에 대한 자세한 정보를 여기에 표시합니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
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
