import '../../domain/enitite/pessoa.entity.dart';
import '../../mysql_lib/mysql_client.dart';
import '../../uuid/uuid.dart';

class PessoasSevice {
  PessoasSevice(this.connection);

  final MySQLConnection connection;

  final uuid = Uuid();

  Future<Pessoa> find(String id) async {
    final query = '''
          SELECT nome, apelido, nascimento, stack FROM pessoas WHERE id = :id
            ''';

    final res = await connection.execute(query, {"id": id});

    if (res.numOfRows > 0) {
      final userData = res.rows.first.assoc();
      return Pessoa(
        nome: userData['nome']!,
        apelido: userData['apelido']!,
        nascimento: userData['nascimento']!,
        stack: [],
      );
    }

    throw Exception('Empty');
  }

  Future<String> create(Pessoa pessoa) async {
    pessoa.id = uuid.v1();
    await connection.execute('''
          INSERT INTO pessoas 
          (id, nome, apelido,stack, nascimento,serchable) 
          VALUES (:id, :nome, :apelido, :stack, :nascimento, :serchable)''', {
      'id': pessoa.id,
      'nome': pessoa.nome,
      'apelido': pessoa.apelido,
      'nascimento': pessoa.nascimento,
      'stack': pessoa.stack,
      'serchable': pessoa.toString(),
    });

    return pessoa.id!;
  }

  Future<int> count() async {
    final totalis = await connection.execute('select * from pessoas');
    return totalis.numOfRows;
  }

  Future<List> filter(String term) async {
    List<Pessoa> response = [];

    final query = '''
        SELECT nome, nascimento, stack, apelido
        FROM pessoas
        WHERE serchable LIKE :serchable
          ''';
    final res = await connection.execute(query, {"serchable": "%$term%"});

    if (res.numOfRows > 0) {
      for (final pessoa in res.rows) {
        final data = pessoa.assoc();
        response.add(Pessoa(
          nome: data['nome']!,
          apelido: data['apelido']!,
          nascimento: data['nascimento']!,
          stack: [],
        ));
      }
    }

    print('response.length');
    print(response.length);

    return response;
  }
}

final Map<String, Pessoa> db = {};
