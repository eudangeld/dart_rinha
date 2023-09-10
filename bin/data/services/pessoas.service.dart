import '../../domain/enitite/pessoa.entity.dart';
import '../../uuid/uuid.dart';
import '../config/connection.dart';

class PessoasSevice {
  PessoasSevice(this.database) {
    database.tableName = 'pessoas';
  }

  final Database database;

  final uuid = Uuid();

  Future<Pessoa> find(String id) async {
    final dbResult = await database.byID(id);
    if (dbResult.numOfRows > 0) {
      return Pessoa.fromMap(dbResult.rows.first.assoc());
    }
    throw Exception('Empty');
  }

  Future<String> create(Pessoa pessoa) async {
    pessoa.id = uuid.v1();
    return await database.create(pessoa);
  }

  Future<int> count() async => await database.count();

  Future<List> filter(String term) async {
    List<Pessoa> response = [];

    final res = await database
        .byTerm(['nome', 'nascimento', 'stack', 'apelido'], 'serchable', term);

    if (res.numOfRows > 0) {
      for (final pessoa in res.rows) {
        response.add(Pessoa.fromMap(pessoa.assoc()));
      }
    }
    return response;
  }
}
