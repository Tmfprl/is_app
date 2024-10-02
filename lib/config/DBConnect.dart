import 'package:mysql_client/mysql_client.dart';

class DatabaseService {
  MySQLConnection? _connection; // null safety를 위해 nullable 타입으로 변경

  // 연결 상태 확인을 위한 플래그
  bool _isConnected = false;

  // 데이터베이스 연결 생성
  Future<void> connect() async {
<<<<<<< HEAD
    try{
      if (!_isConnected) {
=======
    if (_connection == null) { // 연결이 null일 때만 새로 생성
      try {
>>>>>>> 1de8188fae0a9fc78cb42253d240ceb13dfe6eaa
        _connection = await MySQLConnection.createConnection(
          host: '35.221.113.55',
          port: 3306,
          userName: 'min_potato',
          password: 'potato',
          databaseName: 'capstone_potato',
        );
<<<<<<< HEAD

        await _connection.connect();
        _isConnected = true; // 연결이 성공적으로 이루어진 경우 상태 업데이트
      }
    }catch(e){
      print("Error during conntion : $e");
      _isConnected =false;
=======
        print('Database connected successfully.');
      } catch (e) {
        print('Error connecting to database: $e');
        throw Exception('Failed to connect to the database');
      }
>>>>>>> 1de8188fae0a9fc78cb42253d240ceb13dfe6eaa
    }
  }

  // 데이터베이스 연결 종료
  Future<void> close() async {
<<<<<<< HEAD
    if (_isConnected) {
      await _connection.close();
      _isConnected = false; // 연결이 종료된 경우 상태 업데이트
    } else {
      print("Connection is already closed or not established.");
    }
  }

  // 사용자 검증 메서드
  Future<bool> validateUser(String ID, String PW) async {
    try {
      await connect();

      // 연결이 성공적으로 이루어졌는지 확인
      if (!_isConnected) {
        print("Failed to connect to the database.");
        return false;
      }
      if (_isConnected) {
        final result = await _connection.execute(
          'SELECT * FROM user_info WHERE usr_id = :ID AND usr_pw = :PW',
          {'ID': ID, 'PW': PW},
        );
        
        return result.rows.isNotEmpty; // 결과가 존재하면 true
      } else {
        print("Cannot execute query. No active connection.");
        return false;
      }
    } catch (e) {
      print('Error during user validation: $e');
      return false;
=======
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
>>>>>>> 1de8188fae0a9fc78cb42253d240ceb13dfe6eaa
    } finally {
      await close();
    }
  }
<<<<<<< HEAD
}
=======
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
>>>>>>> 1de8188fae0a9fc78cb42253d240ceb13dfe6eaa
