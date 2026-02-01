import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chantier_manager/src/features/teams/data/user_repository.dart';
import 'package:chantier_manager/src/features/core/data/local/app_database.dart';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:chantier_manager/src/shared/services/excel_service.dart';
import 'package:chantier_manager/src/shared/services/pdf_service.dart';
import 'package:chantier_manager/src/features/attendance/data/attendance_repository.dart';
import 'package:intl/intl.dart';

class TeamManagementScreen extends ConsumerStatefulWidget {
  const TeamManagementScreen({super.key});

  @override
  ConsumerState<TeamManagementScreen> createState() => _TeamManagementScreenState();
}

class _TeamManagementScreenState extends ConsumerState<TeamManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _selectedFilters = {}; 

  @override
  Widget build(BuildContext context) {
    final userRepo = ref.watch(userRepositoryProvider);
    final usersAsync = ref.watch(usersStreamProvider(_searchQuery));

    return Scaffold(
      backgroundColor: Colors.transparent, 
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: "actions",
            onPressed: _showActionsMenu,
            label: const Text("Actions"),
            icon: const Icon(Icons.settings),
            backgroundColor: Colors.blueGrey,
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: "add",
            onPressed: () => _showUserDialog(context, null),
            label: const Text("Ajouter Membre"),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Gestion des Équipes", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          
          // Search & Filter
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 20,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: constraints.maxWidth > 600 ? 300 : constraints.maxWidth,
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Rechercher un membre',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        setState(() => _searchQuery = val);
                      },
                    ),
                  ),
                  // Dynamic Filters
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip("Tous", 'All'),
                        const SizedBox(width: 10),
                        _buildFilterChip("Ouvriers", 'worker'),
                        const SizedBox(width: 10),
                        _buildFilterChip("Superviseurs", 'supervisor'),
                        const SizedBox(width: 10),
                        _buildFilterChip("Admins", 'admin'),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          
          const SizedBox(height: 20),
          
          // User List
          Expanded(
            child: usersAsync.when(
              data: (users) {
                final filteredUsers = _selectedFilters.isEmpty 
                    ? users 
                    : users.where((u) => _selectedFilters.contains(u.role)).toList();
                    
                if (filteredUsers.isEmpty) {
                  return const Center(child: Text("Aucun membre trouvé."));
                }

                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getRoleColor(user.role).withOpacity(0.2),
                          backgroundImage: user.profilePicturePath != null 
                              ? (kIsWeb 
                                  ? NetworkImage(user.profilePicturePath!) 
                                  : FileImage(File(user.profilePicturePath!)) as ImageProvider)
                              : null,
                          child: user.profilePicturePath == null 
                              ? Text(user.firstName[0], style: TextStyle(color: _getRoleColor(user.role)))
                              : null,
                        ),
                        title: Text("${user.firstName} ${user.lastName}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(user.role.toUpperCase(), style: const TextStyle(fontSize: 12)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch(
                              value: user.isActive,
                              onChanged: (val) {
                                userRepo.updateUserStatus(user.id, val);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showUserDialog(context, user),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(context, user.id),
                            ),
                          ],
                        ),
                      ),
                    );
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

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin': return Colors.red;
      case 'supervisor': return Colors.blue;
      case 'worker': default: return Colors.orange;
    }
  }

  // --- ACTIONS MENU ---
  void _showActionsMenu() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text("Télécharger Modèle d'Import"),
              onTap: () {
                Navigator.pop(ctx);
                ExcelService().downloadUserTemplate();
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_upload),
              title: const Text("Importer Utilisateurs (Excel)"),
              onTap: () {
                Navigator.pop(ctx);
                _importUsers();
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_download),
              title: const Text("Exporter Utilisateurs (Excel)"),
              onTap: () {
                Navigator.pop(ctx);
                _exportUsers();
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text("Exporter Pointages"),
              onTap: () {
                Navigator.pop(ctx);
                _showExportDialog();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _importUsers() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        withData: kIsWeb,
      );

      if (result != null) {
        final file = result.files.first;
        final users = await ExcelService().parseUserImport(file);
        
        if (users.isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Aucun utilisateur valide trouvé dans le fichier. Vérifiez le format."),
              backgroundColor: Colors.orange,
            ));
          }
          return;
        }

        final repo = ref.read(userRepositoryProvider);
        int successCount = 0;
        int errorCount = 0;
        
        for (var user in users) {
          try {
            await repo.addUser(user);
            successCount++;
          } catch (e) {
            errorCount++;
            print("Error importing user ${user.firstName}: $e");
          }
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("$successCount utilisateurs importés. $errorCount échecs."),
            backgroundColor: errorCount > 0 ? Colors.orange : Colors.green,
          ));
        }
      }
    } catch (e) {
      print("Import error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Erreur d'importation: $e"),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  Future<void> _exportUsers() async {
    try {
      final repo = ref.read(userRepositoryProvider);
      final users = await repo.getAllUsers();
      await ExcelService().exportUsers(users);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Exportation réussie.")));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur d'exportation: $e")));
      }
    }
  }

  Future<void> _showExportDialog() async {
    DateTimeRange? dateRange;
    String roleFilter = 'All';
    String format = 'excel'; // 'excel' or 'pdf'

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Exporter Pointages"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(dateRange == null 
                        ? "Sélectionner une période" 
                        : "${DateFormat('dd/MM/yyyy').format(dateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(dateRange!.end)}"),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setState(() => dateRange = picked);
                      }
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: roleFilter,
                    items: const [
                       DropdownMenuItem(value: 'All', child: Text("Tous les rôles")),
                       DropdownMenuItem(value: 'worker', child: Text("Ouvriers")),
                       DropdownMenuItem(value: 'supervisor', child: Text("Superviseurs")),
                    ],
                    onChanged: (v) => setState(() => roleFilter = v!),
                    decoration: const InputDecoration(labelText: "Filtre Compte"),
                  ),
                  const SizedBox(height: 10),
                  const Text("Format"),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text("Excel"),
                          value: 'excel',
                          groupValue: format,
                          onChanged: (v) => setState(() => format = v!),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text("PDF"),
                          value: 'pdf',
                          groupValue: format,
                          onChanged: (v) => setState(() => format = v!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Annuler")),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await _generateExport(dateRange, roleFilter, format);
                  },
                  child: const Text("Exporter"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _generateExport(DateTimeRange? range, String role, String format) async {
    try {
      final repo = ref.read(attendanceRepositoryProvider);
      final data = await repo.getAttendanceReport(
        startDate: range?.start,
        endDate: range?.end,
        roleFilter: role,
      );

      if (data.isEmpty) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Aucune donnée à exporter.")));
        return;
      }

      if (format == 'excel') {
        await ExcelService().exportAttendance(data);
      } else {
        String period = range != null 
            ? "${DateFormat('dd/MM').format(range.start)} - ${DateFormat('dd/MM').format(range.end)}" 
            : "Tout";
        await PdfService().generateAttendanceReport(data, period, role);
      }
       if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Rapport généré avec succès.")));
    } catch (e) {
       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur: $e")));
    }
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = value == 'All' ? _selectedFilters.isEmpty : _selectedFilters.contains(value);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (value == 'All') {
            _selectedFilters.clear();
          } else {
            if (selected) {
              _selectedFilters.add(value);
            } else {
              _selectedFilters.remove(value);
            }
          }
        });
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, String userId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmer suppression"),
        content: const Text("Voulez-vous vraiment supprimer ce membre ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Annuler")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Supprimer", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      ref.read(userRepositoryProvider).deleteUser(userId);
    }
  }

  void _showUserDialog(BuildContext context, User? user) {
    final isEditing = user != null;
    final firstNameController = TextEditingController(text: user?.firstName ?? '');
    final lastNameController = TextEditingController(text: user?.lastName ?? '');
    final phoneController = TextEditingController(text: user?.phoneNumber ?? '');
    
    // New Fields
    final idCardController = TextEditingController(text: user?.idCardNumber ?? '');
    final positionController = TextEditingController(text: user?.exactPosition ?? '');
    final passwordController = TextEditingController(text: user?.password ?? '');
    
    // Images (paths)
    String? idFrontPath = user?.idCardFrontPath;
    String? idBackPath = user?.idCardBackPath;
    String? profilePicPath = user?.profilePicturePath;

    String role = user?.role ?? 'worker';
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            
            // Image Picker Helper
            Future<void> pickImage(bool isFront) async {
              final picker = ImagePicker();
              final file = await picker.pickImage(source: ImageSource.gallery);
              if (file != null) {
                setState(() {
                  if (isFront) idFrontPath = file.path;
                  else idBackPath = file.path;
                });
              }
            }

            return AlertDialog(
              title: Text(isEditing ? "Modifier Membre" : "Ajouter Membre", style: const TextStyle(fontWeight: FontWeight.bold)),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("Photo de Profil"),
                        _buildProfilePicker(profilePicPath, (path) => setState(() => profilePicPath = path)),
                        const SizedBox(height: 20),
                        _buildSectionTitle("Informations Personnelles"),
                        Row(
                          children: [
                            Expanded(child: TextFormField(controller: firstNameController, decoration: const InputDecoration(labelText: "Prénom"), validator: (v) => v!.isEmpty ? "Requis" : null)),
                            const SizedBox(width: 10),
                            Expanded(child: TextFormField(controller: lastNameController, decoration: const InputDecoration(labelText: "Nom"), validator: (v) => v!.isEmpty ? "Requis" : null)),
                          ],
                        ),
                        TextFormField(controller: phoneController, decoration: const InputDecoration(labelText: "Téléphone")),
                        
                        const SizedBox(height: 20),
                        _buildSectionTitle("Poste & Accès"),
                        TextFormField(controller: positionController, decoration: const InputDecoration(labelText: "Poste Exacte (ex: Chef d'équipe)")),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: role,
                          items: const [
                            DropdownMenuItem(value: 'worker', child: Text("Ouvrier")),
                            DropdownMenuItem(value: 'supervisor', child: Text("Superviseur")),
                            DropdownMenuItem(value: 'admin', child: Text("Administrateur")),
                          ],
                          onChanged: (val) => setState(() => role = val!),
                          decoration: const InputDecoration(labelText: "Rôle Système"),
                        ),
                        TextFormField(
                          controller: passwordController, 
                          decoration: const InputDecoration(labelText: "Mot de passe d'accès"),
                          obscureText: true,
                        ),

                        const SizedBox(height: 20),
                        _buildSectionTitle("Carte d'Identité"),
                        TextFormField(controller: idCardController, decoration: const InputDecoration(labelText: "Numéro CNI / Passeport")),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _buildImagePicker("Recto", idFrontPath, () => pickImage(true)),
                            const SizedBox(width: 10),
                            _buildImagePicker("Verso", idBackPath, () => pickImage(false)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Annuler")),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final repo = ref.read(userRepositoryProvider);
                      final companion = UsersCompanion(
                        id: isEditing ? drift.Value(user.id) : drift.Value(Uuid().v4()),
                        firstName: drift.Value(firstNameController.text),
                        lastName: drift.Value(lastNameController.text),
                        role: drift.Value(role),
                        phoneNumber: drift.Value(phoneController.text),
                        email: const drift.Value(""), 
                        isActive: const drift.Value(true),
                        updatedAt: drift.Value(DateTime.now()),
                        createdAt: isEditing ? drift.Value(user.createdAt) : drift.Value(DateTime.now()),
                        // New Fields
                        idCardNumber: drift.Value(idCardController.text),
                        exactPosition: drift.Value(positionController.text),
                        password: drift.Value(passwordController.text),
                        profilePicturePath: drift.Value(profilePicPath),
                        idCardFrontPath: drift.Value(idFrontPath),
                        idCardBackPath: drift.Value(idBackPath),
                      );

                      if (isEditing) {
                        await repo.updateUser(companion);
                      } else {
                        await repo.addUser(companion);
                      }
                      
                      Navigator.pop(ctx);
                    }
                  },
                  child: Text(isEditing ? "Sauvegarder" : "Créer"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title, style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildImagePicker(String label, String? path, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[100],
          ),
          child: path != null 
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: kIsWeb 
                    ? Image.network(path, fit: BoxFit.cover) 
                    : Image.file(File(path), fit: BoxFit.cover)
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt, color: Colors.grey),
                    Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildProfilePicker(String? path, Function(String) onPicked) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[200],
            backgroundImage: path != null 
                ? (kIsWeb ? NetworkImage(path) : FileImage(File(path)) as ImageProvider)
                : null,
            child: path == null ? const Icon(Icons.person, size: 50, color: Colors.grey) : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 18,
              child: IconButton(
                icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                onPressed: () async {
                  final picker = ImagePicker();
                  final file = await picker.pickImage(source: ImageSource.gallery);
                  if (file != null) onPicked(file.path);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Simple Stream Provider for the UI
final usersStreamProvider = StreamProvider.autoDispose.family<List<User>, String>((ref, query) {
  final repo = ref.watch(userRepositoryProvider);
  return repo.searchUsers(query);
});
