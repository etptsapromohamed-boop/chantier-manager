import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chantier_manager/src/features/planning/data/planning_repository.dart';
import 'package:chantier_manager/src/features/core/data/local/app_database.dart';
import 'package:drift/drift.dart' as drift;

/// Tab 3: Gestion des Tâches avec Équipes
/// Displays tasks filtered by bloc and category with team assignments
class TasksTab extends ConsumerStatefulWidget {
  final String? projectId;

  const TasksTab({super.key, this.projectId});

  @override
  ConsumerState<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends ConsumerState<TasksTab> {
  String? _selectedBlocId;
  String? _selectedCategoryId;
  String _statusFilter = 'all'; // all, pending, in_progress, completed

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter Bar
        _buildFilterBar(),
        
        // Tasks List
        Expanded(
          child: _selectedBlocId == null
              ? _buildBlocSelector()
              : _buildTasksList(),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bloc Selector
          Row(
            children: [
              const Icon(Icons.layers, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Bloc:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBlocDropdown(),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Status Filter Chips
          const Text(
            'Statut:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildStatusChip('all', 'Tous', Colors.grey),
              _buildStatusChip('pending', 'En attente', Colors.orange),
              _buildStatusChip('in_progress', 'En cours', Colors.blue),
              _buildStatusChip('completed', 'Terminées', Colors.green),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Category Filter
          _buildCategoryFilter(),
        ],
      ),
    );
  }

  Widget _buildBlocDropdown() {
    if (widget.projectId == null) {
      return const Text('Sélectionnez un projet d\'abord');
    }

    final repository = ref.watch(planningRepositoryProvider);

    return FutureBuilder<List<Bloc>>(
      future: repository.getBlocsByProject(widget.projectId!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final blocs = snapshot.data!;

        if (blocs.isEmpty) {
          return const Text('Aucun bloc disponible');
        }

        return DropdownButton<String>(
          value: _selectedBlocId,
          isExpanded: true,
          hint: const Text('Sélectionner un bloc'),
          items: blocs.map((bloc) {
            return DropdownMenuItem(
              value: bloc.id,
              child: Text(bloc.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedBlocId = value;
            });
          },
        );
      },
    );
  }

  Widget _buildStatusChip(String value, String label, Color color) {
    final isSelected = _statusFilter == value;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _statusFilter = value;
        });
      },
      selectedColor: color.withOpacity(0.3),
      checkmarkColor: color,
    );
  }

  Widget _buildCategoryFilter() {
    final repository = ref.watch(planningRepositoryProvider);

    return FutureBuilder<List<TaskCategory>>(
      future: repository.getAllCategories(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final categories = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Catégorie:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                // All categories chip
                FilterChip(
                  label: const Text('Toutes'),
                  selected: _selectedCategoryId == null,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategoryId = null;
                    });
                  },
                ),
                ...categories.map((category) {
                  final isSelected = _selectedCategoryId == category.id;
                  final color = Color(
                    int.parse(category.color.replaceFirst('#', '0xFF')),
                  );

                  return FilterChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (category.icon != null)
                          Icon(
                            _getIconData(category.icon!),
                            size: 14,
                            color: isSelected ? Colors.white : color,
                          ),
                        const SizedBox(width: 4),
                        Text(category.name),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategoryId = selected ? category.id : null;
                      });
                    },
                    selectedColor: color,
                    backgroundColor: color.withOpacity(0.1),
                  );
                }),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildBlocSelector() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'Sélectionnez un bloc pour voir les tâches',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList() {
    final repository = ref.watch(planningRepositoryProvider);
    final db = ref.watch(appDatabaseProvider);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getFilteredTasks(repository, db),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Erreur: ${snapshot.error}'),
          );
        }

        final tasks = snapshot.data ?? [];

        if (tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                const Text(
                  'Aucune tâche trouvée',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return _TaskCard(
              taskData: tasks[index],
              onAssignTeam: () => _showAssignTeamDialog(tasks[index]['task'] as Task),
            );
          },
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _getFilteredTasks(
    PlanningRepository repository,
    AppDatabase db,
  ) async {
    if (_selectedBlocId == null) return [];

    // Get tasks with category
    final tasksWithCategory = await repository.getTasksWithCategory(_selectedBlocId!);

    // Apply status filter
    var filtered = tasksWithCategory.where((taskData) {
      final task = taskData['task'] as Task;
      
      if (_statusFilter != 'all' && task.status != _statusFilter) {
        return false;
      }
      
      if (_selectedCategoryId != null && task.categoryId != _selectedCategoryId) {
        return false;
      }
      
      return true;
    }).toList();

    // Get team assignments for each task
    for (var taskData in filtered) {
      final task = taskData['task'] as Task;
      
      // TODO: Implement task assignments table
      // Query assignments
      // final assignments = await (db.select(db.taskAssignments)
      //       ..where((t) => t.taskId.equals(task.id)))
      //     .get();

      taskData['team'] = null; // Placeholder until assignments table is created

      /*
      if (assignments.isNotEmpty) {
        // Get work group details
        final groupId = assignments.first.groupId;
        final group = await (db.select(db.workGroups)
              ..where((t) => t.id.equals(groupId)))
            .getSingleOrNull();

        taskData['team'] = group;

        // Get supervisor if exists
        if (group?.supervisorId != null) {
          final supervisor = await (db.select(db.users)
                ..where((t) => t.id.equals(group!.supervisorId!)))
              .getSingleOrNull();
          taskData['supervisor'] = supervisor;
        }
      }
    }

    return filtered;
  }

  void _showAssignTeamDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => _AssignTeamDialog(task: task),
    ).then((assigned) {
      if (assigned == true) {
        setState(() {}); // Refresh list
      }
    });
  }

  IconData _getIconData(String iconName) {
    final iconMap = {
      'construction': Icons.construction,
      'plumbing': Icons.plumbing,
      'electrical_services': Icons.electrical_services,
      'paint_rounded': Icons.format_paint,
      'foundation': Icons.foundation,
      'roofing': Icons.roofing,
      'window': Icons.window,
      'door_front': Icons.door_sliding,
    };

    return iconMap[iconName] ?? Icons.task_alt;
  }
}

// ========== TASK CARD WIDGET ==========
class _TaskCard extends StatelessWidget {
  final Map<String, dynamic> taskData;
  final VoidCallback onAssignTeam;

  const _TaskCard({
    required this.taskData,
    required this.onAssignTeam,
  });

  @override
  Widget build(BuildContext context) {
    final task = taskData['task'] as Task;
    final category = taskData['category'] as TaskCategory?;
    final team = taskData['team'] as WorkGroup?;
    final supervisor = taskData['supervisor'] as User?;

    final statusColor = _getStatusColor(task.status);
    final categoryColor = category != null
        ? Color(int.parse(category.color.replaceFirst('#', '0xFF')))
        : Colors.grey;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: categoryColor,
          child: category?.icon != null
              ? Icon(
                  _getIconData(category!.icon!),
                  color: Colors.white,
                  size: 20,
                )
              : const Icon(Icons.task_alt, color: Colors.white, size: 20),
        ),
        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description?.isNotEmpty == true) ...[
              const SizedBox(height: 4),
              Text(
                task.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                // Status badge
                Chip(
                  label: Text(
                    _getStatusLabel(task.status),
                    style: const TextStyle(fontSize: 11),
                  ),
                  backgroundColor: statusColor.withOpacity(0.2),
                  labelStyle: TextStyle(color: statusColor),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                
                // Category badge
                if (category != null)
                  Chip(
                    label: Text(
                      category.name,
                      style: const TextStyle(fontSize: 11),
                    ),
                    backgroundColor: categoryColor.withOpacity(0.2),
                    labelStyle: TextStyle(color: categoryColor),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                
                // Team badge
                if (team != null)
                  Chip(
                    avatar: const Icon(Icons.group, size: 14),
                    label: Text(
                      team.name,
                      style: const TextStyle(fontSize: 11),
                    ),
                    backgroundColor: Colors.blue.withOpacity(0.2),
                    labelStyle: const TextStyle(color: Colors.blue),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
              ],
            ),
            
            // Dates
            if (task.startDate != null || task.endDate != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    _formatDateRange(task.startDate, task.endDate),
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ],
            
            // Supervisor
            if (supervisor != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.person, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Chef: ${supervisor.firstName} ${supervisor.lastName}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                team == null ? Icons.group_add : Icons.group,
                color: team == null ? Colors.grey : Colors.blue,
              ),
              onPressed: onAssignTeam,
              tooltip: team == null ? 'Assigner équipe' : 'Modifier équipe',
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'blocked':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'completed':
        return 'Terminée';
      case 'in_progress':
        return 'En cours';
      case 'pending':
        return 'En attente';
      case 'blocked':
        return 'Bloquée';
      default:
        return status;
    }
  }

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null && end == null) return '';
    
    final dateFormat = (DateTime date) => '${date.day}/${date.month}/${date.year}';
    
    if (start != null && end != null) {
      return '${dateFormat(start)} - ${dateFormat(end)}';
    } else if (start != null) {
      return 'Début: ${dateFormat(start)}';
    } else {
      return 'Fin: ${dateFormat(end!)}';
    }
  }

  IconData _getIconData(String iconName) {
    final iconMap = {
      'construction': Icons.construction,
      'plumbing': Icons.plumbing,
      'electrical_services': Icons.electrical_services,
      'paint_rounded': Icons.format_paint,
      'foundation': Icons.foundation,
      'roofing': Icons.roofing,
      'window': Icons.window,
      'door_front': Icons.door_sliding,
    };

    return iconMap[iconName] ?? Icons.task_alt;
  }
}

// ========== ASSIGN TEAM DIALOG ==========
class _AssignTeamDialog extends ConsumerStatefulWidget {
  final Task task;

  const _AssignTeamDialog({required this.task});

  @override
  ConsumerState<_AssignTeamDialog> createState() => _AssignTeamDialogState();
}

class _AssignTeamDialogState extends ConsumerState<_AssignTeamDialog> {
  WorkGroup? _selectedTeam;

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(appDatabaseProvider);

    return AlertDialog(
      title: const Text('Assigner une Équipe'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tâche: ${widget.task.title}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Sélectionner une équipe:'),
            const SizedBox(height: 12),
            FutureBuilder<List<WorkGroup>>(
              future: db.select(db.workGroups).get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final teams = snapshot.data!;

                if (teams.isEmpty) {
                  return const Text('Aucune équipe disponible');
                }

                return Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: teams.length,
                    itemBuilder: (context, index) {
                      final team = teams[index];
                      final isSelected = _selectedTeam?.id == team.id;

                      return Card(
                        color: isSelected ? Colors.blue.shade50 : null,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                isSelected ? Colors.blue : Colors.grey,
                            child: const Icon(Icons.group, color: Colors.white),
                          ),
                          title: Text(team.name),
                          subtitle: FutureBuilder<User?>(
                            future: team.supervisorId != null
                                ? (db.select(db.users)
                                      ..where((t) =>
                                          t.id.equals(team.supervisorId!)))
                                    .getSingleOrNull()
                                : Future.value(null),
                            builder: (context, supervisorSnapshot) {
                              if (supervisorSnapshot.hasData) {
                                final supervisor = supervisorSnapshot.data!;
                                return Text(
                                  'Chef: ${supervisor.firstName} ${supervisor.lastName}',
                                );
                              }
                              return const Text('Pas de chef');
                            },
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle, color: Colors.blue)
                              : null,
                          onTap: () {
                            setState(() {
                              _selectedTeam = team;
                            });
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _selectedTeam == null ? null : _assign,
          child: const Text('Assigner'),
        ),
      ],
    );
  }

  void _assign() async {
    if (_selectedTeam == null) return;

    final db = ref.read(appDatabaseProvider);

    try {
      // TODO: Implement task assignments table
      // Check if assignment already exists
      // final existing = await (db.select(db.taskAssignments)
      //       ..where((t) => t.taskId.equals(widget.task.id)))
      //     .get();

      // Placeholder: Direct work group assignment to task
      final repository = ref.read(planningRepositoryProvider);
      
      /*
      if (existing.isNotEmpty) {
        // Update existing
        await (db.update(db.taskAssignments)
              ..where((t) => t.taskId.equals(widget.task.id)))
            .write(TaskAssignmentsCompanion(
          groupId: drift.Value(_selectedTeam!.id),
        ));
      } else {
        // Create new
        await db.into(db.taskAssignments).insert(
              TaskAssignmentsCompanion.insert(
                taskId: widget.task.id,
                groupId: _selectedTeam!.id,
              ),
            );
      }
      */
      
      // For now, update the task's assignedGroupId directly
      await (db.update(db.tasks)
            ..where((t) => t.id.equals(widget.task.id)))
          .write(TasksCompanion(
        assignedGroupId: drift.Value(_selectedTeam!.id),
      ));

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Équipe assignée avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
