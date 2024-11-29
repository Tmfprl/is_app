import 'dart:io';
import 'package:is_app/config/DBConnect.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:is_app/config/StorageService.dart';
import 'package:is_app/memu.dart';

class userAllergyData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
               MaterialPageRoute(builder: (context) => MainMenu()),
               );
           },
          ),
      ),
      body: AllergyList(),
    );
  }
}

class Allergy {
  String name;
  String? imagePath;
  List<String> tags;
  String info;
  String userId;

  Allergy({
    required this.name,
    this.imagePath,
    this.tags = const [],
    required this.info,
    required this.userId, 
  });


}



class AllergyList extends StatefulWidget {
  @override
  _AllergyListState createState() => _AllergyListState();

  
}

class _AllergyListState extends State<AllergyList> {
  List<Allergy> allergies = []; //알러지 데이터를 저장할 리스트
  List<Allergy> filteredAllergies = []; //검색한 알러지 데이터 리스트
  final dbService = DatabaseService();
  final getUser = StorageService();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadAllergies();
    filteredAllergies = allergies;
  }

 // 알러지 데이터 불러오기
  Future<void> _loadAllergies() async {
    final allergiesFromDB = await dbService.fetchAllergiesFromDB(); //데이터 조회
    setState(() {
      allergies = allergiesFromDB;
      filteredAllergies = allergies;
    });
  }  
 
 // 검색 필터링
  void _filterAllergies(String query) {
    final filtered = allergies.where((allergy){
      return allergy.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      searchQuery = query;
      filteredAllergies = filtered;
    });
  }

  void _showAllergyDetails(Allergy allergy) { //기록한 알러지 열람 다이얼로그

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            width: 400,
            height: 800,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //닫기 버튼
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // 다이얼로그 닫기
                    }, 
                    icon: Icon(Icons.close, color: Colors.grey),
                    ),
                ],
              ),

              // 알러지 이름
              Container(
                width: double.infinity, //가로 전체 사용
                height: 40,
                padding: EdgeInsets.symmetric(vertical: 10), //위 아래 패딩
                decoration: BoxDecoration(
                  color: Color.fromARGB(225, 212, 151, 171), // 배경색
                  borderRadius: BorderRadius.circular(100), 
                ),
                child: Text(
                allergy.name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              // 이미지
              
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: allergy.imagePath != 'no image'
                  ? Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width:1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child:Image.file(
                      File(allergy.imagePath!),
                      fit: BoxFit.cover,
                      ),
                    ),
                  )
                  : Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width:1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    child: Center(
                      child: Text(
                      'No Image',
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.center,
                    ),
                  ),
                 ),
                ), 
                SizedBox(height: 10),
                // 태그 버튼
                Wrap(
                  spacing: 6.0,
                  alignment: WrapAlignment.start, //좌측 정렬
                  children: allergy.tags.map((tag) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 212, 151, 171),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // 패딩 조정
                      ),
                      onPressed: () {},
                      child: Text(
                        tag,
                        style: TextStyle(fontSize: 12, color:Colors.white), // 태그 텍스트 크기 조정
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                // 상세 설명 영역
                Container(
                  padding: EdgeInsets.all(10),
                  width: 300,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white, // 배경색
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey), // 테두리
                  ),
                  child: Text(
                    allergy.info,
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                // 수정 버튼
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showEditAllergyDialog(allergy);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit, color: Colors.white), // 수정 아이콘
                      SizedBox(width: 4),
                      Text('수정하기'),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 212, 151, 171),
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 40), // 가로 전체 사용
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // 삭제 버튼
                ElevatedButton(
                  onPressed: () async {
                    // db 삭제 기능 추가
                    await dbService.deleteUserAllergyData(allergy.name); //오류나면 수정
                    setState(() {
                      allergies.remove(allergy);
                      filteredAllergies.remove(allergy);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete, color: Colors.white), // 삭제 아이콘
                      SizedBox(width: 4),
                      Text('삭제'),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 40), // 가로 전체 사용
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
              
            ),
          ),
        );
      },
    );
  }

  void _showEditAllergyDialog(Allergy allergy) { //알러지 수정 다이얼로그
    TextEditingController nameController = TextEditingController(text: allergy.name);
    TextEditingController infoController = TextEditingController(text: allergy.info);
    List<String> tags = List.from(allergy.tags);
    String? imagePath = allergy.imagePath;
    TextEditingController tagController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                width: 300,
                height: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: '알러지명 및 제품명',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                      SizedBox(height: 10),
                        Center(
                          child: imagePath == null
                              ? ElevatedButton(
                                  onPressed: () async {
                                    // 이미지 선택 로직
                                    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                                    if (pickedFile != null) {
                                      setState(() {
                                        imagePath = pickedFile.path; // 이미지 경로 저장
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 193, 189, 189),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    fixedSize: Size(300, 300), // 버튼 크기 고정
                                  ),
                                  child: Icon(Icons.camera_alt, size: 40, color: Colors.white),
                                )
                              : Container(
                                  width: 300,
                                  height: 300, // 버튼과 동일한 크기
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(File(imagePath!)), // 선택한 이미지 보여줌
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(8), // 버튼과 동일한 모서리 둥글기
                                  ),
                                ),
                        ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: tagController,
                              decoration: InputDecoration(hintText: '태그 입력'),
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (tagController.text.isNotEmpty) {
                                setState(() {
                                  tags.add(tagController.text.trim());
                                  tagController.clear();
                                });
                              }
                            },
                            child: Text('추가'),
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 8,
                        children: tags.map((tag) {
                          return Chip(
                            label: Text(tag),
                            deleteIcon: Icon(Icons.close),
                            onDeleted: () {
                              setState(() {
                                tags.remove(tag);
                              });
                            },
                          );
                        }).toList(),
                      ),
                      TextField(
                        controller: infoController,
                        decoration: InputDecoration(
                          hintText: '상세 설명 입력',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        maxLines: 3,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              child: Text('수정하기'),
              onPressed: () async {
                if (nameController.text.isNotEmpty && infoController.text.isNotEmpty) {
                  // 데이터베이스에 업데이트
                  await dbService.updateUserAllergyData(
                  nameController.text,
                  imagePath ?? '',
                  tags.join(','), // 태그를 쉼표로 구분하여 저장
                  infoController.text,
                  );
                
                  // 리스트 업데이트
                  setState(() {
  // allergy가 filteredAllergies 리스트에 있는지 확인
  int allergyIndex = filteredAllergies.indexOf(allergy);
  
  // 인덱스가 유효한 경우만 업데이트
  if (allergyIndex != -1) {
    // filteredAllergies 리스트 업데이트
    filteredAllergies[allergyIndex] = Allergy(
      name: nameController.text,
      imagePath: imagePath,
      tags: List.from(tags),
      info: infoController.text,
      userId: '',
    );
    
    // allergies 리스트에서 동일한 인덱스의 항목도 업데이트
    allergyIndex = allergies.indexOf(allergy);
    if (allergyIndex != -1) {
      allergies[allergyIndex] = Allergy(
        name: nameController.text,
        imagePath: imagePath,
        tags: List.from(tags),
        info: infoController.text,
        userId: '',
      );
    }
  } else {
    // filteredAllergies에서 allergy를 찾을 수 없을 때의 처리
    print('Allergy not found in filtered list');
  }
});

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) { //알러지 리스트(그리드뷰)
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 212, 151, 171),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              Text(
                '나의 알러지 데이터',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '검색',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                prefixIcon: Icon(Icons.search),
              ),
              style: TextStyle(fontSize: 16),
              onChanged: _filterAllergies,
              textAlignVertical: TextAlignVertical.center,
            ),
          ),
          SizedBox(height: 8),

          Expanded(
            child: filteredAllergies.isNotEmpty
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: filteredAllergies.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _showAllergyDetails(filteredAllergies[index]),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12)),
                                  child: filteredAllergies[index].imagePath != 'no image'
                                      ? Image.file(
                                          File(filteredAllergies[index].imagePath!),
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Center(child: Text('No Image')),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  filteredAllergies[index].name,
                                  style: TextStyle(
                                      fontSize: 14, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      '알러지 데이터를 추가하세요!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 65,
            child: ElevatedButton.icon(
              onPressed: () {
                _showAddAllergyDialog(context);
              },
              icon: Icon(Icons.edit, color: Colors.white),
              label: Text(
                '기록하기',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 212, 151, 171),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddAllergyDialog(BuildContext context) { //알러지 기록 다이얼로그 

    TextEditingController nameController = TextEditingController();
    TextEditingController infoController = TextEditingController();
    List<String> tags = [];
    String? imagePath;
    TextEditingController tagController = TextEditingController(); // 태그 입력을 위한 컨트롤러

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                width: 300,
                height: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: '알러지명 및 제품명',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                      SizedBox(height: 10),
                        Center(
                            child: imagePath == null
                                ? ElevatedButton(
                                    onPressed: () async {
                                      // 이미지 선택 로직
                                      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                                      if (pickedFile != null) {
                                        setState(() {
                                          imagePath = pickedFile.path; // 이미지 경로 저장
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(255, 193, 189, 189),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      fixedSize: Size(300, 300), // 버튼 크기 고정
                                    ),
                                    child: Icon(Icons.camera_alt, size: 40, color: Colors.white),
                                  )
                                : Container(
                                    width: 300,
                                    height: 300, // 버튼과 동일한 크기
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: FileImage(File(imagePath!)), // 선택한 이미지 보여줌
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(8), // 버튼과 동일한 모서리 둥글기
                                    ),
                                  ),
                          ),
                       
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: tagController,
                              decoration: InputDecoration(hintText: '태그 입력'),
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (tagController.text.isNotEmpty) {
                                setState(() {
                                  tags.add(tagController.text.trim());
                                  tagController.clear();
                                });
                              }
                            },
                            child: Text('추가'),
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 8,
                        children: tags.map((tag) {
                          return Chip(
                            label: Text(tag),
                            deleteIcon: Icon(Icons.close),
                            onDeleted: () {
                              setState(() {
                                tags.remove(tag);
                              });
                            },
                          );
                        }).toList(),
                      ),
                      TextField(
                        controller: infoController,
                        decoration: InputDecoration(
                          hintText: '상세 설명 입력',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        maxLines: 3,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              child: Text('등록하기'),
              onPressed: () async {
                if (nameController.text.isNotEmpty && infoController.text.isNotEmpty) {
                  String? userId = await getUser.getUserInfo('usr_id'); // 현재 사용자 ID 가져오기
                  if (userId != null) {
                    // 새 알러지 객체 생성
                    Allergy newAllergy = Allergy(
                      name: nameController.text,
                      imagePath: imagePath,
                      tags: tags,
                      info: infoController.text,
                      userId: userId,
                    );

                    // 데이터베이스에 새 데이터 저장
                    await dbService.insertUserAllergyData(
                      newAllergy.name,       // 알러지명
                      newAllergy.imagePath ?? 'no image',  // 이미지 경로 
                      newAllergy.tags.join(','),  // 태그를 쉼표로 구분하여 저장
                      newAllergy.info,       // 상세 설명
                    );

                    // UI 업데이트
                    setState(() {
                      allergies.add(newAllergy); // 알러지 리스트에 새 데이터를 추가
                      filteredAllergies = List.from(allergies); // 필터링된 리스트도 업데이트
                    });

                    Navigator.of(context).pop(); // 다이얼로그 닫기

                    // 새로 추가된 알러지 데이터를 화면에 반영
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('알러지가 기록되었습니다!')),
                    );
                  } else {
                    print('Error: User ID is null');
                  }
                } else {
                  print('Error: Name or info is empty');
                }
              },
            )
          ],
        );
      },
    );
  }
}
