// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

import 'application/controllers/pessoas.controller.dart';
import 'data/config/connection.dart';
import 'data/services/pessoas.service.dart';
import 'router_lib/src/router.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';

void main() async {
  withHotreload(
    createServer,
    onReloaded: () => print('Restarting application!'),
    onHotReloadNotAvailable: () => print('No hot-reload :('),
    onHotReloadAvailable: () => print('Started with live reload'),
    logLevel: Level.INFO,
  );
}

Future<HttpServer> createServer() async {
  final dbConnection = await databaseConnection();
  final Database database = Database(dbConnection);
  final pessoasService = PessoasSevice(database);
  final pessoasController = PessoasController(pessoasService);

  Map<String, dynamic> env = Platform.environment;

  final router = Router();

  router.get('/health', (Request request) {
    return Response.ok('done');
  });

  router.get('/pessoas/<id>',
      (Request request, String id) => pessoasController.find(id));

  router.get(
      '/pessoas', (Request request) => pessoasController.filter(request));

  router.get(
      '/contagem-pessoas', (Request request) => pessoasController.count());

  router.post(
      '/pessoas/', (Request request) => pessoasController.create(request));

  final serverPort = int.tryParse(env["SERVER_PORT"]);
  var server =
      await shelf_io.serve(router, InternetAddress.anyIPv4, serverPort!);
  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
  return server;
}
