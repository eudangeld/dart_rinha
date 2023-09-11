import 'package:redis/redis.dart';

Future<Command> redisConnect() async {
  final conn = RedisConnection();
  final comand = await conn.connect('docker.for.mac.localhost', 6379);
  return comand;
}
