
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:chantier_manager/src/features/core/data/local/app_database.dart';
import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workmanager/workmanager.dart';

// Defines
const String syncTaskName = "sync_data_task";

class SyncService {
  final AppDatabase db;
  final SupabaseClient supabase;

  SyncService(this.db, this.supabase);

  /// Main Sync Loop - called by UI or Workmanager
  Future<void> runSync() async {
    // 1. Fetch Pendings
    final pendingItems = await (db.select(db.syncQueue)
          ..where((tbl) => tbl.status.equals('PENDING')))
        .get();

    if (pendingItems.isEmpty) return;

    for (final item in pendingItems) {
      bool success = false;
      try {
        await _processItem(item);
        success = true;
      } catch (e) {
        debugPrint("Sync Error for item ${item.id}: $e");
        // Update retry count logic here
      }

      if (success) {
        await (db.delete(db.syncQueue)..where((tbl) => tbl.id.equals(item.id)))
            .go();
      } else {
         await (db.update(db.syncQueue)
          ..where((tbl) => tbl.id.equals(item.id)))
          .write(SyncQueueCompanion(
            retryCount: Value(item.retryCount + 1),
            status: const Value('FAILED'), // Or keep PENDING with backoff
          ));
      }
    }
  }

  Future<void> _processItem(SyncQueueData item) async {
    // Deserialize payload
    final payload = item.payload;

    if (item.actionType == 'UPLOAD_MEDIA') {
      await _uploadMedia(payload);
    } else if (item.actionType == 'INSERT') {
      await supabase.from(item.targetTable).insert(payload);
    } else if (item.actionType == 'UPDATE') {
       // Assuming ID is in payload or logic to find row
       final id = payload['id'];
       if (id != null) {
         await supabase.from(item.targetTable).update(payload).eq('id', id);
       }
    }
  }

  Future<void> _uploadMedia(Map<String, dynamic> payload) async {
    final localPath = payload['local_path'];
    final bucket = payload['bucket'] ?? 'tasks';
    final storagePath = payload['storage_path'];
    
    final file = File(localPath);
    if (!file.existsSync()) {
      throw Exception("File not found at $localPath");
    }

    await supabase.storage.from(bucket).upload(storagePath, file);
    
    final publicUrl = supabase.storage.from(bucket).getPublicUrl(storagePath);
    
    // If there is a dependent record (e.g., database row needs this URL), 
    // we might have another Queue item or we update local DB here.
    // In this simplifed version, we assume the next Sync Item updates the DB with the URL,
    // OR this op updates the local DB record with the URL so the standard INSERT sync picks it up.
    // Strategy: Media Upload First, then INSERT row.
    
    // Update local media record with remote URL
    if (payload['media_record_id'] != null) {
      await (db.update(db.taskMedia)..where((t) => t.id.equals(payload['media_record_id'])))
        .write(TaskMediaCompanion(
          storageUrl: Value(publicUrl),
          isUploaded: const Value(true)
        ));
    }
  }

