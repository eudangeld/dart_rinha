import '../../mysql_lib/mysql_client.dart';

Future<MySQLConnection> database() async {
  return await MySQLConnection.createConnection(
    host: "127.0.0.1",
    port: 3306,
    userName: "user",
    password: "password",
    databaseName: "db",
  );
}
