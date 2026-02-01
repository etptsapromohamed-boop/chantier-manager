import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chantier_manager/src/features/core/data/local/app_database.dart';
import 'package:chantier_manager/src/features/sync/application/sync_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'sync_provider.g.dart';

@Riverpod(keepAlive: true)
SyncService syncService(SyncServiceRef ref) {
  final db = ref.watch(appDatabaseProvider);
  final supabase = Supabase.instance.client;
  return SyncService(db, supabase);
}