  /// Manual Sync: Upload all local data to Supabase
  Future<Map<String, int>> uploadAllData() async {
    final results = <String, int>{};
    
    try {
      // 1. Upload Users
      final users = await db.select(db.users).get();
      if (users.isNotEmpty) {
        final usersData = users.map((u) => {
          'id': u.id,
          'role': u.role,
          'first_name': u.firstName,
          'last_name': u.lastName,
          'phone_number': u.phoneNumber,
          'email': u.email,
          'id_card_number': u.idCardNumber,
          'exact_position': u.exactPosition,
          'password': u.password,
          'profile_picture_path': u.profilePicturePath,
          'id_card_front_path': u.idCardFrontPath,
          'id_card_back_path': u.idCardBackPath,
          'is_active': u.isActive,
          'group_id': u.groupId,
          'created_at': u.createdAt?.toIso8601String(),
          'updated_at': u.updatedAt?.toIso8601String(),
        }).toList();
        await supabase.from('users').upsert(usersData);
        results['users'] = users.length;
      }

      // 2. Upload Work Groups
      final groups = await db.select(db.workGroups).get();
      if (groups.isNotEmpty) {
        final groupsData = groups.map((g) => {
          'id': g.id,
          'name': g.name,
          'supervisor_id': g.supervisorId,
          'created_at': g.createdAt.toIso8601String(),
        }).toList();
        await supabase.from('work_groups').upsert(groupsData);
        results['work_groups'] = groups.length;
      }

      // 3. Upload Projects
      final projects = await db.select(db.projects).get();
      if (projects.isNotEmpty) {
        final projectsData = projects.map((p) => {
          'id': p.id,
          'name': p.name,
          'geofence_lat': p.geofenceLat,
          'geofence_long': p.geofenceLong,
          'geofence_radius_meters': p.geofenceRadiusMeters,
        }).toList();
        await supabase.from('projects').upsert(projectsData);
        results['projects'] = projects.length;
      }

      // 4. Upload Tasks
      final tasks = await db.select(db.tasks).get();
      if (tasks.isNotEmpty) {
        final tasksData = tasks.map((t) => {
          'id': t.id,
          'local_id': t.localId,
          'title': t.title,
          'description': t.description,
          'project_id': t.projectId,
          'parent_id': t.parentId,
          'task_catalog_id': t.taskCatalogId,
          'assigned_group_id': t.assignedGroupId,
          'status': t.status,
          'completion_percentage': t.completionPercentage,
          'is_synced': t.isSynced,
          'last_locally_updated': t.lastLocallyUpdated?.toIso8601String(),
        }).toList();
        await supabase.from('tasks').upsert(tasksData);
        results['tasks'] = tasks.length;
      }

      // 5. Upload Attendance
      final attendance = await db.select(db.attendance).get();
      if (attendance.isNotEmpty) {
        final attendanceData = attendance.map((a) => {
          'id': a.id,
          'user_id': a.userId,
          'project_id': a.projectId,
          'check_in': a.checkIn.toIso8601String(),
          'check_out': a.checkOut?.toIso8601String(),
          'date': a.date.toIso8601String().split('T')[0],
          'status': a.status,
          'is_synced': a.isSynced,
        }).toList();
        await supabase.from('attendance').upsert(attendanceData);
        results['attendance'] = attendance.length;
      }

      // 6. Upload App Settings
      final settings = await db.select(db.appSettings).get();
      if (settings.isNotEmpty) {
        final settingsData = settings.map((s) => {
          'id': s.id,
          'key': s.key,
          'value': s.value,
          'type': s.type,
          'category': s.category,
          'updated_at': s.updatedAt.toIso8601String(),
          'updated_by': s.updatedBy,
        }).toList();
        await supabase.from('app_settings').upsert(settingsData);
        results['app_settings'] = settings.length;
      }

      return results;
    } catch (e) {
      debugPrint('Error uploading data: $e');
      rethrow;
    }
  }

