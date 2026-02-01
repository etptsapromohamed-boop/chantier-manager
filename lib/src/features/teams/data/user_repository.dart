import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chantier_manager/src/features/core/data/local/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repository.g.dart';

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return UserRepository(db);
}



class UserRepository {
  final AppDatabase _db;

  UserRepository(this._db);

  Stream<List<User>> watchAllUsers() {
    return _db.select(_db.users).watch();
  }

  Future<List<User>> getAllUsers() {
    return _db.select(_db.users).get();
  }

  Future<User?> getUserById(String id) {
    return (_db.select(_db.users)..where((u) => u.id.equals(id))).getSingleOrNull();
  }

  // Search users by name or role
  Stream<List<User>> searchUsers(String query) {
    if (query.isEmpty) return watchAllUsers();
    
    return (_db.select(_db.users)
      ..where((u) => u.firstName.contains(query) | 
                     u.lastName.contains(query) |
                     u.role.contains(query)))
      .watch();
  }

  // Update user active status
  Future<void> updateUserStatus(String id, bool isActive) async {
    await (_db.update(_db.users)..where((u) => u.id.equals(id))).write(
      UsersCompanion(isActive: Value(isActive)),
    );
  }

  // Add a new user
  Future<void> addUser(UsersCompanion user) async {
    await _db.into(_db.users).insert(user);
  }

  // Update existing user
  Future<void> updateUser(UsersCompanion user) async {
    await _db.update(_db.users).replace(user);
  }

  // Delete user (permanently)
  Future<void> deleteUser(String id) async {
    await (_db.delete(_db.users)..where((u) => u.id.equals(id))).go();
  }
}
