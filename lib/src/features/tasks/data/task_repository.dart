import 'package:chantier_manager/src/features/core/data/local/app_database.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class TaskRepository {
  final AppDatabase db;
  final Uuid uuid;

  TaskRepository(this.db, {this.uuid = const Uuid()});

  /// Create a task offline-first
  Future<void> createTask({
    required String title,
    required String projectId,
    String? description,
    String? hierarchyNodeId,
  }) async {
    final taskId = uuid.v4();
    
    // 1. Transaction to ensure Atomicity
    await db.transaction(() async {
      // A. Write to Local Table
      await db.into(db.tasks).insert(TasksCompanion(
        id: Value(taskId),
        title: Value(title),
        description: Value(description),
        projectId: Value(projectId),
        parentId: Value(hierarchyNodeId),
        status: const Value('pending'),
        isSynced: const Value(false),
        lastLocallyUpdated: Value(DateTime.now()),
      ));

      // B. Add to Sync Queue
      final payload = {
        'id': taskId,
        'title': title,
        'description': description,
        'project_id': projectId,
        'hierarchy_node_id': hierarchyNodeId,
        'created_at': DateTime.now().toIso8601String(),
        // Add other fields...
      };

      await db.into(db.syncQueue).insert(SyncQueueCompanion(
        actionType: const Value('INSERT'),
        targetTable: const Value('tasks'),
        payload: Value(payload),
        status: const Value('PENDING'),
      ));
    });

    // C. Trigger Sync (Fire and forget or managed by service)
    // syncService.runSync();
  }

  /// Add Media to Task
  Future<void> addTaskMedia({
    required String taskId,
    required String localPath,
    required String type, // image, audio
  }) async {
    final mediaId = uuid.v4();
    final storagePath = 'tasks/$taskId/$mediaId.${type == 'image' ? 'jpg' : 'aac'}';

    await db.transaction(() async {
      // A. Local Record
      await db.into(db.taskMedia).insert(TaskMediaCompanion(
        id: Value(mediaId),
        taskId: Value(taskId),
        type: Value(type),
        localPath: Value(localPath),
        isUploaded: const Value(false),
      ));

      // B. Queue Upload
      await db.into(db.syncQueue).insert(SyncQueueCompanion(
        actionType: const Value('UPLOAD_MEDIA'),
        targetTable: const Value('task_media'), // Logical grouping
        payload: Value({
          'local_path': localPath,
          'storage_path': storagePath,
          'media_record_id': mediaId,
        }),
      ));

      // C. Queue DB Insert (Dependent on Upload?)
      // We can insert the DB record reference immediately or wait.
      // Ideally, we queue the DB insert but with a placeholder URL or wait for upload.
      // For simplicity here: we assume the SyncService handles the flow.
    });
  }
}
