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

  Future<Response> create(Request req) async {
    String response;
    try {
      final body = await req.readAsString();
      Pessoa pessoa = Pessoa.fromMap(jsonDecode(body));
      response = await pessoasService.create(pessoa);
    } catch (e) {
      return Response(422, body: 'Unprocessable Entity $e');
    }

    return Response(201, body: response);
  }

  Future<Response> filter(Request request) async {
    final qParams = request.url.queryParameters['t'];
    if (qParams == null) {
      return Response.badRequest();
    }
    final response = await pessoasService.filter(qParams);
    return Response.ok(jsonEncode(response));
  }

  Future<Response> count() async {
    final response = await pessoasService.count();
    return Response.ok(response.toString());
  }
}
