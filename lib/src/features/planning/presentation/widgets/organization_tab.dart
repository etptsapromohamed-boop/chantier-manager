import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chantier_manager/src/features/planning/data/planning_repository.dart';
import 'package:chantier_manager/src/features/core/data/local/app_database.dart';
import 'package:drift/drift.dart' as drift;

/// Tab 1: Organisation Hiérarchique
/// Displays Project → Ilots → Blocs → Tasks in expandable tree format
class OrganizationTab extends ConsumerStatefulWidget {
  final String? projectId;

  const OrganizationTab({super.key, this.projectId});

  @override
  ConsumerState<OrganizationTab> createState() => _OrganizationTabState();
}

class _OrganizationTabState extends ConsumerState<OrganizationTab> {
  String? _selectedProjectId;

  @override
  void initState() {
    super.initState();
    _selectedProjectId = widget.projectId;
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedProjectId == null) {
      return _buildProjectSelector();
    }

    return _buildHierarchyView();
  }

  Widget _buildProjectSelector() {
    final db = ref.watch(appDatabaseProvider);
    
    return FutureBuilder<List<Project>>(
      future: db.select(db.projects).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final projects = snapshot.data!;

        if (projects.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.folder_open, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('Aucun projet disponible'),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to create project
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Créer un Projet'),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              '📁 Sélectionner un Projet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...projects.map((project) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.business),
                ),
                title: Text(project.name),
                subtitle: Text('Lat: ${project.geofenceLat.toStringAsFixed(4)}, Long: ${project.geofenceLong.toStringAsFixed(4)}'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  setState(() {
                    _selectedProjectId = project.id;
                  });
                },
              ),
            )),
          ],
        );
      },
    );
  }

  Widget _buildHierarchyView() {
    final repository = ref.watch(planningRepositoryProvider);

    return FutureBuilder<Map<String, dynamic>>(
      future: repository.getProjectHierarchy(_selectedProjectId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Erreur: ${snapshot.error}'),
          );
        }

        final hierarchy = snapshot.data!;
        final project = hierarchy['project'] as Project?;
        final ilots = hierarchy['ilots'] as List<dynamic>;

        if (project == null) {
          return const Center(child: Text('Projet non trouvé'));
        }

        return Column(
          children: [
            // Header with project info and back button
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade50,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        _selectedProjectId = null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Rayon: ${project.geofenceRadiusMeters.toStringAsFixed(0)}m',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddIlotDialog(project.id),
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter Ilot'),
                  ),
                ],
              ),
            ),

            // Hierarchy tree
            Expanded(
              child: ilots.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: ilots.length,
                      itemBuilder: (context, index) {
                        final ilotData = ilots[index];
                        final ilot = ilotData['ilot'] as Ilot;
                        final blocs = ilotData['blocs'] as List<Bloc>;

                        return _IlotCard(
                          ilot: ilot,
                          blocs: blocs,
                          onAddBloc: () => _showAddBlocDialog(ilot.id),
                          onEdit: () => _showEditIlotDialog(ilot),
                          onDelete: () => _deleteIlot(ilot.id),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.layers, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'Aucun ilot dans ce projet',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Commencez par créer le premier ilot',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showAddIlotDialog(String projectId) {
    showDialog(
      context: context,
      builder: (context) => _AddIlotDialog(projectId: projectId),
    ).then((_) => setState(() {})); // Refresh on dialog close
  }

  void _showAddBlocDialog(String ilotId) {
    showDialog(
      context: context,
      builder: (context) => _AddBlocDialog(ilotId: ilotId),
    ).then((_) => setState(() {}));
  }

  void _showEditIlotDialog(Ilot ilot) {
    showDialog(
      context: context,
      builder: (context) => _AddIlotDialog(
        projectId: ilot.projectId,
        existingIlot: ilot,
      ),
    ).then((_) => setState(() {}));
  }

  void _deleteIlot(String ilotId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer cet ilot ? '
          'Tous les blocs associés seront également supprimés.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final repository = ref.read(planningRepositoryProvider);
      await repository.deleteIlot(ilotId);
      setState(() {});
    }
  }
}

