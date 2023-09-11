import 'dart:convert';
import 'dart:io';

import '../../domain/enitite/pessoa.entity.dart';
import '../../mysql_lib/mysql_client.dart';

Future<MySQLConnection> databaseConnection() async {
  Map<String, dynamic> env = Platform.environment;

  final String envHost = env["DB_HOST"] ?? 'localhost';
  final envPort = env["DB_PORT"] ?? '3306';
  // final envPort = '3306';

  print('MYSQL connect on $envHost port: $envPort');

  final connection = await MySQLConnection.createConnection(
    host: 'docker.for.mac.localhost',
    port: 3306,
    userName: "root",
    password: "rootpassword",
    databaseName: "db",
  );
  connection.connect();

  return connection;
}

class Database {
  late final String tableName;
  final MySQLConnection connection;
  Database(this.connection);

  Future<IResultSet> byID(String id) async {
    final query = '''
          SELECT nome, apelido, nascimento, stack FROM $tableName WHERE id = :id
            ''';
    final result = await connection.execute(query, {"id": id});

    if (result.numOfRows > 0) {
      return result;
    }

    throw Exception('Empty');
  }

  Future<IResultSet> byTerm(
      List<String> columns, String searchColum, String term) async {
    final query = '''
        SELECT ${columns.join(',')}
        FROM $tableName
        WHERE serchable LIKE :$searchColum
          ''';
    return await connection.execute(query, {searchColum: "%$term%"});
  }

  Future<int> count() async {
    final totalis = await connection.execute('select * from $tableName');
    return totalis.numOfRows;
  }

  Future<String> create(Pessoa pessoa) async {
    await connection.execute('''
          INSERT INTO $tableName 
          (id, nome, apelido,stack, nascimento,serchable) 
          VALUES (:id, :nome, :apelido, :stack, :nascimento, :serchable)''', {
      'id': pessoa.id,
      'nome': pessoa.nome,
      'apelido': pessoa.apelido,
      'nascimento': pessoa.nascimento,
      'stack': jsonEncode(pessoa.stack),
      'serchable': pessoa.toString(),
    });

    return pessoa.id!;
  }
}
