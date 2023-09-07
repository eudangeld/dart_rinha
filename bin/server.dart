// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

import 'application/controllers/pessoas.controller.dart';
import 'data/config/connection.dart';
import 'data/services/pessoas.service.dart';
import 'router_lib/src/router.dart';

void main() async {
  final db = await database();
  final pessoasService = PessoasSevice(db);
  final pessoasController = PessoasController(pessoasService);

  final router = Router();
  router.get('/health', (Request request) => Response.ok('done'));
  router.get('/pessoas/<id>',
      (Request request, String id) => pessoasController.find(id));

  router.get('/pessoas', (Request request) async {
    final resp = await pessoasController.filter(request);

    return resp;
  });

  router.get(
      '/contagem-pessoas', (Request request) => pessoasController.count());

  router.post(
      '/pessoas/', (Request request) => pessoasController.create(request));

  var server = await shelf_io.serve(router, InternetAddress.anyIPv4, 8080);
  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}