// ========== ILOT CARD WIDGET ==========
class _IlotCard extends StatefulWidget {
  final Ilot ilot;
  final List<Bloc> blocs;
  final VoidCallback onAddBloc;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _IlotCard({
    required this.ilot,
    required this.blocs,
    required this.onAddBloc,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_IlotCard> createState() => _IlotCardState();
}

class _IlotCardState extends State<_IlotCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.ilot.color != null
        ? Color(int.parse(widget.ilot.color!.replaceFirst('#', '0xFF')))
        : Colors.blue;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: color,
              child: Text(
                '${widget.ilot.order}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              widget.ilot.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: widget.ilot.description != null
                ? Text(widget.ilot.description!)
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Chip(
                  label: Text('${widget.blocs.length} blocs'),
                  backgroundColor: color.withOpacity(0.2),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: widget.onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: widget.onDelete,
                ),
                IconButton(
                  icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
              ],
            ),
          ),
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '🏢 Blocs (${widget.blocs.length})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: widget.onAddBloc,
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Ajouter Bloc'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (widget.blocs.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Aucun bloc dans cet ilot',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ...widget.blocs.map((bloc) => _BlocTile(bloc: bloc)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ========== BLOC TILE WIDGET ==========
class _BlocTile extends StatelessWidget {
  final Bloc bloc;

  const _BlocTile({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.grey[50],
      child: ListTile(
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: Colors.grey[300],
          child: Text(
            '${bloc.order}',
            style: const TextStyle(fontSize: 12),
          ),
        ),
        title: Text(bloc.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (bloc.description != null) Text(bloc.description!),
            if (bloc.totalFloors != null || bloc.surface != null)
              Row(
                children: [
                  if (bloc.totalFloors != null)
                    Text('🏗️ ${bloc.totalFloors} étages  '),
                  if (bloc.surface != null)
                    Text('📐 ${bloc.surface} m²'),
                ],
              ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: Navigate to bloc details / tasks
        },
      ),
    );
  }
}

// ========== ADD ILOT DIALOG ==========
class _AddIlotDialog extends ConsumerStatefulWidget {
  final String projectId;
  final Ilot? existingIlot;

  const _AddIlotDialog({
    required this.projectId,
    this.existingIlot,
  });

  @override
  ConsumerState<_AddIlotDialog> createState() => _AddIlotDialogState();
}

class _AddIlotDialogState extends ConsumerState<_AddIlotDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _orderController;
  Color _selectedColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existingIlot?.name);
    _descriptionController = TextEditingController(text: widget.existingIlot?.description);
    _orderController = TextEditingController(
      text: widget.existingIlot?.order.toString() ?? '1',
    );

    if (widget.existingIlot?.color != null) {
      _selectedColor = Color(
        int.parse(widget.existingIlot!.color!.replaceFirst('#', '0xFF')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existingIlot == null ? 'Ajouter un Ilot' : 'Modifier Ilot'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom de l\'ilot *',
                hintText: 'ex: Ilot A - Zone Nord',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Description optionnelle',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _orderController,
              decoration: const InputDecoration(
                labelText: 'Ordre *',
                hintText: '1, 2, 3...',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Couleur: '),
                const SizedBox(width: 8),
                ...[
                  Colors.blue,
                  Colors.green,
                  Colors.orange,
                  Colors.red,
                  Colors.purple,
                  Colors.teal,
                ].map((color) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: color,
                      child: _selectedColor == color
                          ? const Icon(Icons.check, color: Colors.white, size: 16)
                          : null,
                    ),
                  ),
                )),
              ],
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
          onPressed: _save,
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  void _save() async {
    if (_nameController.text.isEmpty || _orderController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs obligatoires')),
      );
      return;
    }

    final repository = ref.read(planningRepositoryProvider);
    final colorHex = '#${_selectedColor.value.toRadixString(16).substring(2)}';

    if (widget.existingIlot == null) {
      // Create new
      await repository.createIlot(
        IlotsCompanion.insert(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          projectId: widget.projectId,
          name: _nameController.text,
          description: drift.Value(_descriptionController.text.isEmpty ? null : _descriptionController.text),
          order: int.parse(_orderController.text),
          color: drift.Value(colorHex),
        ),
      );
    } else {
      // Update existing
      await repository.updateIlot(
        widget.existingIlot!.id,
        IlotsCompanion(
          name: drift.Value(_nameController.text),
          description: drift.Value(_descriptionController.text.isEmpty ? null : _descriptionController.text),
          order: drift.Value(int.parse(_orderController.text)),
          color: drift.Value(colorHex),
        ),
      );
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }
}

// ========== ADD BLOC DIALOG ==========
class _AddBlocDialog extends ConsumerStatefulWidget {
  final String ilotId;

  const _AddBlocDialog({required this.ilotId});

  @override
  ConsumerState<_AddBlocDialog> createState() => _AddBlocDialogState();
}

class _AddBlocDialogState extends ConsumerState<_AddBlocDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _orderController;
  late final TextEditingController _floorsController;
  late final TextEditingController _surfaceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _orderController = TextEditingController(text: '1');
    _floorsController = TextEditingController();
    _surfaceController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _orderController.dispose();
    _floorsController.dispose();
    _surfaceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter un Bloc'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom du bloc *',
                hintText: 'ex: Bloc 1',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _orderController,
              decoration: const InputDecoration(labelText: 'Ordre *'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _floorsController,
              decoration: const InputDecoration(
                labelText: 'Nombre d\'étages',
                hintText: 'Optionnel',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _surfaceController,
              decoration: const InputDecoration(
                labelText: 'Surface (m²)',
                hintText: 'Optionnel',
              ),
              keyboardType: TextInputType.number,
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
          onPressed: _save,
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  void _save() async {
    if (_nameController.text.isEmpty || _orderController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs obligatoires')),
      );
      return;
    }

    final repository = ref.read(planningRepositoryProvider);

    await repository.createBloc(
      BlocsCompanion.insert(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        ilotId: widget.ilotId,
        name: _nameController.text,
        description: drift.Value(_descriptionController.text.isEmpty ? null : _descriptionController.text),
        order: int.parse(_orderController.text),
        totalFloors: drift.Value(_floorsController.text.isEmpty ? null : int.parse(_floorsController.text)),
        surface: drift.Value(_surfaceController.text.isEmpty ? null : double.parse(_surfaceController.text)),
      ),
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
