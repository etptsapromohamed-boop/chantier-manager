import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chantier_manager/src/features/settings/data/settings_repository.dart';
import 'package:chantier_manager/src/features/core/data/local/app_database.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chantier_manager/src/features/sync/application/sync_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _initializeSettings();
  }

  Future<void> _initializeSettings() async {
    await ref.read(settingsRepositoryProvider).initializeDefaults();
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
        title: const Text('Paramètres de l\'Application'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.business), text: 'Entreprise'),
            Tab(icon: Icon(Icons.access_time), text: 'Pointage'),
            Tab(icon: Icon(Icons.construction), text: 'Projets'),
            Tab(icon: Icon(Icons.picture_as_pdf), text: 'Export PDF'),
            Tab(icon: Icon(Icons.people), text: 'Utilisateurs'),
            Tab(icon: Icon(Icons.settings), text: 'Général'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CompanySettingsTab(),
          _AttendanceSettingsTab(),
          _ProjectSettingsTab(),
          _PdfExportSettingsTab(),
          _UserSettingsTab(),
          _GeneralSettingsTab(),
        ],
      ),
    );
  }
}

// Company Settings Tab
class _CompanySettingsTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_CompanySettingsTab> createState() => _CompanySettingsTabState();
}

class _CompanySettingsTabState extends ConsumerState<_CompanySettingsTab> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  Uint8List? _logoBytes;
  String? _logoFileName;
  Uint8List? _signatureBytes;
  Uint8List? _stampBytes;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final repo = ref.read(settingsRepositoryProvider);
    _controllers['name'] = TextEditingController(text: await repo.getSetting<String>('company.name') ?? '');
    _controllers['address'] = TextEditingController(text: await repo.getSetting<String>('company.address') ?? '');
    _controllers['phone'] = TextEditingController(text: await repo.getSetting<String>('company.phone') ?? '');
    _controllers['email'] = TextEditingController(text: await repo.getSetting<String>('company.email') ?? '');
    _controllers['website'] = TextEditingController(text: await repo.getSetting<String>('company.website') ?? '');
    _controllers['fiscalId'] = TextEditingController(text: await repo.getSetting<String>('company.fiscal_id') ?? '');
    _controllers['taxNumber'] = TextEditingController(text: await repo.getSetting<String>('company.tax_number') ?? '');
    _controllers['registrationNumber'] = TextEditingController(text: await repo.getSetting<String>('company.registration_number') ?? '');
    if (mounted) setState(() {});
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    final repo = ref.read(settingsRepositoryProvider);
    await repo.updateSetting('company.name', _controllers['name']!.text, null);
    await repo.updateSetting('company.address', _controllers['address']!.text, null);
    await repo.updateSetting('company.phone', _controllers['phone']!.text, null);
    await repo.updateSetting('company.email', _controllers['email']!.text, null);
    await repo.updateSetting('company.website', _controllers['website']!.text, null);
    await repo.updateSetting('company.fiscal_id', _controllers['fiscalId']!.text, null);
    await repo.updateSetting('company.tax_number', _controllers['taxNumber']!.text, null);
    await repo.updateSetting('company.registration_number', _controllers['registrationNumber']!.text, null);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paramètres enregistrés'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Informations de l\'Entreprise', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          
          TextFormField(
            controller: _controllers['name'],
            decoration: const InputDecoration(labelText: 'Nom de l\'entreprise', border: OutlineInputBorder()),
            validator: (v) => v == null || v.isEmpty ? 'Obligatoire' : null,
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _controllers['address'],
            decoration: const InputDecoration(labelText: 'Adresse', border: OutlineInputBorder()),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _controllers['phone'],
            decoration: const InputDecoration(labelText: 'Téléphone', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _controllers['email'],
            decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _controllers['website'],
            decoration: const InputDecoration(labelText: 'Site Web', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 24),
          
          const Divider(),
          const Text('Informations Fiscales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _controllers['fiscalId'],
            decoration: const InputDecoration(labelText: 'Identifiant Fiscal', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _controllers['taxNumber'],
            decoration: const InputDecoration(labelText: 'Numéro TVA', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _controllers['registrationNumber'],
            decoration: const InputDecoration(labelText: 'Numéro d\'enregistrement', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 24),
          
          const Divider(),
          const Text('Images Entreprise', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          // Logo section with preview
          if (_logoBytes != null) ...
          [
            Container(
              height: 120,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Expanded(child: Image.memory(_logoBytes!, fit: BoxFit.contain)),
                  Text(_logoFileName ?? 'Logo', style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          
          OutlinedButton.icon(
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.image,
                allowMultiple: false,
              );
              if (result != null && result.files.isNotEmpty) {
                final file = result.files.first;
                final bytes = file.bytes;
                if (bytes != null) {
                  setState(() {
                    _logoBytes = bytes;
                    _logoFileName = file.name;
                  });
                  // Save to settings
                  final repo = ref.read(settingsRepositoryProvider);
                  await repo.updateSetting('company.logo', file.name, null);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Logo chargé: ${file.name}'), backgroundColor: Colors.green),
                    );
                  }
                }
              }
            },
            icon: const Icon(Icons.upload_file),
            label: Text(_logoBytes != null ? 'Changer le logo' : 'Charger le logo de l\'entreprise'),
          ),
          const SizedBox(height: 12),
          
          OutlinedButton.icon(
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.image,
                allowMultiple: false,
              );
              if (result != null && result.files.isNotEmpty) {
                final file = result.files.first;
                final bytes = file.bytes;
                if (bytes != null) {
                  final repo = ref.read(settingsRepositoryProvider);
                  await repo.updateSetting('company.signature', file.name, null);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Signature chargée: ${file.name}'), backgroundColor: Colors.green),
                    );
                  }
                }
              }
            },
            icon: const Icon(Icons.upload_file),
            label: const Text('Charger la signature'),
          ),
          const SizedBox(height: 12),
          
          OutlinedButton.icon(
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.image,
                allowMultiple: false,
              );
              if (result != null && result.files.isNotEmpty) {
                final file = result.files.first;
                final bytes = file.bytes;
                if (bytes != null) {
                  final repo = ref.read(settingsRepositoryProvider);
                  await repo.updateSetting('company.stamp', file.name, null);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cachet chargé: ${file.name}'), backgroundColor: Colors.green),
                    );
                  }
                }
              }
            },
            icon: const Icon(Icons.upload_file),
            label: const Text('Charger le cachet'),
          ),
          const SizedBox(height: 24),
          
          ElevatedButton.icon(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save),
            label: const Text('Enregistrer'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controllers.values.forEach((c) => c.dispose());
    super.dispose();
  }
}

