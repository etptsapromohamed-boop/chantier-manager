import 'package:drift/drift.dart';
import 'dart:convert';
import 'package:chantier_manager/src/features/core/data/local/connection/connection_stub.dart'
    if (dart.library.io) 'package:chantier_manager/src/features/core/data/local/connection/connection_native.dart'
    if (dart.library.js_interop) 'package:chantier_manager/src/features/core/data/local/connection/connection_web.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  return AppDatabase();
}

// --- TYPE CONVERTERS ---
class JsonConverter extends TypeConverter<Map<String, dynamic>, String> {
  const JsonConverter();
  @override
  Map<String, dynamic> fromSql(String fromDb) {
    return json.decode(fromDb) as Map<String, dynamic>;
  }

  @override
  String toSql(Map<String, dynamic> value) {
    return json.encode(value);
  }
}

// --- TABLES ---

// Mirroring Supabase 'users'
class Users extends Table {
  TextColumn get id => text()(); // UUID as String
  TextColumn get role => text()(); // 'worker', 'supervisor', 'admin'
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get idCardNumber => text().nullable()();
  TextColumn get exactPosition => text().nullable()(); // 'Poste exacte'
  TextColumn get password => text().nullable()();
  TextColumn get profilePicturePath => text().nullable()(); // [NEW] Added for user profile photos
  TextColumn get idCardFrontPath => text().nullable()();
  TextColumn get idCardBackPath => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get groupId => text().nullable().references(WorkGroups, #id)(); // [NEW] Link to Sub-team

  @override
  Set<Column> get primaryKey => {id};
}

// [NEW] Table for Sous-équipes
class WorkGroups extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get supervisorId => text().nullable()(); // Removed explicit reference to break circular dependency
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Mirroring 'projects'
class Projects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get geofenceLat => real()();
  RealColumn get geofenceLong => real()();
  RealColumn get geofenceRadiusMeters => real().withDefault(const Constant(100.0))();

  @override
  Set<Column> get primaryKey => {id};
}

