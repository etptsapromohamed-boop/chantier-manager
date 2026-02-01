import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chantier_manager/src/features/core/data/local/app_database.dart';

part 'group_repository.g.dart';

@Riverpod(keepAlive: true)
GroupRepository groupRepository(GroupRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return GroupRepository(db);
}

class GroupRepository {
  final AppDatabase _db;

  GroupRepository(this._db);

  // --- GROUPS CRUD ---

  Stream<List<WorkGroup>> watchAllGroups() {
    return _db.select(_db.workGroups).watch();
  }

  Future<List<WorkGroup>> getAllGroups() {
    return _db.select(_db.workGroups).get();
  }

  Future<void> addGroup(WorkGroupsCompanion companion) async {
    await _db.into(_db.workGroups).insert(companion);
  }

  Future<void> updateGroup(WorkGroupsCompanion companion) async {
    await _db.update(_db.workGroups).replace(companion);
  }

  Future<void> deleteGroup(String id) async {
    // Before deleting group, clear groupId for all users in this group
    await (_db.update(_db.users)..where((u) => u.groupId.equals(id)))
        .write(const UsersCompanion(groupId: Value(null)));
    
    await (_db.delete(_db.workGroups)..where((g) => g.id.equals(id))).go();
  }

  // --- MEMBERSHIP ---

  Stream<List<User>> watchMembers(String groupId) {
    return (_db.select(_db.users)..where((u) => u.groupId.equals(groupId))).watch();
  }

  Future<List<User>> getMembers(String groupId) {
    return (_db.select(_db.users)..where((u) => u.groupId.equals(groupId))).get();
  }

  Future<List<User>> getAvailableWorkers() {
    // Workers with no group
    return (_db.select(_db.users)
          ..where((u) => u.role.equals('worker') & u.groupId.isNull()))
        .get();
  }

  /// Transfers a user to a new group.
  /// Rule: Cannot transfer if marked as 'absent' for today.
  Future<String?> transferUser(String userId, String? nextGroupId) async {
    // 1. Check today's attendance
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    final attendance = await (_db.select(_db.attendance)
          ..where((a) => a.userId.equals(userId) & a.date.equals(today))
          ..limit(1))
        .getSingleOrNull();

    if (attendance != null && attendance.status == 'absent') {
      return "Impossible de déplacer un ouvrier absent aujourd'hui.";
    }

    // 2. Perform transfer
    await (_db.update(_db.users)..where((u) => u.id.equals(userId)))
        .write(UsersCompanion(groupId: Value(nextGroupId)));
    
    return null; // Success
  }

  /// Bulk Transfers multiple users to a new group.
  /// Returns a list of error messages for users that failed to transfer.
  Future<List<String>> bulkTransferUsers(List<String> userIds, String? nextGroupId) async {
    List<String> errors = [];
    for (var userId in userIds) {
      final error = await transferUser(userId, nextGroupId);
      if (error != null) {
        // Find user name for better error report
        final user = await getUserById(userId);
        errors.add("${user?.firstName ?? userId}: $error");
      }
    }
    return errors;
  }

  // Helper to get group name by ID
  Future<WorkGroup?> getGroupById(String? id) async {
    if (id == null) return null;
    return (_db.select(_db.workGroups)..where((g) => g.id.equals(id))).getSingleOrNull();
  }

  // Get all supervisors (to assign as group leads)
  Future<List<User>> getSupervisors() {
    return (_db.select(_db.users)..where((u) => u.role.equals('supervisor'))).get();
  }

  Future<User?> getUserById(String? id) async {
    if (id == null) return null;
    return (_db.select(_db.users)..where((u) => u.id.equals(id))).getSingleOrNull();
  }
}