// Attendance Settings Tab
class _AttendanceSettingsTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_AttendanceSettingsTab> createState() => _AttendanceSettingsTabState();
}

class _AttendanceSettingsTabState extends ConsumerState<_AttendanceSettingsTab> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  bool _geolocationRequired = true;
  bool _autoCheckoutEnabled = true;
  bool _overtimeEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final repo = ref.read(settingsRepositoryProvider);
    _controllers['workStart'] = TextEditingController(text: await repo.getSetting<String>('attendance.work_start') ?? '07:00');
    _controllers['workEnd'] = TextEditingController(text: await repo.getSetting<String>('attendance.work_end') ?? '17:00');
    _controllers['lunchBreak'] = TextEditingController(text: (await repo.getSetting<int>('attendance.lunch_break_minutes') ?? 60).toString());
    _controllers['lateTolerance'] = TextEditingController(text: (await repo.getSetting<int>('attendance.late_tolerance_minutes') ?? 15).toString());
    _controllers['geofenceRadius'] = TextEditingController(text: (await repo.getSetting<double>('attendance.default_geofence_radius') ?? 100.0).toString());
    _controllers['autoCheckoutTime'] = TextEditingController(text: await repo.getSetting<String>('attendance.auto_checkout_time') ?? '18:00');
    _controllers['overtimeAfter'] = TextEditingController(text: await repo.getSetting<String>('attendance.overtime_after_hour') ?? '17:00');
    
    _geolocationRequired = await repo.getSetting<bool>('attendance.geolocation_required') ?? true;
    _autoCheckoutEnabled = await repo.getSetting<bool>('attendance.auto_checkout_enabled') ?? true;
    _overtimeEnabled = await repo.getSetting<bool>('attendance.overtime_enabled') ?? false;
    
    if (mounted) setState(() {});
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    final repo = ref.read(settingsRepositoryProvider);
    await repo.updateSetting('attendance.work_start', _controllers['workStart']!.text, null);
    await repo.updateSetting('attendance.work_end', _controllers['workEnd']!.text, null);
    await repo.updateSetting('attendance.lunch_break_minutes', int.parse(_controllers['lunchBreak']!.text), null);
    await repo.updateSetting('attendance.late_tolerance_minutes', int.parse(_controllers['lateTolerance']!.text), null);
    await repo.updateSetting('attendance.default_geofence_radius', double.parse(_controllers['geofenceRadius']!.text), null);
    await repo.updateSetting('attendance.geolocation_required', _geolocationRequired, null);
    await repo.updateSetting('attendance.auto_checkout_enabled', _autoCheckoutEnabled, null);
    await repo.updateSetting('attendance.auto_checkout_time', _controllers['autoCheckoutTime']!.text, null);
    await repo.updateSetting('attendance.overtime_enabled', _overtimeEnabled, null);
    await repo.updateSetting('attendance.overtime_after_hour', _controllers['overtimeAfter']!.text, null);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paramètres enregistrés'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Paramètres de Pointage', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          
          TextFormField(
            controller: _controllers['workStart'],
            decoration: const InputDecoration(labelText: 'Heure de début (HH:MM)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _controllers['workEnd'],
            decoration: const InputDecoration(labelText: 'Heure de fin (HH:MM)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _controllers['lunchBreak'],
            decoration: const InputDecoration(labelText: 'Pause déjeuner (minutes)', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _controllers['lateTolerance'],
            decoration: const InputDecoration(labelText: 'Tolérance retard (minutes)', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          
          SwitchListTile(
            title: const Text('Géolocalisation obligatoire'),
            value: _geolocationRequired,
            onChanged: (v) => setState(() => _geolocationRequired = v),
          ),
          
          TextFormField(
            controller: _controllers['geofenceRadius'],
            decoration: const InputDecoration(labelText: 'Rayon géofencing (mètres)', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          
          SwitchListTile(
            title: const Text('Auto check-out activé'),
            subtitle: const Text('Marquer automatiquement la sortie'),
            value: _autoCheckoutEnabled,
            onChanged: (v) => setState(() => _autoCheckoutEnabled = v),
          ),
          
          if (_autoCheckoutEnabled)
            TextFormField(
              controller: _controllers['autoCheckoutTime'],
              decoration: const InputDecoration(labelText: 'Heure auto check-out (HH:MM)', border: OutlineInputBorder()),
            ),
          const SizedBox(height: 16),
          
          SwitchListTile(
            title: const Text('Heures supplémentaires activées'),
            subtitle: const Text('Calculer les heures sup'),
            value: _overtimeEnabled,
            onChanged: (v) => setState(() => _overtimeEnabled = v),
          ),
          
          if (_overtimeEnabled)
            TextFormField(
              controller: _controllers['overtimeAfter'],
              decoration: const InputDecoration(labelText: 'Heures sup après (HH:MM)', border: OutlineInputBorder()),
            ),
          const SizedBox(height: 24),
          
          ElevatedButton.icon(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save),
            label: const Text('Enregistrer'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controllers.values.forEach((c) => c.dispose());
    super.dispose();
  }
}

// Project Settings Tab
class _ProjectSettingsTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ProjectSettingsTab> createState() => _ProjectSettingsTabState();
}

class _ProjectSettingsTabState extends ConsumerState<_ProjectSettingsTab> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _projectNameController = TextEditingController();
  final _geofenceController = TextEditingController();
  bool _useGpsIfEmpty = true;
  bool _strictGeofencing = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final repo = ref.read(settingsRepositoryProvider);
    _projectNameController.text = await repo.getSetting<String>('projects.default_name') ?? 'Nouveau Projet';
    _geofenceController.text = (await repo.getSetting<double>('projects.default_geofence_radius') ?? 100.0).toString();
    _useGpsIfEmpty = await repo.getSetting<bool>('projects.use_gps_if_empty') ?? true;
    _strictGeofencing = await repo.getSetting<bool>('projects.strict_geofencing') ?? false;
    if (mounted) setState(() {});
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    final repo = ref.read(settingsRepositoryProvider);
    await repo.updateSetting('projects.default_name', _projectNameController.text, null);
    await repo.updateSetting('projects.default_geofence_radius', double.parse(_geofenceController.text), null);
    await repo.updateSetting('projects.use_gps_if_empty', _useGpsIfEmpty, null);
    await repo.updateSetting('projects.strict_geofencing', _strictGeofencing, null);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paramètres enregistrés'), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _useCurrentGPS() async {
    try {
      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Permission de localisation refusée'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Permission de localisation refusée définitivement. Activez-la dans les paramètres.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Save to settings as default project coordinates
      final repo = ref.read(settingsRepositoryProvider);
      await repo.updateSetting('projects.default_latitude', position.latitude, null);
      await repo.updateSetting('projects.default_longitude', position.longitude, null);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Position GPS enregistrée: ${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la récupération GPS: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Paramètres Projets', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          
          TextFormField(
            controller: _projectNameController,
            decoration: const InputDecoration(
              labelText: 'Nom de projet par défaut',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _geofenceController,
            decoration: const InputDecoration(
              labelText: 'Rayon géofencing par défaut (mètres)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          
          SwitchListTile(
            title: const Text('Utiliser GPS si coordonnées vides'),
            subtitle: const Text('Prendre automatiquement la position actuelle'),
            value: _useGpsIfEmpty,
            onChanged: (v) => setState(() => _useGpsIfEmpty = v),
          ),
          
          if (_useGpsIfEmpty) ...[
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _useCurrentGPS,
              icon: const Icon(Icons.my_location),
              label: const Text('Utiliser ma position GPS actuelle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
          const SizedBox(height: 16),
          
          SwitchListTile(
            title: const Text('Mode strict géofencing'),
            subtitle: const Text('Bloquer totalement si hors zone'),
            value: _strictGeofencing,
            onChanged: (v) => setState(() => _strictGeofencing = v),
          ),
          const SizedBox(height: 24),
          
          ElevatedButton.icon(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save),
            label: const Text('Enregistrer'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _geofenceController.dispose();
    super.dispose();
  }
}

// PDF Export Settings Tab
class _PdfExportSettingsTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_PdfExportSettingsTab> createState() => _PdfExportSettingsTabState();
}

class _PdfExportSettingsTabState extends ConsumerState<_PdfExportSettingsTab> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  bool _includeLogo = false;
  bool _includeStamp = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final repo = ref.read(settingsRepositoryProvider);
    _controllers['header'] = TextEditingController(text: await repo.getSetting<String>('pdf.header_text') ?? '');
    _controllers['footer'] = TextEditingController(text: await repo.getSetting<String>('pdf.footer_text') ?? '');
    _controllers['color'] = TextEditingController(text: await repo.getSetting<String>('pdf.primary_color') ?? '#1976D2');
    
    _includeLogo = await repo.getSetting<bool>('pdf.include_logo') ?? false;
    _includeStamp = await repo.getSetting<bool>('pdf.include_stamp') ?? false;
    
    if (mounted) setState(() {});
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    final repo = ref.read(settingsRepositoryProvider);
    await repo.updateSetting('pdf.header_text', _controllers['header']!.text, null);
    await repo.updateSetting('pdf.footer_text', _controllers['footer']!.text, null);
    await repo.updateSetting('pdf.primary_color', _controllers['color']!.text, null);
    await repo.updateSetting('pdf.include_logo', _includeLogo, null);
    await repo.updateSetting('pdf.include_stamp', _includeStamp, null);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paramètres enregistrés'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Paramètres Export PDF', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          
          TextFormField(
            controller: _controllers['header'],
            decoration: const InputDecoration(labelText: 'En-tête personnalisé', border: OutlineInputBorder()),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _controllers['footer'],
            decoration: const InputDecoration(labelText: 'Pied de page', border: OutlineInputBorder()),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _controllers['color'],
            decoration: const InputDecoration(
              labelText: 'Couleur principale (hex)',
              border: OutlineInputBorder(),
              hintText: '#1976D2',
            ),
          ),
          const SizedBox(height: 16),
          
          SwitchListTile(
            title: const Text('Inclure logo entreprise'),
            value: _includeLogo,
            onChanged: (v) => setState(() => _includeLogo = v),
          ),
          
          SwitchListTile(
            title: const Text('Inclure cachet/signature'),
            value: _includeStamp,
            onChanged: (v) => setState(() => _includeStamp = v),
          ),
          const SizedBox(height: 24),
          
          ElevatedButton.icon(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save),
            label: const Text('Enregistrer'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controllers.values.forEach((c) => c.dispose());
    super.dispose();
  }
}

// User Settings Tab
class _UserSettingsTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_UserSettingsTab> createState() => _UserSettingsTabState();
}

class _UserSettingsTabState extends ConsumerState<_UserSettingsTab> {
  final _formKey = GlobalKey<FormState>();
  final _minPasswordController = TextEditingController();
  bool _passwordRequired = true;
  bool _profilePictureRequired = false;
  bool _idCardRequired = false;
  Map<String, bool> _passwordRoles = {'admin': true, 'supervisor': true, 'worker': true};

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final repo = ref.read(settingsRepositoryProvider);
    _passwordRequired = await repo.getSetting<bool>('users.password_required') ?? true;
    _minPasswordController.text = (await repo.getSetting<int>('users.min_password_length') ?? 6).toString();
    _profilePictureRequired = await repo.getSetting<bool>('users.profile_picture_required') ?? false;
    _idCardRequired = await repo.getSetting<bool>('users.id_card_required') ?? false;
    
    if (mounted) setState(() {});
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    final repo = ref.read(settingsRepositoryProvider);
    await repo.updateSetting('users.password_required', _passwordRequired, null);
    await repo.updateSetting('users.min_password_length', int.parse(_minPasswordController.text), null);
    await repo.updateSetting('users.profile_picture_required', _profilePictureRequired, null);
    await repo.updateSetting('users.id_card_required', _idCardRequired, null);
    
    // Save selected roles
    final selectedRoles = _passwordRoles.entries.where((e) => e.value).map((e) => e.key).toList();
    await repo.updateSetting('users.password_required_roles', selectedRoles, null);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paramètres enregistrés'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Paramètres Utilisateurs', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          
          SwitchListTile(
            title: const Text('Mot de passe obligatoire'),
            value: _passwordRequired,
            onChanged: (v) => setState(() => _passwordRequired = v),
          ),
          
          if (!_passwordRequired) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Rôles nécessitant un mot de passe:', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            CheckboxListTile(
              title: const Text('Administrateurs'),
              value: _passwordRoles['admin'],
              onChanged: (v) => setState(() => _passwordRoles['admin'] = v ?? false),
            ),
            CheckboxListTile(
              title: const Text('Superviseurs'),
              value: _passwordRoles['supervisor'],
              onChanged: (v) => setState(() => _passwordRoles['supervisor'] = v ?? false),
            ),
            CheckboxListTile(
              title: const Text('Ouvriers'),
              value: _passwordRoles['worker'],
              onChanged: (v) => setState(() => _passwordRoles['worker'] = v ?? false),
            ),
          ],
          
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _minPasswordController,
            decoration: const InputDecoration(
              labelText: 'Longueur minimale mot de passe',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          
          SwitchListTile(
            title: const Text('Photo de profil obligatoire'),
            value: _profilePictureRequired,
            onChanged: (v) => setState(() => _profilePictureRequired = v),
          ),
          
          SwitchListTile(
            title: const Text('Carte d\'identité obligatoire'),
            value: _idCardRequired,
            onChanged: (v) => setState(() => _idCardRequired = v),
          ),
          const SizedBox(height: 24),
          
          ElevatedButton.icon(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save),
            label: const Text('Enregistrer'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _minPasswordController.dispose();
    super.dispose();
  }
}

// General Settings Tab
class _GeneralSettingsTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_GeneralSettingsTab> createState() => _GeneralSettingsTabState();
}

class _GeneralSettingsTabState extends ConsumerState<_GeneralSettingsTab> {
  final _formKey = GlobalKey<FormState>();
  String _language = 'fr';
  String _dateFormat = 'DD/MM/YYYY';
  String _timeFormat = '24h';
  String _currency = 'TND';
  bool _autoSync = false;
  bool _syncOnChange = false;
  final _syncIntervalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final repo = ref.read(settingsRepositoryProvider);
    _language = await repo.getSetting<String>('general.language') ?? 'fr';
    _dateFormat = await repo.getSetting<String>('general.date_format') ?? 'DD/MM/YYYY';
    _timeFormat = await repo.getSetting<String>('general.time_format') ?? '24h';
    _currency = await repo.getSetting<String>('general.currency') ?? 'TND';
    _autoSync = await repo.getSetting<bool>('sync.auto_sync') ?? false;
    _syncOnChange = await repo.getSetting<bool>('sync.sync_on_change') ?? false;
    _syncIntervalController.text = (await repo.getSetting<int>('sync.interval_minutes') ?? 15).toString();
    
    if (mounted) setState(() {});
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    final repo = ref.read(settingsRepositoryProvider);
    await repo.updateSetting('general.language', _language, null);
    await repo.updateSetting('general.date_format', _dateFormat, null);
    await repo.updateSetting('general.time_format', _timeFormat, null);
    await repo.updateSetting('general.currency', _currency, null);
    await repo.updateSetting('sync.auto_sync', _autoSync, null);
    await repo.updateSetting('sync.sync_on_change', _syncOnChange, null);
    await repo.updateSetting('sync.interval_minutes', int.parse(_syncIntervalController.text), null);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paramètres enregistrés'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Paramètres Généraux', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          
          DropdownButtonFormField<String>(
            value: _language,
            decoration: const InputDecoration(labelText: 'Langue', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'fr', child: Text('Français')),
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'ar', child: Text('العربية')),
            ],
            onChanged: (v) => setState(() => _language = v!),
          ),
          const SizedBox(height: 16),
          
          DropdownButtonFormField<String>(
            value: _dateFormat,
            decoration: const InputDecoration(labelText: 'Format de date', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'DD/MM/YYYY', child: Text('JJ/MM/AAAA')),
              DropdownMenuItem(value: 'MM/DD/YYYY', child: Text('MM/JJ/AAAA')),
              DropdownMenuItem(value: 'YYYY-MM-DD', child: Text('AAAA-MM-JJ')),
            ],
            onChanged: (v) => setState(() => _dateFormat = v!),
          ),
          const SizedBox(height: 16),
          
          DropdownButtonFormField<String>(
            value: _timeFormat,
            decoration: const InputDecoration(labelText: 'Format d\'heure', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: '24h', child: Text('24 heures')),
              DropdownMenuItem(value: '12h', child: Text('12 heures (AM/PM)')),
            ],
            onChanged: (v) => setState(() => _timeFormat = v!),
          ),
          const SizedBox(height: 16),
          
          DropdownButtonFormField<String>(
            value: _currency,
            decoration: const InputDecoration(labelText: 'Devise', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'TND', child: Text('TND (Dinar Tunisien)')),
              DropdownMenuItem(value: 'EUR', child: Text('EUR (Euro)')),
              DropdownMenuItem(value: 'USD', child: Text('USD (Dollar)')),
              DropdownMenuItem(value: 'DZD', child: Text('DZD (Dinar Algérien)')),
            ],
            onChanged: (v) => setState(() => _currency = v!),
          ),
          const SizedBox(height: 24),
          
          const Divider(),
          const Text('Synchronisation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          SwitchListTile(
            title: const Text('Auto-sync Supabase'),
            subtitle: const Text('Synchronisation automatique périodique'),
            value: _autoSync,
            onChanged: (v) => setState(() => _autoSync = v),
          ),
          
          if (_autoSync)
            TextFormField(
              controller: _syncIntervalController,
              decoration: const InputDecoration(
                labelText: 'Intervalle de sync (minutes)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          const SizedBox(height: 16),
          
          SwitchListTile(
            title: const Text('Sync sur changement'),
            subtitle: const Text('Synchroniser immédiatement après modification'),
            value: _syncOnChange,
            onChanged: (v) => setState(() => _syncOnChange = v),
          ),
          const SizedBox(height: 16),
          
          OutlinedButton.icon(
            onPressed: () async {
              // Show loading indicator
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) => const Center(child: CircularProgressIndicator()),
              );
              
              try {
                // Test Supabase connection
                final supabase = Supabase.instance.client;
                
                // Test 1: Check if client is initialized
                if (mounted) {
                  Navigator.pop(context); // Close loading
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Test 1/3: Client Supabase initialisé ✓'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
                
                await Future.delayed(const Duration(milliseconds: 500));
                
                // Test 2: Check authentication status
                final session = supabase.auth.currentSession;
                if (mounted) {
                  if (session != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Test 2/3: Authentifié comme ${session.user.email ?? "utilisateur"} ✓'),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Test 2/3: Non authentifié (mode anonyme) ⚠️'),
                        backgroundColor: Colors.orange,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
                
                await Future.delayed(const Duration(milliseconds: 500));
                
                // Test 3: Try a simple query to verify connection
                try {
                  final response = await supabase
                      .from('projects')
                      .select('id')
                      .limit(1);
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Test 3/3: Connexion base de données ✓\n✅ SYNCHRONISATION FONCTIONNELLE'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 4),
                      ),
                    );
                  }
                } catch (queryError) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Test 3/3: Erreur requête BD ❌\n$queryError'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 4),
                      ),
                    );
                  }
                }
                
              } catch (e) {
                if (mounted) {
                  Navigator.of(context, rootNavigator: true).pop(); // Close loading if still open
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❌ Erreur critique: $e'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 5),
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.sync),
            label: const Text('Tester la synchronisation'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue,
              padding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 16),
          
          // Manual Full Sync Button
          OutlinedButton.icon(
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(child: CircularProgressIndicator()),
              );

              try {
                final syncService = ref.read(syncServiceProvider);
                
                // Upload + Download
                final uploadResults = await syncService.uploadAllData();
                final downloadResults = await syncService.downloadAllData();
                
                if (mounted) {
                  Navigator.pop(context);
                  
                  final uploadCount = uploadResults.values.fold(0, (sum, count) => sum + count);
                  final downloadCount = downloadResults.values.fold(0, (sum, count) => sum + count);
                  
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 30),
                          SizedBox(width: 10),
                          Text('Sync Réussie'),
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('📤 Upload: $uploadCount', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ...uploadResults.entries.map((e) => 
                            Text('  • ${e.key}: ${e.value}', style: const TextStyle(fontSize: 14))
                          ),
                          const SizedBox(height: 12),
                          Text('📥 Download: $downloadCount', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ...downloadResults.entries.map((e) => 
                            Text('  • ${e.key}: ${e.value}', style: const TextStyle(fontSize: 14))
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❌ Erreur: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.cloud_sync),
            label: const Text('Synchroniser Maintenant'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.green,
              padding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 24),
          
          ElevatedButton.icon(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save),
            label: const Text('Enregistrer'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _syncIntervalController.dispose();
    super.dispose();
  }
}

