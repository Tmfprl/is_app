import 'package:mysql_client/mysql_client.dart';

class DatabaseService {
  late MySQLConnection _connection;

  // 데이터베이스 연결 생성
  Future<void> connect() async {
    _connection = await MySQLConnection.createConnection(
      host: '35.221.113.55',
      port: 3306,
      userName: 'min_potato',
      password: 'potato',
      databaseName: 'capstone_potato',
    );
  }

  // 데이터베이스 연결 종료
  Future<void> close() async {
    await _connection.close();
  }

  // 사용자 검증 메서드
  Future<bool> validateUser(String ID, String PW) async {
    await connect();

    try {
      final result = await _connection.execute(
        'SELECT * FROM users WHERE username = @ID AND password = @PW',
        {'ID': ID, 'PW': PW},
      );

      return result.affectedRows != null && result.affectedRows! > BigInt.from(0); // 결과가 있는지 확인
    } catch (e) {
      print('Error: $e');
      return false;
    } finally {
      await close();
    }
  }

  // 사용자 데이터 삽입 예제
  Future<void> insertUser(String ID, String PW) async {
    await connect();

    try {
      await _connection.execute(
        'INSERT INTO users (username, password) VALUES (@ID, @PW)',
        {'ID': ID, 'PW': PW},
      );

      print('User inserted successfully.');
    } catch (e) {
      print('Error: $e');
    } finally {
      await close();
    }
  }
}
