import 'package:is_app/config/StorageService.dart';
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
  Future<void> insertUserAllergyData(String name, String image, String tags, String info) async {
    String? userId = await getUser.getUserInfo('usr_id');
    try {
      await connect();
      await _connection.execute(
        'INSERT INTO my_ingredient (usr_id, ingr_name, ingr_image, ingr_tags, ingr_info) VALUES (:userId, :name, :image, :tags, :info)',
        {'userId':userId, 'name': name, 'image': image, 'tags' : tags, 'info' : info},
      );
    } catch (e) {
      print('Error: $e');
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
}