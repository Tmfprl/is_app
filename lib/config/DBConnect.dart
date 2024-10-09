import 'package:mysql_client/mysql_client.dart';

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

  // 사용자 존재 확인 메서드 추가
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

  Future<String?> getIngredientInfoFromDB(String ingredientName) async {
    try {
      await connect();

      // 성분 정보를 가져오는 SQL 쿼리
      final result = await _connection.execute(
        'SELECT ingredient_info FROM cosmetic_ingredient WHERE ingrKorName = :ingredientName',
        {'ingredientName': ingredientName},
      );

      // 결과가 비어 있지 않은 경우
      if (result.rows.isNotEmpty) {
        // 첫 번째 행을 가져온 후, 해당 열의 값에 접근
        var row = result.rows.first; // ResultSetRow 객체
        return row.colByName('ingredient_info').toString(); // 'ingredient_info'는 데이터베이스 열 이름
      } else {
        return null; // 결과가 없으면 null 반환
      }
    } catch (e) {
      print('Error retrieving ingredient information: $e');
      return null;
    } finally {
      await close();
    }
  }
}
