import 'package:is_app/config/StorageService.dart';
import 'package:is_app/user/userAllergyData.dart';
import 'package:mysql_client/mysql_client.dart';

/// DB Config 
///
/// @author : 박경은
/// 
/// database connection info 
/// 
/// @return : db response result

class DatabaseService {
  late MySQLConnection _connection;
  final getUser = StorageService();

  // 데이터베이스 연결 설정
  Future<void> connect() async {
    _connection = await MySQLConnection.createConnection(
      host: '35.221.113.55',
      port: 3306,
      userName: 'min_potato',
      password: 'potato',
      databaseName: 'capstone_potato',
    );
    await _connection.connect(timeoutMs: 10000);
  }

  // 데이터베이스 연결 종료
  Future<void> close() async {
    try {
      if (_connection != null) {
        await _connection!.close();
        print('Connection closed successfully.');
      }
    } catch (e) {
      print('Error during connection close: $e');
    }
  }

  // 사용자 검증 메서드
  Future<bool> validateUser(String ID, String PW) async {
    try {
      await connect();
      final result = await _connection.execute(
        'SELECT * FROM user_info WHERE usr_id = :ID AND usr_pw = :PW',
        {'ID': ID, 'PW': PW},
      );

      return result.rows.isNotEmpty;
    } catch (e) {
      print('Error during user validation: $e');
      return false;
    } finally {
      await close();
    }
  }

  // 사용자 삽입 메서드
  Future<void> insertUser(String ID, String PW) async {
    try {
      await connect();
      await _connection.execute(
        'INSERT INTO user_info (usr_id, usr_pw) VALUES (:ID, :PW)',
        {'ID': ID, 'PW': PW},
      );
    } catch (e) {
      print('Error during user insertion: $e');
    } finally {
      await close();
    }
  }

  // 사용자 존재 확인 메서드
  Future<bool> checkUserExists(String ID) async {
    
    try {
      await connect();
      final result = await _connection.execute(
        'SELECT * FROM user_info WHERE usr_id = :ID',
        {'ID': ID},
      );

      return result.rows.isNotEmpty;
    } catch (e) {
      print('Error during user existence check: $e');
      return false;
    } finally {
      await close();
    }
  }

  //사용자 알러지 데이터 삽입 메서드
  Future<void> insertUserAllergyData( String allergy, String imagePath, String tags, String info) async {
    String? userId = await getUser.getUserInfo('usr_id');
    try {
      await connect();
      await _connection.execute(
        'INSERT INTO my_ingredient (usr_id, allergy, ingr_image, ingr_tags, ingr_info)'
        'VALUES (:userId, :name, :imagePath, :tags, :info)',
        { 'userId' : userId,
          'name': allergy,
          'imagePath' : imagePath,
          'tags' : tags,
          'info' : info
          },
      );
    } catch (e) {
      print('Error during allergy deletion: $e');
    } finally {
      await close();
    }
  }

  //사용자 알러지 데이터 조회 메서드
  Future<List<Allergy>> fetchAllergiesFromDB() async {
    String? userId = await getUser.getUserInfo('usr_id');
    if (userId == null) {
      print('User ID is null');
      return [];
    }

    try {
      await connect();

      // 데이터 조회
      final result = await _connection.execute(
        'SELECT allergy, ingr_image, ingr_tags, ingr_info FROM my_ingredient WHERE usr_id = :userId ',
        {'userId' : userId},
      );

      // Allergy 객체 리스트로 변환
      return result.rows.map((row) {
        final tagsString = row.colByName('ingr_tags');
        final List<String> parsedTags = tagsString != null && tagsString.isNotEmpty
          ? tagsString.split(',').map((tag) => tag.trim()).toList()
          : [];

        return Allergy(
          name: row.colByName('allergy') ?? '',
          imagePath: row.colByName('ingr_image') ?? '',
          tags: parsedTags,
          info: row.colByName('ingr_info') ?? '',
          userId: userId,
        );
      }).toList();
    } catch (e) {
      print('Error fetching allergies: $e');
      return [];
    } finally {
      await close();
    }
}


  

  //사용자 알러지 데이터 삭제 메서드
  Future<void> deleteUserAllergyData(String allergy) async {
    String? userId = await getUser.getUserInfo('usr_id');
    try {
      await connect();
      await _connection.execute(
        'DELETE FROM my_ingredient WHERE allergy = :allergy and usr_id = :userId',
        {
          'allergy': allergy,
          'userId' : userId,
        }, 
      );
    } catch (e) {
      print('Error during allergy deletion: $e');
    } finally {
      await close();
    }
  }

