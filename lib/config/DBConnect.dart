import 'package:mysql_client/mysql_client.dart';

class DatabaseService {
  late MySQLConnection _connection;

  // 연결 상태 확인을 위한 플래그
  bool _isConnected = false;

  // 데이터베이스 연결 생성
  Future<void> connect() async {
    try{
      if (!_isConnected) {
        _connection = await MySQLConnection.createConnection(
          host: '35.221.113.55',
          port: 3306,
          userName: 'min_potato',
          password: 'potato',
          databaseName: 'capstone_potato',
        );

        await _connection.connect();
        _isConnected = true; // 연결이 성공적으로 이루어진 경우 상태 업데이트
      }
    }catch(e){
      print("Error during conntion : $e");
      _isConnected =false;
    }
  }

  // 데이터베이스 연결 종료
  Future<void> close() async {
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
    } finally {
      await close();
    }
  }
}