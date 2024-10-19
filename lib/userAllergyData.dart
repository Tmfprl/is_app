import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:is_app/memu.dart';

class userAllergyData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      allergies.add(allergy);
      filteredAllergies.add(allergy);
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

  void _showAllergyDetails(Allergy allergy) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (allergy.imagePath != null)
                Image.file(
                  File(allergy.imagePath!),
                  height: 100,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 10),
              Text(allergy.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Wrap(
                spacing: 6.0,
                children: allergy.tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    avatar: Icon(Icons.tag),
                    backgroundColor: Colors.blue[100],
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              Text(allergy.description),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showEditAllergyDialog(allergy);
                },
                child: Text('수정하기'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditAllergyDialog(Allergy allergy) {
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
                      ElevatedButton(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final pickedFile = await picker.getImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            imagePath = pickedFile.path;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 193, 189, 189),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          fixedSize: Size(300, 300),
                        ),
                        child: Icon(Icons.camera_alt, size: 40, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      if (imagePath != null) // 이미지가 선택된 경우에만 보여줌
                        Container(
                          width: 300,
                          height: 200, // 카메라 버튼과 동일한 높이로 설정
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(File(imagePath!)),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8),
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
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.7, // 이미지 비율 조정
              ),
              itemCount: filteredAllergies.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _showAllergyDetails(filteredAllergies[index]),
                  child: Card(
                    child: Column(
                      children: [
                        if (filteredAllergies[index].imagePath != null)
                          Image.file(
                            File(filteredAllergies[index].imagePath!),
                            width: double.infinity,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        SizedBox(height: 4),
                        Text(
                          filteredAllergies[index].name,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4),
                        Wrap(
                          spacing: 6.0,
                          children: filteredAllergies[index].tags.map((tag) {
                            return Chip(
                              label: Text(tag),
                              avatar: Icon(Icons.tag),
                              backgroundColor: Colors.blue[100],
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 4),
                        Text(
                          filteredAllergies[index].description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Spacer(),
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

  void _showAddAllergyDialog(BuildContext context) {
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
                      ElevatedButton(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final pickedFile = await picker.getImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            imagePath = pickedFile.path;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 193, 189, 189),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          fixedSize: Size(300, 300),
                        ),
                        child: Icon(Icons.camera_alt, size: 40, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      if (imagePath != null) // 이미지가 선택된 경우에만 보여줌
                        Container(
                          width: 300,
                          height: 200, // 카메라 버튼과 동일한 높이로 설정
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(File(imagePath!)),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8),
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
