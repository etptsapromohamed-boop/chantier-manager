import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chantier_manager/src/features/planning/data/planning_repository.dart';
import 'package:chantier_manager/src/features/planning/presentation/widgets/organization_tab.dart';
import 'package:chantier_manager/src/features/planning/presentation/widgets/tasks_tab.dart';

class PlanningScreen extends ConsumerStatefulWidget {
  const PlanningScreen({super.key});

  @override
  ConsumerState<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends ConsumerState<PlanningScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedProjectId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Planning'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.account_tree), text: 'Organisation'),
            Tab(icon: Icon(Icons.timeline), text: 'Gantt'),
            Tab(icon: Icon(Icons.task), text: 'Tâches'),
            Tab(icon: Icon(Icons.assessment), text: 'Rapports'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          OrganizationTab(
            onProjectSelected: (projectId) {
              setState(() {
                _selectedProjectId = projectId;
              });
            },
          ),
          const _GanttTab(),
          TasksTab(projectId: _selectedProjectId),
          const _ReportsTab(),
        ],
      ),
    );
  }
}

// ========== TAB 2: GANTT ==========
class _GanttTab extends ConsumerWidget {
  const _GanttTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timeline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Planning Gantt',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Timeline visuelle interactive'),
        ],
      ),
    );
  }
}

// ========== TAB 4: REPORTS ==========
class _ReportsTab extends ConsumerWidget {
  const _ReportsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assessment, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Rapports d\'Avancement',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Rapports journaliers avec photos'),
        ],
      ),
    );
  }
}
