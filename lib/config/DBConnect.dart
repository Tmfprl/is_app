import 'package:mysql_client/mysql_client.dart';

Future<MySQLConnection> dbConnector() async {
  print("Connecting to mysql server...");

  final conn = await MySQLConnection.createConnection(
    host: '35.221.113.55',
    port: 3306,
    userName: 'min_potato',
    password: 'potato',
    databaseName: 'capston_potato',
  );

  await conn.connect();

  print("Connected");

  return conn;
}

