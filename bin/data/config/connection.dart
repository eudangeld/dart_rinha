import 'dart:io';

import '../../mysql_lib/mysql_client.dart';

Future<MySQLConnection> database() async {
  Map<String, dynamic> env = Platform.environment;

  final String envHost = env["DB_HOST"];
  final envPort = env["DB_PORT"];

  print('MYSQL connect on $envHost port: $envPort');

  final connection = await MySQLConnection.createConnection(
    host: envHost,
    port: int.tryParse(envPort)!,
    userName: "root",
    password: "rootpassword",
    databaseName: "db",
  );
  await connection.connect();

  return connection;
}
