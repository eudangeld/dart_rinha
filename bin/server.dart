// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

import 'application/controllers/pessoas.controller.dart';
import 'data/config/connection.dart';
import 'data/services/pessoas.service.dart';
import 'router_lib/src/router.dart';

void main() async {
  final db = await database();
  await db.connect();

  final pessoasService = PessoasSevice(db);
  final pessoasController = PessoasController(pessoasService);

  final router = Router();
  router.get('/pessoas/<id>', (Request request, String id) {
    return pessoasController.find(id);
  });
  router.get('/pessoas', (Request request) {
    final qParams = request.url.queryParameters;
    return Response.ok('procura pessoa with term: $qParams');
  });
  router.get('/contagem-pessoas', (Request request) async {
    return await pessoasController.count();
  });
  router.post('/pessoas/', (Request request) async {
    final body = await request.readAsString();
    return pessoasController.create(body);
  });

  var server = await shelf_io.serve(router, 'localhost', 8080);
  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}
