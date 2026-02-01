import 'package:chantier_manager/src/features/dashboard/presentation/admin_dashboard.dart';
import 'package:chantier_manager/src/features/tasks/presentation/create_task_screen.dart';
import 'package:chantier_manager/src/features/attendance/presentation/attendance_screen.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'src/features/sync/application/sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Background Sync (Mobile Only)
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true 
    );
  }

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://jbbukuhbujofscseimjl.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpiYnVrdWhidWpvZnNjc2VpbWpsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk4ODgzMDUsImV4cCI6MjA4NTQ2NDMwNX0.53K8XD8boxQVUjwxpuv-rkb1LQtZ5Bc3HJxSOD7CCiA',
  );

  runApp(
    const ProviderScope(
      child: ChantierManagerApp(),
    ),
  );
}

class ChantierManagerApp extends StatelessWidget {
  const ChantierManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chantier Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Simple Routing for Demo
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chantier Manager Test")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateTaskScreen())),
              child: const Text("Supervisor: Create Task"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceScreen())),
              child: const Text("Supervisor: Attendance"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboard())),
              child: const Text("Admin: Dashboard"),
            ),
          ],
        ),
      ),
    );
  }
}
