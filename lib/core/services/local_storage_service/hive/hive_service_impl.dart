import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'hive_service.dart';

class HiveService<T> implements IHiveService<T> {
  Box<T>? _box;
  String? _currentBoxName;
  bool _isInitialized = false;
  static const String _versionKey = 'hive_schema_version';
  static const int _currentSchemaVersion =
      5; // TODO: Increment this when model schemas change

  @override
  Future<void> init({required String boxName}) async {
    if (_isInitialized) {
      throw Exception('Service already initialized');
    }

    try {
      _currentBoxName = boxName;

      // Check if we need to clear the box due to schema changes
      await _handleSchemaVersion(boxName);

      _box = await Hive.openBox<T>(boxName);
      _isInitialized = true;
    } on HiveError catch (e) {
      throw Exception('Hive initialization failed: ${e.message}');
    }
  }

  /// Handles schema version checking and box clearing if needed
  Future<void> _handleSchemaVersion(String boxName) async {
    final prefs = await SharedPreferences.getInstance();
    final lastVersion = prefs.getInt(_versionKey) ?? 0;

    if (lastVersion < _currentSchemaVersion) {
      // Schema has changed, clear the box
      if (await Hive.boxExists(boxName)) {
        await Hive.close();
        await Hive.deleteBoxFromDisk(boxName);

        /// TODO migrate to new schema
      }
      // Update the stored version
      await prefs.setInt(_versionKey, _currentSchemaVersion);
    }
  }

  String? get currentBoxName => _currentBoxName;

  @override
  bool isInitialized() => _isInitialized;

  bool get isReady => _isInitialized && _box != null && _box!.isOpen;

  @override
  Future<T?> get(String key) async {
    try {
      _ensureInitialized();
      return _box!.get(key);
    } catch (e) {
      throw Exception('Error getting data: $e');
    }
  }

  @override
  Future<void> put(String key, T value) async {
    try {
      _ensureInitialized();
      await _box!.put(key, value);
    } catch (e) {
      throw Exception('Error saving data: $e');
    }
  }

  @override
  Future<List<T>> getAll() async {
    try {
      _ensureInitialized();
      return _box!.values.toList();
    } catch (e) {
      throw Exception('Error getting all data: $e');
    }
  }

  @override
  Future<void> putAll(Map<String, T> entries) async {
    try {
      _ensureInitialized();
      await _box!.putAll(entries);
    } catch (e) {
      throw Exception('Error saving multiple entries: $e');
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      _ensureInitialized();
      await _box!.delete(key);
    } catch (e) {
      throw Exception('Error deleting data: $e');
    }
  }

  @override
  Future<void> clearBox() async {
    try {
      _ensureInitialized();
      await _box!.clear();
    } catch (e) {
      throw Exception('Error clearing box: $e');
    }
  }

  @override
  Future<void> close() async {
    try {
      _ensureInitialized();
      if (_box!.isOpen) {
        await _box!.close();
        _currentBoxName = null;
      }
    } catch (e) {
      throw Exception('Error closing box: $e');
    }
  }

  @override
  bool isBoxOpen() => _box!.isOpen;

  @override
  bool hasKey(String key) => _box!.containsKey(key);

  @override
  Stream<BoxEvent> watch({String? key}) => _box!.watch(key: key);

  void _ensureInitialized() {
    if (!_isInitialized || _box == null || !_box!.isOpen) {
      throw Exception('HiveService not initialized');
    }
  }
}