// Mirroring 'tasks'
class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get localId => text().nullable()(); // For offline creation reference
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get projectId => text().references(Projects, #id)();
  TextColumn get parentId => text().nullable()(); // hierarchy_node_id
  TextColumn get taskCatalogId => text().nullable()();
  TextColumn get assignedGroupId => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // 'pending', 'validated'
  IntColumn get completionPercentage => integer().withDefault(const Constant(0))();
  
  // NEW: Planning module fields
  TextColumn get blocId => text().nullable()(); // Will reference Blocs table
  TextColumn get categoryId => text().nullable()(); // Will reference TaskCategories table
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  IntColumn get priority => integer().withDefault(const Constant(0))(); // 1-5
  
  // Handling conflicts/sync
  BoolColumn get isSynced => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastLocallyUpdated => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// NEW: Planning - Ilots (sections/zones of project)
class Ilots extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().references(Projects, #id)();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get order => integer()();
  TextColumn get color => text().nullable()(); // Hex color code
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  @override
  Set<Column> get primaryKey => {id};
}

// NEW: Planning - Blocs (subdivisions of an ilot)
class Blocs extends Table {
  TextColumn get id => text()();
  TextColumn get ilotId => text().references(Ilots, #id)();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get order => integer()();
  IntColumn get totalFloors => integer().nullable()();
  RealColumn get surface => real().nullable()(); // Surface in m²
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  @override
  Set<Column> get primaryKey => {id};
}

// NEW: Planning - Task Categories
class TaskCategories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get color => text()(); // Hex color
  TextColumn get icon => text().nullable()(); // Material icon name
  IntColumn get order => integer()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// Mirroring 'task_media'
class TaskMedia extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().references(Tasks, #id)();
  TextColumn get type => text()(); // 'image', 'audio'
  TextColumn get localPath => text().nullable()();
  TextColumn get storageUrl => text().nullable()();
  BoolColumn get isUploaded => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// Mirroring 'attendance'
class Attendance extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get projectId => text().nullable().references(Projects, #id)();
  DateTimeColumn get checkIn => dateTime()();
  DateTimeColumn get checkOut => dateTime().nullable()();
  DateTimeColumn get date => dateTime()(); // For grouping by day
  TextColumn get status => text().withDefault(const Constant('present'))(); // 'present', 'absent', 'late'
  BoolColumn get isSynced => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

// --- SYNC QUEUE SYSTEM TABLE ---
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get actionType => text()(); // 'INSERT', 'UPDATE', 'DELETE', 'UPLOAD_MEDIA'
  TextColumn get targetTable => text()(); // 'tasks', 'attendance', 'media'
  TextColumn get payload => text().map(const JsonConverter())(); // JSON data
  TextColumn get localId => text().nullable()(); // ID of the formatted record
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('PENDING'))(); // PENDING, PROCESSING, FAILED
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// [NEW] Table for Application Settings
class AppSettings extends Table {
  TextColumn get id => text()();
  TextColumn get key => text().unique()();
  TextColumn get value => text()(); // JSON encoded value
  TextColumn get type => text()(); // 'string', 'int', 'bool', 'image', 'color'
  TextColumn get category => text()(); // 'company', 'attendance', 'export', etc.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get updatedBy => text().nullable()(); // User ID who updated

  @override
  Set<Column> get primaryKey => {id};
}

// NEW: Finance - Cash Box (Caisses)
class CashBox extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get projectId => text().nullable().references(Projects, #id)();
  RealColumn get initialBalance => real().withDefault(const Constant(0.0))();
  RealColumn get currentBalance => real().withDefault(const Constant(0.0))();
  TextColumn get currency => text().withDefault(const Constant('TND'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get createdBy => text().references(Users, #id)();
  
  @override
  Set<Column> get primaryKey => {id};
}

// NEW: Finance - Transaction Categories
class TransactionCategories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()(); // 'income', 'expense', 'both'
  TextColumn get icon => text().nullable()();
  TextColumn get color => text()();
  IntColumn get order => integer()();
  BoolColumn get isUserRelated => boolean().withDefault(const Constant(false))(); // For salaries/advances
  
  @override
  Set<Column> get primaryKey => {id};
}

// NEW: Finance - Transactions
class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get cashboxId => text().references(CashBox, #id)();
  TextColumn get type => text()(); // 'income' or 'expense'
  RealColumn get amount => real()();
  TextColumn get categoryId => text().references(TransactionCategories, #id)();
  TextColumn get description => text()();
  TextColumn get reference => text().nullable()(); // Invoice number, receipt
  DateTimeColumn get date => dateTime()();
  TextColumn get createdBy => text().references(Users, #id)(); // Who created transaction
  TextColumn get relatedUserId => text().nullable().references(Users, #id)(); // For worker advances/salaries
  TextColumn get attachmentPath => text().nullable()(); // Invoice photo
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  Users, 
  WorkGroups, 
  Projects, 
  Tasks, 
  TaskMedia, 
  Attendance, 
  SyncQueue, 
  AppSettings,
  // Planning Module
  Ilots,
  Blocs,
  TaskCategories,
  // Finance Module
  CashBox,
  TransactionCategories,
  Transactions,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 8) {
          // Add Planning tables
          await m.createTable(ilots);
          await m.createTable(blocs);
          await m.createTable(taskCategories);
          
          // Add Finance tables
          await m.createTable(cashBox);
          await m.createTable(transactionCategories);
          await m.createTable(transactions);
          
          // Add new columns to Tasks
          await m.addColumn(tasks, tasks.blocId);
          await m.addColumn(tasks, tasks.categoryId);
          await m.addColumn(tasks, tasks.startDate);
          await m.addColumn(tasks, tasks.endDate);
          await m.addColumn(tasks, tasks.priority);
        }
        if (from < 7) {
          await m.createTable(appSettings);
        }
        if (from < 6) {
          await m.createTable(workGroups);
          await m.addColumn(users, users.groupId);
        }
        if (from < 5) {
          // Add profilePicturePath to users
          try {
            await m.addColumn(users, users.profilePicturePath);
          } catch (e) {
            // Already handled in previous steps or manual intervention
          }
        }
        if (from < 4) {
          // Add Attendance table
          await m.deleteTable('attendance'); 
          await m.createTable(attendance);
        }
      },
    );
  }
}
