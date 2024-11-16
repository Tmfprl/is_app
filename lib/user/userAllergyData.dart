import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  String description;

  Allergy({
    required this.name,
    this.imagePath,
    this.tags = const [],
    required this.description, 
  });
}

class AllergyList extends StatefulWidget {
  @override
  _AllergyListState createState() => _AllergyListState();
}

class _AllergyListState extends State<AllergyList> {
  List<Allergy> allergies = [];
  List<Allergy> filteredAllergies = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredAllergies = allergies;
  }

  void _addAllergy(Allergy allergy) {
    setState(() {
      if (!allergies.contains(allergy)) {
        allergies.add(allergy);
        _filterAllergies(searchQuery);
      }
    });
  }

  void _filterAllergies(String query) {
    setState(() {
      searchQuery = query;
      filteredAllergies = allergies.where((allergy) {
        return allergy.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
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
              if (allergy.imagePath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
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
                  allergy.description,
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
                onPressed: () {
                  // 삭제 기능 추가
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
    TextEditingController descriptionController = TextEditingController(text: allergy.description);
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
                        controller: descriptionController,
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
              onPressed: () {
                if (nameController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                  setState(() {
                    allergies[filteredAllergies.indexOf(allergy)] = Allergy(
                      name: nameController.text,
                      imagePath: imagePath,
                      tags: List.from(tags),
                      description: descriptionController.text,
                    );
                    filteredAllergies[filteredAllergies.indexOf(allergy)] = Allergy(
                      name: nameController.text,
                      imagePath: imagePath,
                      tags: List.from(tags),
                      description: descriptionController.text,
                    );
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
  Widget build(BuildContext context) { //나의 알러지 데이터 리스트 화면
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40),
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
            child: Container(
              width: 350,
              height: 40,
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
          ),
          SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 한 줄에 두 개
                crossAxisSpacing: 8.0, //열간 여백
                mainAxisSpacing: 8.0, // 행간 여백
                childAspectRatio: 1.0, // 카드 비율 1:1로 설정 -> 정사각형
              ),
              itemCount: filteredAllergies.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _showAllergyDetails(filteredAllergies[index]),
                  child: Card(
                    elevation: 4, // 그림자 효과 추가
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // 둥근 모서리
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                            child: filteredAllergies[index].imagePath != null
                              ? Image.file(
                                File(filteredAllergies[index].imagePath!),
                                width: double.infinity,
                                height: double.infinity, // 카드 크기에 맞춰 이미지 크기 조정
                                fit: BoxFit.cover,

                        )
                      : Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No Image',
                              style: TextStyle(color: Colors.black, fontSize: 12),
                            )
                          ],
                        ),
                        ), // 이미지가 없을 경우 '이미지 없음' 문구 노출
                ),
              ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            filteredAllergies[index].name,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center, // 텍스트 중앙 정렬
                          ),
                        ),
                      ],
                    ),
                  ),

                );
              },
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
                backgroundColor: const Color.fromARGB(255, 212, 151, 171),
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

  void _showAddAllergyDialog(BuildContext context) { //알러지 기록 다이얼로그 name controller 전달 받기 *null허용보류 
    

    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
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
                        controller: descriptionController,
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
              onPressed: () {
                if (nameController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                  _addAllergy(Allergy(
                    name: nameController.text,
                    imagePath: imagePath,
                    tags: List.from(tags), // 태그를 복사해서 전달
                    description: descriptionController.text,
                  ));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
