// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

import 'router_lib/src/router.dart';

void main() async {
  final router = Router();
  router.get('/pessoas/<id>', (Request request, String id) {
    return Response.ok('pessoa with ID: $id');
  });
  router.post('/pessoas/', (Request request) async {
    final body = await request.readAsString();
    final pessoa = Pessoa.fromMap(jsonDecode(body));
    return Response.ok('pessoa created  $pessoa');
  });

  var server = await shelf_io.serve(router, 'localhost', 3000);
  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}

class Pessoa {
  String apelido;
  String nome;
  String nascimento;
  String stack;
  Pessoa({
    required this.apelido,
    required this.nome,
    required this.nascimento,
    required this.stack,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'apelido': apelido,
      'nome': nome,
      'nascimento': nascimento,
      'stack': stack,
    };
  }

  factory Pessoa.fromMap(Map<String, dynamic> map) {
    return Pessoa(
      apelido: map['apelido'] as String,
      nome: map['nome'] as String,
      nascimento: map['nascimento'] as String,
      stack: map['stack'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pessoa.fromJson(String source) =>
      Pessoa.fromMap(json.decode(source) as Map<String, dynamic>);
}
