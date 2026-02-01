import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chantier_manager/src/features/core/data/local/app_database.dart';

part 'planning_repository.g.dart';

@Riverpod(keepAlive: true)
PlanningRepository planningRepository(PlanningRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return PlanningRepository(db);
}

class PlanningRepository {
  final AppDatabase _db;

  PlanningRepository(this._db);

  // ========== ILOTS ==========

  /// Get all ilots for a project
  Future<List<Ilot>> getIlotsByProject(String projectId) async {
    return (_db.select(_db.ilots)
          ..where((t) => t.projectId.equals(projectId))
          ..orderBy([(t) => OrderingTerm(expression: t.order)]))
        .get();
  }

  /// Get a single ilot by ID
  Future<Ilot?> getIlot(String id) async {
    return (_db.select(_db.ilots)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Create a new ilot
  Future<void> createIlot(IlotsCompanion ilot) async {
    await _db.into(_db.ilots).insert(ilot);
  }

  /// Update an existing ilot
  Future<void> updateIlot(String id, IlotsCompanion ilot) async {
    await (_db.update(_db.ilots)..where((t) => t.id.equals(id))).write(ilot);
  }

  /// Delete an ilot
  Future<void> deleteIlot(String id) async {
    await (_db.delete(_db.ilots)..where((t) => t.id.equals(id))).go();
  }

  // ========== BLOCS ==========

  /// Get all blocs for an ilot
  Future<List<Bloc>> getBlocsByIlot(String ilotId) async {
    return (_db.select(_db.blocs)
          ..where((t) => t.ilotId.equals(ilotId))
          ..orderBy([(t) => OrderingTerm(expression: t.order)]))
        .get();
  }

  /// Get a single bloc by ID
  Future<Bloc?> getBloc(String id) async {
    return (_db.select(_db.blocs)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Create a new bloc
  Future<void> createBloc(BlocsCompanion bloc) async {
    await _db.into(_db.blocs).insert(bloc);
  }

  /// Update an existing bloc
  Future<void> updateBloc(String id, BlocsCompanion bloc) async {
    await (_db.update(_db.blocs)..where((t) => t.id.equals(id))).write(bloc);
  }

  /// Delete a bloc
  Future<void> deleteBloc(String id) async {
    await (_db.delete(_db.blocs)..where((t) => t.id.equals(id))).go();
  }

  // ========== TASK CATEGORIES ==========

  /// Get all task categories
  Future<List<TaskCategory>> getAllCategories() async {
    return (_db.select(_db.taskCategories)
          ..orderBy([(t) => OrderingTerm(expression: t.order)]))
        .get();
  }

  /// Get a single category by ID
  Future<TaskCategory?> getCategory(String id) async {
    return (_db.select(_db.taskCategories)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Create a new category
  Future<void> createCategory(TaskCategoriesCompanion category) async {
    await _db.into(_db.taskCategories).insert(category);
  }

  /// Update an existing category
  Future<void> updateCategory(String id, TaskCategoriesCompanion category) async {
    await (_db.update(_db.taskCategories)..where((t) => t.id.equals(id)))
        .write(category);
  }

  /// Delete a category
  Future<void> deleteCategory(String id) async {
    await (_db.delete(_db.taskCategories)..where((t) => t.id.equals(id))).go();
  }

  // ========== HIERARCHICAL QUERIES ==========

  /// Get complete hierarchy for a project (Project → Ilots → Blocs)
  Future<Map<String, dynamic>> getProjectHierarchy(String projectId) async {
    final project = await (_db.select(_db.projects)
          ..where((t) => t.id.equals(projectId)))
        .getSingleOrNull();

    if (project == null) return {};

    final ilots = await getIlotsByProject(projectId);
    final hierarchy = <String, dynamic>{
      'project': project,
      'ilots': [],
    };

    for (final ilot in ilots) {
      final blocs = await getBlocsByIlot(ilot.id);
      hierarchy['ilots'].add({
        'ilot': ilot,
        'blocs': blocs,
      });
    }

    return hierarchy;
  }

  /// Get tasks for a specific bloc with category information
  Future<List<Map<String, dynamic>>> getTasksWithCategory(String blocId) async {
    final query = _db.select(_db.tasks).join([
      leftOuterJoin(_db.taskCategories,
          _db.taskCategories.id.equalsExp(_db.tasks.categoryId)),
    ])
      ..where(_db.tasks.blocId.equals(blocId));

    final results = await query.get();

    return results.map((row) {
      return {
        'task': row.readTable(_db.tasks),
        'category': row.readTableOrNull(_db.taskCategories),
      };
    }).toList();
  }

  /// Get progress statistics for an ilot
  Future<Map<String, dynamic>> getIlotProgress(String ilotId) async {
    final blocs = await getBlocsByIlot(ilotId);
    int totalTasks = 0;
    int completedTasks = 0;
    double totalProgress = 0;

    for (final bloc in blocs) {
      final tasks = await (_db.select(_db.tasks)
            ..where((t) => t.blocId.equals(bloc.id)))
          .get();

      totalTasks += tasks.length;
      for (final task in tasks) {
        if (task.status == 'validated') {
          completedTasks++;
        }
        totalProgress += task.completionPercentage;
      }
    }

    final avgProgress = totalTasks > 0 ? (totalProgress / totalTasks).round() : 0;

    return {
      'ilot_id': ilotId,
      'bloc_count': blocs.length,
      'total_tasks': totalTasks,
      'completed_tasks': completedTasks,
      'average_progress': avgProgress,
    };
  }

  /// Get progress statistics for a bloc
  Future<Map<String, dynamic>> getBlocProgress(String blocId) async {
    final tasks = await (_db.select(_db.tasks)
          ..where((t) => t.blocId.equals(blocId)))
        .get();

    int completedTasks = 0;
    double totalProgress = 0;

    for (final task in tasks) {
      if (task.status == 'validated') {
        completedTasks++;
      }
      totalProgress += task.completionPercentage;
    }

    final avgProgress = tasks.isNotEmpty ? (totalProgress / tasks.length).round() : 0;

    return {
      'bloc_id': blocId,
      'total_tasks': tasks.length,
      'completed_tasks': completedTasks,
      'average_progress': avgProgress,
    };
  }
}
