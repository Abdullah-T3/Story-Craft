import 'package:hive/hive.dart';

abstract class IHiveService<T> {
  Future<void> init({/*required int typeId,*/ required String boxName});
  Future<void> put(String key, T value);
  Future<T?> get(String key);
  Future<List<T>> getAll();
  Future<void> putAll(Map<String, T> entries);
  Future<void> delete(String key);
  Future<void> clearBox();
  Future<void> close();
  bool isBoxOpen();
  bool isInitialized();
  bool hasKey(String key);
  Stream<BoxEvent> watch({String? key});
}
