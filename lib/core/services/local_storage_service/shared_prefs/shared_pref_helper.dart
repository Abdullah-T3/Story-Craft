import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  final SharedPreferences prefs;

  SharedPrefsHelper(this.prefs);

  Future<bool> storeData<T>({required String key, required T value}) async {
    if (value is bool) return await prefs.setBool(key, value);
    if (value is String) return await prefs.setString(key, value);
    if (value is int) return await prefs.setInt(key, value);
    if (value is double) return await prefs.setDouble(key, value);
    if (value is List<String>) return await prefs.setStringList(key, value);

    throw Exception('Unsupported type: ${T.toString()}');
  }

  T? getData<T>({required String key}) {
    final result = prefs.get(key);
    return result as T?;
  }

  Future<bool> removeData({required String key}) async {
    return await prefs.remove(key);
  }

  Future<bool> clearData() async {
    return await prefs.clear();
  }
}