  //사용자 데이터 업데이트 메서드
  Future<void> updateUserAllergyData(String name, String? image, String tags, String info) async {
    String? userId = await getUser.getUserInfo('usr_id');
    try {
      await connect();
      await _connection.execute(
        'UPDATE my_ingredient SET allergy = :name, ingr_image = :image, ingr_tags = :tags, ingr_info = :info WHERE usr_id = :id and allergy = :name',
        {
          'name': name,
          'image': image,
          'tags': tags,
          'info': info,
          'id': userId,
        },
      );
    } catch (e) {
      print('Error during allergy update: $e');
    } finally {
      await close();
    }
  }


  // 성분표 분석(scan) 조회 결과 반환 메소드
  Future<String?> getIngredientInfoFromDB(String ingredientName, String tableType) async {
    String columnName;
    String colName;

    switch (tableType) {
      case 'cosmetic_ingredient':
        columnName = 'ingredient_info'; // cosmetic ingredient table
        colName = 'ingrKorName';
        break;
      case 'medical_items':
        columnName = 'efcyQesitm'; // medical ingredient table
        colName = 'itemName';

        break;
      case 'chemical_ingredient':
        columnName = 'sysmtom'; // chemical ingredient table
        colName = 'chemiKorName';
        break;
      default:
        throw Exception('잘못된 성분표 종류입니다.');
    }

    try {
      await connect();

      // select
      final result = await _connection.execute(
        'SELECT $columnName FROM $tableType WHERE $colName = :ingredientName',
        {'ingredientName': ingredientName},
      );
      print("..."+ingredientName+",,,");

      if (result.rows.isNotEmpty) {
        var row = result.rows.first;
        return row.colByName(columnName)?.toString() ?? '';
      } else {
        return null; // select query response result = result
      }
    } catch (e) {
      print('Error retrieving ingredient information: $e');
      return null;
    } finally {
      await close();
    }
  }

  // 성분명 리스트를 받아서 SQL 쿼리에 맞는 형식으로 변환
  String formatIngredientList(List<String> ingredients) {
    // 리스트의 각 요소를 따옴표로 감싸고 쉼표로 구분
    return ingredients.map((ingredient) => "'$ingredient'").join(', ');
  }
  
  // 사용자의 알러지 정보 찾기
  Future<List<String>> getUserAllergies(List<String> allergyNames) async {
    List<String> foundAllergies = []; // 알러지 정보 저장 리스트
    String? userId = await getUser.getUserInfo('usr_id'); // 현재 사용자 id
    print('Stored user ID: $userId');

    String ingredientsString = formatIngredientList(allergyNames);

    try {
      await connect();
      // IN 절을 사용하여 여러 성분을 한 번에 조회 (파라미터로 전달)
      final query = '''
        SELECT allergy
        FROM my_ingredient
        WHERE usr_id = '$userId' AND allergy IN ($ingredientsString)
      ''';
      print(query);
      final result = await _connection.execute(
        query,
        {
          'userId': userId, // 현재 사용자 아이디
          'allergyNames': ingredientsString, // 전달받은 성분명 요소
        },
      );

      if (result.rows.isNotEmpty) {
        for (var row in result.rows) {
        var allergy = row.colByName('allergy').toString();
        foundAllergies.add(allergy);  // 조회한 알러지명 리스트에 추가
        }
      } else {
        return [];
      }
      print(foundAllergies);
      return foundAllergies;
    } catch (e) {
      print('Error during user validation: $e');
      return [];
    } finally {
      await close();
    }
  }
  
  //의약품 성분 검색
  Future<List<String>> searchMedisen(String medisenName) async {
    try {
      await connect();
      final query = '''
          SELECT itemName 
          FROM medical_items
          WHERE itemName LIKE '%$medisenName%';
        ''';
        print(query);
        print(query);
      final result = await _connection.execute(query);

      // 결과를 itemName 리스트로 변환
      List<String> medicines = [];
      for (final row in result.rows) {
        // 열 이름을 사용하여 값 접근
        final itemName = row.colByName('itemName') as String; // 'itemName'이 정확한 열 이름인지 확인
        medicines.add(itemName);
      }
      
      return medicines;
    } finally {
      await close();
    }
  }


Future<String?> medisenInfo(String columnName, String medisenName) async {
    try {
      await connect();
      final query = '''
          SELECT $columnName 
          FROM medical_items
          WHERE itemName = '$medisenName';
        ''';
        final result = await _connection.execute(query);
          // 결과가 비어 있지 않으면 첫 번째 행 가져오기
        if (result.isNotEmpty) {
          var row = result.rows.first;
          return row.colByName(columnName)?.toString() ?? ''; 
        }
    } finally {
      await close();
    }
    return null;
  }
}