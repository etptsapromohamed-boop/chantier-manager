import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chantier_manager/src/features/core/data/local/app_database.dart';

part 'attendance_repository.g.dart';

@Riverpod(keepAlive: true)
AttendanceRepository attendanceRepository(AttendanceRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return AttendanceRepository(db);
}

class AttendanceRepository {
  final AppDatabase _db;

  AttendanceRepository(this._db);

  // Fetch formatted data for export
  Future<List<Map<String, dynamic>>> getAttendanceReport({
    DateTime? startDate,
    DateTime? endDate,
    String? roleFilter, // 'all', 'worker', 'supervisor'
  }) async {
    final query = _db.select(_db.attendance).join([
      innerJoin(_db.users, _db.users.id.equalsExp(_db.attendance.userId)),
      leftOuterJoin(_db.projects, _db.projects.id.equalsExp(_db.attendance.projectId)),
    ]);

    // Apply Filters
    if (startDate != null) {
      query.where(_db.attendance.date.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query.where(_db.attendance.date.isSmallerOrEqualValue(endDate));
    }
    if (roleFilter != null && roleFilter != 'All' && roleFilter != 'all') {
      query.where(_db.users.role.equals(roleFilter));
    }

    query.orderBy([OrderingTerm.desc(_db.attendance.date)]);

    final rows = await query.get();

    return rows.map((row) {
      final attendance = row.readTable(_db.attendance);
      final user = row.readTable(_db.users);
      final project = row.readTableOrNull(_db.projects);

      return {
        'date': attendance.date,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'role': user.role,
        'projectName': project?.name,
        'checkIn': attendance.checkIn,
        'checkOut': attendance.checkOut,
        'status': attendance.status,
      };
    }).toList();
  }

  /// Fetches users that should be marked for attendance.
  /// Admin: All users.
  /// Supervisor: Workers in groups managed by this supervisor.
  Future<List<User>> getParticipatingUsers(String currentUserId, String currentUserRole) async {
    if (currentUserRole == 'admin') {
      return _db.select(_db.users).get();
    } else if (currentUserRole == 'supervisor') {
      // 1. Find groups managed by this supervisor
      final managedGroups = await (_db.select(_db.workGroups)
            ..where((g) => g.supervisorId.equals(currentUserId)))
          .get();
      
      if (managedGroups == null || managedGroups.isEmpty) return [];

      final groupIds = managedGroups.map((g) => g.id).toList();

      // 2. Find users in those groups
      return (_db.select(_db.users)
            ..where((u) => u.groupId.isIn(groupIds)))
          .get();
    }
    return []; // Workers don't take attendance for others
  }

  /// Saves or updates daily attendance for multiple users.
  /// Uses insertAllOnConflictUpdate to prevent duplicates if IDs are stable.
  Future<void> saveDailyAttendance(List<AttendanceCompanion> records) async {
    await _db.batch((batch) {
      batch.insertAllOnConflictUpdate(_db.attendance, records);
    });
  }

  /// Specifically marks the check-out time for a user on a given date.
  Future<void> markCheckOut(String attendanceId, DateTime checkOutTime) async {
    await (_db.update(_db.attendance)..where((t) => t.id.equals(attendanceId)))
        .write(AttendanceCompanion(checkOut: Value(checkOutTime)));
  }

  /// Get attendance records for a specific date to pre-fill the UI
  Future<List<AttendanceData>> getDailyAttendance(DateTime date) async {
    final midnight = DateTime(date.year, date.month, date.day);
    return (_db.select(_db.attendance)..where((a) => a.date.equals(midnight))).get();
  }
}
