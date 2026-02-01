import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chantier_manager/src/features/core/data/local/app_database.dart';
import 'package:chantier_manager/src/features/settings/data/settings_defaults.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

part 'settings_repository.g.dart';

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return SettingsRepository(db);
}

class SettingsRepository {
  final AppDatabase _db;

  SettingsRepository(this._db);

  /// Initialize all default settings if they don't exist
  Future<void> initializeDefaults() async {
    final existingSettings = await _db.select(_db.appSettings).get();
    
    // If settings already exist, don't override
    if (existingSettings.isNotEmpty) return;

    final defaults = SettingsDefaults.getAllDefaults();
    final batch = <AppSettingsCompanion>[];

    defaults.forEach((key, config) {
      batch.add(AppSettingsCompanion(
        id: Value(const Uuid().v4()),
        key: Value(key),
        value: Value(jsonEncode(config['value'])),
        type: Value(config['type'] as String),
        category: Value(config['category'] as String),
        updatedAt: Value(DateTime.now()),
      ));
    });

    await _db.batch((b) {
      b.insertAll(_db.appSettings, batch);
    });
  }

  /// Get a setting value by key
  Future<T?> getSetting<T>(String key) async {
    final setting = await (_db.select(_db.appSettings)
          ..where((s) => s.key.equals(key)))
        .getSingleOrNull();

    if (setting == null) return null;

    final decodedValue = jsonDecode(setting.value);
    
    // Type casting based on the stored type
    if (T == String) return decodedValue as T;
    if (T == int) return decodedValue as T;
    if (T == double) return decodedValue as T;
    if (T == bool) return decodedValue as T;
    
    return decodedValue as T?;
  }

  /// Update a setting value
  Future<void> updateSetting(String key, dynamic value, String? updatedBy) async {
    final setting = await (_db.select(_db.appSettings)
          ..where((s) => s.key.equals(key)))
        .getSingleOrNull();

    if (setting == null) {
      throw Exception('Setting $key not found');
    }

    await (_db.update(_db.appSettings)..where((s) => s.id.equals(setting.id)))
        .write(AppSettingsCompanion(
      value: Value(jsonEncode(value)),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
    ));
  }

  /// Get all settings by category
  Future<Map<String, dynamic>> getSettingsByCategory(String category) async {
    final settings = await (_db.select(_db.appSettings)
          ..where((s) => s.category.equals(category)))
        .get();

    return {
      for (var s in settings) s.key: jsonDecode(s.value)
    };
  }

  /// Reset all settings to defaults
  Future<void> resetToDefaults() async {
    await _db.delete(_db.appSettings).go();
    await initializeDefaults();
  }

  /// Export all settings as JSON
  Future<Map<String, dynamic>> exportSettings() async {
    final settings = await _db.select(_db.appSettings).get();
    
    return {
      for (var s in settings)
        s.key: {
          'value': jsonDecode(s.value),
          'type': s.type,
          'category': s.category,
        }
    };
  }

  /// Import settings from JSON
  Future<void> importSettings(Map<String, dynamic> data, String? updatedBy) async {
    for (final entry in data.entries) {
      final key = entry.key;
      final config = entry.value as Map<String, dynamic>;
      
      final existing = await (_db.select(_db.appSettings)
            ..where((s) => s.key.equals(key)))
          .getSingleOrNull();

      if (existing != null) {
        // Update existing
        await updateSetting(key, config['value'], updatedBy);
      } else {
        // Insert new
        await _db.into(_db.appSettings).insert(AppSettingsCompanion(
          id: Value(const Uuid().v4()),
          key: Value(key),
          value: Value(jsonEncode(config['value'])),
          type: Value(config['type'] as String),
          category: Value(config['category'] as String),
          updatedAt: Value(DateTime.now()),
          updatedBy: Value(updatedBy),
        ));
      }
    }
  }

  /// Watch all settings (for reactive UI)
  Stream<List<AppSetting>> watchAllSettings() {
    return _db.select(_db.appSettings).watch();
  }

  /// Watch settings by category
  Stream<List<AppSetting>> watchSettingsByCategory(String category) {
    return (_db.select(_db.appSettings)
          ..where((s) => s.category.equals(category)))
        .watch();
  }
}
