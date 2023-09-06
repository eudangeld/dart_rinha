import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../data/services/pessoas.service.dart';
import '../../domain/enitite/pessoa.entity.dart';

class PessoasController {
  PessoasController(this.pessoasService);

  final PessoasSevice pessoasService;

  Future<Response> find(String id) async {
    Pessoa response;
    try {
      response = await pessoasService.find(id);
    } catch (e) {
      return Response.notFound('Not found');
    }
    return Response.ok(response.toJson());
  }

  Future<Response> create(String body) async {
    String response;
    try {
      Pessoa pessoa = Pessoa.fromMap(jsonDecode(body));
      response = await pessoasService.create(pessoa);
    } catch (e) {
      return Response(422, body: 'Unprocessable Entity $e');
    }

    return Response(201, body: response);
  }

  Future<Response> filter(Request req) async {
    return Response.ok(emptyPessoa);
  }

  Future<Response> count() async {
    final response = await pessoasService.count();
    return Response.ok(response.toString());
  }
}
