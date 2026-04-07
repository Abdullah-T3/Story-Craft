import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  final storage = const FlutterSecureStorage(aOptions: AndroidOptions());

  Future saveToken(String token) async {
    await storage.write(key: 'access_token', value: token);
  }

  Future saveId(String id) async {
    await storage.write(key: 'id', value: id);
  }

  dynamic getToken({required String key}) {
    return storage.read(key: key);
  }

  dynamic getId({required String key}) {
    return storage.read(key: key);
  }

  Future removeToken() async {
    await storage.delete(key: 'access_token');
  }
}
