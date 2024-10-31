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
    await _connection.close();
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

      if (result.rows.isNotEmpty) {
        var row = result.rows.first;
        return row.colByName(columnName).toString();
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
}