  /// Manual Sync: Download all remote data from Supabase
  Future<Map<String, int>> downloadAllData() async {
    final results = <String, int>{};

    try {
      // 1. Download Users
      final remoteUsers = await supabase.from('users').select();
      for (final userData in remoteUsers) {
        await db.into(db.users).insertOnConflictUpdate(
          UsersCompanion(
            id: Value(userData['id']),
            role: Value(userData['role']),
            firstName: Value(userData['first_name']),
            lastName: Value(userData['last_name']),
            phoneNumber: Value(userData['phone_number']),
            email: Value(userData['email']),
            idCardNumber: Value(userData['id_card_number']),
            exactPosition: Value(userData['exact_position']),
            password: Value(userData['password']),
            profilePicturePath: Value(userData['profile_picture_path']),
            idCardFrontPath: Value(userData['id_card_front_path']),
            idCardBackPath: Value(userData['id_card_back_path']),
            isActive: Value(userData['is_active'] ?? true),
            groupId: Value(userData['group_id']),
            createdAt: Value(userData['created_at'] != null ? DateTime.parse(userData['created_at']) : null),
            updatedAt: Value(userData['updated_at'] != null ? DateTime.parse(userData['updated_at']) : null),
          ),
        );
      }
      results['users'] = remoteUsers.length;

      // 2. Download Work Groups
      final remoteGroups = await supabase.from('work_groups').select();
      for (final groupData in remoteGroups) {
        await db.into(db.workGroups).insertOnConflictUpdate(
          WorkGroupsCompanion(
            id: Value(groupData['id']),
            name: Value(groupData['name']),
            supervisorId: Value(groupData['supervisor_id']),
            createdAt: Value(DateTime.parse(groupData['created_at'])),
          ),
        );
      }
      results['work_groups'] = remoteGroups.length;

      // 3. Download Projects
      final remoteProjects = await supabase.from('projects').select();
      for (final projectData in remoteProjects) {
        await db.into(db.projects).insertOnConflictUpdate(
          ProjectsCompanion(
            id: Value(projectData['id']),
            name: Value(projectData['name']),
            geofenceLat: Value(projectData['geofence_lat'].toDouble()),
            geofenceLong: Value(projectData['geofence_long'].toDouble()),
            geofenceRadiusMeters: Value(projectData['geofence_radius_meters']?.toDouble() ?? 100.0),
          ),
        );
      }
      results['projects'] = remoteProjects.length;

      // 4. Download Tasks
      final remoteTasks = await supabase.from('tasks').select();
      for (final taskData in remoteTasks) {
        await db.into(db.tasks).insertOnConflictUpdate(
          TasksCompanion(
            id: Value(taskData['id']),
            localId: Value(taskData['local_id']),
            title: Value(taskData['title']),
            description: Value(taskData['description']),
            projectId: Value(taskData['project_id']),
            parentId: Value(taskData['parent_id']),
            taskCatalogId: Value(taskData['task_catalog_id']),
            assignedGroupId: Value(taskData['assigned_group_id']),
            status: Value(taskData['status'] ?? 'pending'),
            completionPercentage: Value(taskData['completion_percentage'] ?? 0),
            isSynced: const Value(true),
            lastLocallyUpdated: Value(taskData['last_locally_updated'] != null ? DateTime.parse(taskData['last_locally_updated']) : null),
          ),
        );
      }
      results['tasks'] = remoteTasks.length;

      // 5. Download Attendance
      final remoteAttendance = await supabase.from('attendance').select();
      for (final attendanceData in remoteAttendance) {
        await db.into(db.attendance).insertOnConflictUpdate(
          AttendanceCompanion(
            id: Value(attendanceData['id']),
            userId: Value(attendanceData['user_id']),
            projectId: Value(attendanceData['project_id']),
            checkIn: Value(DateTime.parse(attendanceData['check_in'])),
            checkOut: Value(attendanceData['check_out'] != null ? DateTime.parse(attendanceData['check_out']) : null),
            date: Value(DateTime.parse(attendanceData['date'])),
            status: Value(attendanceData['status'] ?? 'present'),
            isSynced: const Value(true),
          ),
        );
      }
      results['attendance'] = remoteAttendance.length;

      // 6. Download App Settings
      final remoteSettings = await supabase.from('app_settings').select();
      for (final settingData in remoteSettings) {
        await db.into(db.appSettings).insertOnConflictUpdate(
          AppSettingsCompanion(
            id: Value(settingData['id']),
            key: Value(settingData['key']),
            value: Value(settingData['value']),
            type: Value(settingData['type']),
            category: Value(settingData['category']),
            updatedAt: Value(DateTime.parse(settingData['updated_at'])),
            updatedBy: Value(settingData['updated_by']),
          ),
        );
      }
      results['app_settings'] = remoteSettings.length;

      return results;
    } catch (e) {
      debugPrint('Error downloading data: $e');
      rethrow;
    }
  }
}

// Background Worker Entry Point
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Initialize Supabase and Drift inside the isolate
    // Note: Re-acquiring env vars and initializing AppDatabase here
    // final db = AppDatabase();
    // final supabase = Supabase.instance.client; // Requires init
    // await SyncService(db, supabase).runSync();
    return Future.value(true);
  });
}
