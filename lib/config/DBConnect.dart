import 'package:mysql_client/mysql_client.dart';

class DatabaseService {
  MySQLConnection? _connection; // null safety를 위해 nullable 타입으로 변경

  // 데이터베이스 연결 생성
  Future<void> connect() async {
    if (_connection == null) { // 연결이 null일 때만 새로 생성
      try {
        _connection = await MySQLConnection.createConnection(
          host: '35.221.113.55',
          port: 3306,
          userName: 'min_potato',
          password: 'potato',
          databaseName: 'capstone_potato',
        );
        print('Database connected successfully.');
      } catch (e) {
        print('Error connecting to database: $e');
        throw Exception('Failed to connect to the database');
      }
    }
  }

  // 데이터베이스 연결 종료
  Future<void> close() async {
    if (_connection != null) {
      try {
        await _connection!.close();
        print('Database connection closed.');
      } catch (e) {
        print('Error closing database connection: $e');
      } finally {
        _connection = null; // 연결 객체를 null로 설정
      }
    }
  }

  // 사용자 데이터 삽입 예제
  /*Future<void> insertUser(String ID, String PW) async {
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
  */
  Future<void> insertUser(String ID, String PW) async {
    await connect();
  
    try {
      final result = await _connection.execute(
        'INSERT INTO user_info (usr_id, usr_pw) VALUES (@ID, @PW)',
        {'ID': ID, 'PW': PW},
      );

      if (result.affectedRows != null && result.affectedRows! > BigInt.from(0)) {
        print('User inserted successfully.');
      } else {
        print('No rows affected, insertion might have failed.');
      }
    } catch (e) {
      print('Error during insertion: $e');
    } finally {
      await close();
    }
  }
  // 사용자 존재 여부 확인
  Future<bool> checkUserExists(String ID) async {
    await connect();

    try {
      final result = await _connection.execute(
        'SELECT * FROM user_info WHERE usr_id = @ID',
        {'ID': ID},
      );

      print('Number of rows found: ${result.numOfRows}');
      return result.numOfRows > 0;
    } catch (e) {
      print('Error during user check: $e');
      return false;
    } finally {
      await close();
    }
  }

}
