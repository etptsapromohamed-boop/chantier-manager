import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:sqlite3/wasm.dart';

QueryExecutor openConnection() {
  return DatabaseConnection.delayed(Future(() async {
    // Load the sqlite3 wasm library
    final sqlite3 = await WasmSqlite3.loadFromUrl(Uri.parse('sqlite3.wasm'));
    
    // Register a virtual file system based on IndexedDB for persistence
    final fileSystem = await IndexedDbFileSystem.open(dbName: 'chantier_manager_db');
    sqlite3.registerVirtualFileSystem(fileSystem, makeDefault: true);
    
    return DatabaseConnection(WasmDatabase(
      sqlite3: sqlite3,
      path: '/drift_db.sqlite', // File path in the virtual file system
    ));
  }));
}
