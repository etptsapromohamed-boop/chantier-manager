import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chantier_manager/src/features/teams/data/group_repository.dart';
import 'package:chantier_manager/src/features/teams/data/user_repository.dart';
import 'package:chantier_manager/src/features/teams/application/team_print_service.dart';
import 'package:chantier_manager/src/features/core/data/local/app_database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

class GroupManagementScreen extends ConsumerStatefulWidget {
  const GroupManagementScreen({super.key});

  @override
  ConsumerState<GroupManagementScreen> createState() => _GroupManagementScreenState();
}

class _GroupManagementScreenState extends ConsumerState<GroupManagementScreen> {

  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(groupsStreamProvider);
    final repo = ref.watch(groupRepositoryProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showGroupDialog(context, null),
        label: const Text("Nouvelle Sous-Équipe"),
        icon: const Icon(Icons.group_add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Gestion des Sous-Équipes", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const Text("Organisez vos ouvriers par équipe de travail.", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          
          Expanded(
            child: groupsAsync.when(
              data: (groups) {
                if (groups.isEmpty) {
                  return const Center(child: Text("Aucune sous-équipe créée."));
                }
                return ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    return _GroupCard(group: groups[index]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text("Erreur: $err")),
            ),
          ),
        ],
      ),
    );
  }

  void _showGroupDialog(BuildContext context, WorkGroup? group) async {
    final isEditing = group != null;
    final nameController = TextEditingController(text: group?.name ?? '');
    String? selectedSupervisorId = group?.supervisorId;
    
    final supervisors = await ref.read(groupRepositoryProvider).getSupervisors();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isEditing ? "Modifier Équipe" : "Nouvelle Équipe"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nom de l'équipe"),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedSupervisorId,
                items: supervisors.map((s) => DropdownMenuItem(
                  value: s.id,
                  child: Text("${s.firstName} ${s.lastName}"),
                )).toList(),
                onChanged: (val) => setState(() => selectedSupervisorId = val),
                decoration: const InputDecoration(labelText: "Superviseur Responsable"),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Annuler")),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty) return;
                
                final repo = ref.read(groupRepositoryProvider);
                final companion = WorkGroupsCompanion(
                  id: drift.Value(isEditing ? group.id : const Uuid().v4()),
                  name: drift.Value(nameController.text),
                  supervisorId: drift.Value(selectedSupervisorId),
                );

                if (isEditing) {
                  await repo.updateGroup(companion);
                } else {
                  await repo.addGroup(companion);
                }
                
                if (mounted) Navigator.pop(ctx);
              },
              child: Text(isEditing ? "Enregistrer" : "Créer"),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupCard extends ConsumerWidget {
  final WorkGroup group;
  const _GroupCard({required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(groupMembersProvider(group.id));
    final repo = ref.watch(groupRepositoryProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(group.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: FutureBuilder<User?>(
          future: repo.getUserById(group.supervisorId),
          builder: (context, snapshot) {
            final supervisor = snapshot.data;
            return Text("Lead: ${supervisor != null ? '${supervisor.firstName} ${supervisor.lastName}' : 'Non assigné'}");
          }
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.print, color: Colors.blueGrey),
              tooltip: "Imprimer la liste de l'équipe",
              onPressed: () async {
                final leader = await repo.getUserById(group.supervisorId);
                final members = await ref.read(groupRepositoryProvider).getMembers(group.id);
                await TeamPrintService.printTeamReport(group, leader, members);
              },
            ),
            IconButton(
              icon: const Icon(Icons.person_add, color: Colors.green),
              tooltip: "Ajouter un membre",
              onPressed: () => _showAddMemberDialog(context, ref),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              tooltip: "Modifier l'équipe",
              onPressed: () {
                final screen = context.findAncestorStateOfType<_GroupManagementScreenState>();
                screen?._showGroupDialog(context, group);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: "Supprimer l'équipe",
              onPressed: () => _confirmDelete(context, ref),
            ),
          ],
        ),
        children: [
          membersAsync.when(
            data: (members) {
              if (members.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Aucun membre dans cette équipe.", style: TextStyle(fontStyle: FontStyle.italic)),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: members.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final member = members[index];
                  return ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: Text("${member.firstName} ${member.lastName}"),
                    subtitle: Text(member.exactPosition ?? 'Ouvrier'),
                    trailing: IconButton(
                      icon: const Icon(Icons.swap_horiz, color: Colors.blue),
                      tooltip: "Transférer vers une autre équipe",
                      onPressed: () => _showTransferDialog(context, ref, member),
                    ),
                  );
                },
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (err, __) => Text("Erreur: $err"),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Supprimer l'équipe"),
        content: const Text("Voulez-vous vraiment supprimer cette sous-équipe ? Les membres seront dissociés."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Annuler")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Supprimer", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(groupRepositoryProvider).deleteGroup(group.id);
    }
  }

  void _showAddMemberDialog(BuildContext context, WidgetRef ref) async {
    final available = await ref.read(groupRepositoryProvider).getAvailableWorkers();
    final List<String> selectedIds = [];

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text("Ajouter des membres (${selectedIds.length})"),
          content: SizedBox(
            width: 400,
            height: 400,
            child: available.isEmpty 
              ? const Center(child: Text("Aucun ouvrier disponible."))
              : ListView.builder(
                  itemCount: available.length,
                  itemBuilder: (context, index) {
                    final worker = available[index];
                    final isSelected = selectedIds.contains(worker.id);
                    return CheckboxListTile(
                      title: Text("${worker.firstName} ${worker.lastName}"),
                      subtitle: Text(worker.exactPosition ?? 'Ouvrier'),
                      value: isSelected,
                      onChanged: (val) {
                        setDialogState(() {
                          if (val == true) {
                            selectedIds.add(worker.id);
                          } else {
                            selectedIds.remove(worker.id);
                          }
                        });
                      },
                    );
                  },
                ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: selectedIds.isEmpty ? null : () async {
                final repo = ref.read(groupRepositoryProvider);
                final errors = await repo.bulkTransferUsers(selectedIds, group.id);
                
                if (ctx.mounted) {
                  if (errors.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Terminé avec des erreurs: ${errors.join(', ')}"),
                        backgroundColor: Colors.orange,
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Membres ajoutés avec succès"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                  Navigator.pop(ctx);
                }
              },
              child: Text("Ajouter (${selectedIds.length})"),
            ),
          ],
        ),
      ),
    );
  }

  void _showTransferDialog(BuildContext context, WidgetRef ref, User member) async {
    final allGroups = await ref.read(groupRepositoryProvider).getAllGroups();
    final otherGroups = allGroups.where((g) => g.id != group.id).toList();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Transférer ${member.firstName}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Choisissez la nouvelle équipe :"),
            const SizedBox(height: 10),
            ...otherGroups.map((g) => ListTile(
              title: Text(g.name),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () async {
                final error = await ref.read(groupRepositoryProvider).transferUser(member.id, g.id);
                if (error != null) {
                   if (ctx.mounted) {
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
                   }
                } else {
                   if (ctx.mounted) {
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Transfert réussi"), backgroundColor: Colors.green));
                   }
                }
                if (ctx.mounted) Navigator.pop(ctx);
              },
            )),
            ListTile(
              title: const Text("Retirer de l'équipe (Aucune)"),
              textColor: Colors.red,
              onTap: () async {
                final error = await ref.read(groupRepositoryProvider).transferUser(member.id, null);
                if (error != null) {
                   if (ctx.mounted) {
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
                   }
                }
                if (ctx.mounted) Navigator.pop(ctx);
              },
            )
          ],
        ),
      ),
    );
  }
}

// --- PROVIDERS ---

final groupsStreamProvider = StreamProvider.autoDispose<List<WorkGroup>>((ref) {
  return ref.watch(groupRepositoryProvider).watchAllGroups();
});

final groupMembersProvider = StreamProvider.autoDispose.family<List<User>, String>((ref, groupId) {
  return ref.watch(groupRepositoryProvider).watchMembers(groupId);
});
