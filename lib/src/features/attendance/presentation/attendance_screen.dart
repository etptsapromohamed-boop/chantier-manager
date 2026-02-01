import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import 'package:chantier_manager/src/features/attendance/data/attendance_repository.dart';
import 'package:chantier_manager/src/features/core/data/local/app_database.dart';
import 'package:chantier_manager/src/features/teams/data/user_repository.dart';
import 'package:intl/intl.dart';
import 'package:chantier_manager/src/shared/services/pdf_service.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  final double projectLat;
  final double projectLong;
  final double radiusMeters;
  final String? initialUserId;
  final String? initialRole;

  const AttendanceScreen({
    super.key,
    this.projectLat = 0.0,
    this.projectLong = 0.0,
    this.radiusMeters = 100.0,
    this.initialUserId,
    this.initialRole,
  });

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  bool _isLoading = true;
  bool _isWithinRange = false;
  String _statusMessage = "Validation position...";
  
  List<User> _participatingUsers = [];
  final Map<String, String> _attendanceStatus = {};
  
  String? _selectedUserId;
  String _selectedRole = 'admin'; // Default for demo
  final Map<String, DateTime?> _checkOutTimes = {};

  @override
  void initState() {
    super.initState();
    _selectedUserId = widget.initialUserId;
    _selectedRole = widget.initialRole ?? 'admin';
    _checkLocation();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    try {
      // For demo, if no userId is provided, try to find one of the correct role
      if (_selectedUserId == null) {
          final allUsers = await ref.read(userRepositoryProvider).getAllUsers();
          if (allUsers.isNotEmpty) {
            final match = allUsers.where((u) => u.role == _selectedRole).firstOrNull;
            _selectedUserId = match?.id;
          }
      }

      if (_selectedUserId != null || _selectedRole == 'admin') {
          final users = await ref.read(attendanceRepositoryProvider)
              .getParticipatingUsers(_selectedUserId ?? 'ADMIN_SYSTEM', _selectedRole);
              
          // Pre-load existing today's records
          final todayRecords = await ref.read(attendanceRepositoryProvider)
              .getDailyAttendance(DateTime.now());
              
          if (mounted) {
            setState(() {
              _participatingUsers = users;
              _attendanceStatus.clear();
              _checkOutTimes.clear();
              for (var record in todayRecords) {
                String label = 'P';
                if (record.status == 'absent') label = 'A';
                if (record.status == 'half') label = '1/2';
                _attendanceStatus[record.userId] = label;
                _checkOutTimes[record.userId] = record.checkOut;
              }
              _isLoading = false;
            });
          }
      } else if (mounted) {
        setState(() {
          _participatingUsers = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = "Erreur chargement utilisateurs: $e";
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _checkLocation() async {
    // 1. Permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    // 2. Get Position
    try {
      Position position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
      
      // 3. Calc Distance
      double distance = Geolocator.distanceBetween(
        position.latitude, position.longitude, 
        widget.projectLat, widget.projectLong
      );

      // Note: For demo purposes if project coords are 0, we allow it.
      bool allowed = (widget.projectLat == 0.0) || (distance <= widget.radiusMeters);

      setState(() {
        _isWithinRange = allowed;
        _statusMessage = allowed 
            ? "BÂTIMENT A - ZONE VALIDÉE" 
            : "HORS ZONE (${distance.toStringAsFixed(0)}m). Rapprochez-vous.";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = "Erreur GPS: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("POINTAGE DU JOUR"),
        actions: [
          // Role Toggle for testing
          DropdownButton<String>(
            value: _selectedRole,
            dropdownColor: Colors.blue,
            style: const TextStyle(color: Colors.white),
            underline: Container(),
            items: const [
                DropdownMenuItem(value: 'admin', child: Text("Mode Admin")),
                DropdownMenuItem(value: 'supervisor', child: Text("Mode Superviseur")),
            ],
            onChanged: (val) {
                if (val != null) {
                    setState(() {
                        _selectedRole = val;
                        _selectedUserId = null; // Re-fetch
                    });
                    _loadUsers();
                }
            },
          ),
          if (_participatingUsers.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.print),
              onPressed: _printSupervisorAttendance,
              tooltip: "Imprimer la fiche de pointage",
            ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // Status Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: _isLoading ? Colors.grey : (_isWithinRange ? Colors.green[100] : Colors.red[100]),
            child: Row(
              children: [
                Icon(_isLoading ? Icons.gps_fixed : (_isWithinRange ? Icons.check_circle : Icons.error), 
                     color: Colors.black),
                const SizedBox(width: 10),
                Expanded(child: Text(_statusMessage, style: const TextStyle(fontWeight: FontWeight.bold))),
                if (!_isLoading)
                  IconButton(icon: const Icon(Icons.refresh), onPressed: () {
                    setState(() { _isLoading = true; });
                    _checkLocation();
                  })
              ],
            ),
          ),

          // Worker List
          Expanded(
            child: _isLoading ? const Center(child: CircularProgressIndicator()) :
            (!_isWithinRange) ? const Center(child: Text("Pointage bloqué Hors Zone")) :
            _participatingUsers.isEmpty ? const Center(child: Text("Aucun utilisateur à pointer pour ce rôle.")) :
            ListView.separated(
              itemCount: _participatingUsers.length,
              separatorBuilder: (c, i) => const Divider(),
              itemBuilder: (context, index) {
                final user = _participatingUsers[index];
                final status = _attendanceStatus[user.id];
                final checkOut = _checkOutTimes[user.id];
                
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text("${user.firstName} ${user.lastName}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text("${user.role.toUpperCase()} ${checkOut != null ? '• Sortie: ${checkOut.toLocal().toString().split(' ')[1].substring(0, 5)}' : ''}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildStatusBtn(user.id, "P", Colors.green, status == "P"),
                      const SizedBox(width: 5),
                      _buildStatusBtn(user.id, "A", Colors.red, status == "A"),
                      const SizedBox(width: 5),
                      _buildStatusBtn(user.id, "1/2", Colors.orange, status == "1/2"),
                      const SizedBox(width: 15),
                      // Check-out button (Sortie)
                      IconButton(
                        icon: Icon(Icons.logout, color: checkOut != null ? Colors.blue : Colors.grey),
                        onPressed: status == null ? null : () => _markSortie(user.id),
                        tooltip: "Marquer la sortie",
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          if (_isWithinRange && _participatingUsers.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _saveAttendance, 
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text("VALIDER ET SYNCHRONISER"),
                ),
              ),
            )
        ],
      ),
    );
  }

  Future<void> _saveAttendance() async {
    final midnight = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final List<AttendanceCompanion> records = [];

    for (var user in _participatingUsers) {
      final statusLabel = _attendanceStatus[user.id];
      if (statusLabel == null) continue;

      String dbStatus = 'present';
      if (statusLabel == 'A') dbStatus = 'absent';
      if (statusLabel == '1/2') dbStatus = 'half';

      records.add(AttendanceCompanion(
        id: drift.Value("${midnight.year}${midnight.month.toString().padLeft(2,'0')}${midnight.day.toString().padLeft(2,'0')}_${user.id}"),
        userId: drift.Value(user.id),
        date: drift.Value(midnight),
        checkIn: drift.Value(DateTime.now()),
        status: drift.Value(dbStatus),
        // Preserve check-out if already exists
        checkOut: _checkOutTimes[user.id] != null ? drift.Value(_checkOutTimes[user.id]) : const drift.Value.absent(),
      ));
    }

    if (records.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Aucun pointage à enregistrer.")));
        return;
    }

    try {
        await ref.read(attendanceRepositoryProvider).saveDailyAttendance(records);
        if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pointage enregistré avec succès"), backgroundColor: Colors.green));
            _loadUsers(); // Refresh to catch any background updates
        }
    } catch (e) {
        if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur: $e"), backgroundColor: Colors.red));
        }
    }
  }

  Future<void> _markSortie(String userId) async {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day);
    final stableId = "${date.year}${date.month.toString().padLeft(2,'0')}${date.day.toString().padLeft(2,'0')}_$userId";
    
    try {
      await ref.read(attendanceRepositoryProvider).markCheckOut(stableId, now);
      setState(() {
        _checkOutTimes[userId] = now;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Heure de sortie enregistrée : ${DateFormat('HH:mm').format(now)}"),
          backgroundColor: Colors.blue,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("L'employé doit être pointé avant de marquer la sortie."),
          backgroundColor: Colors.orange,
        ));
      }
    }
  }

  Future<void> _printSupervisorAttendance() async {
    try {
      User? supervisor;
      if (_selectedUserId != null && _selectedUserId != 'ADMIN_SYSTEM') {
        supervisor = await ref.read(userRepositoryProvider).getUserById(_selectedUserId!);
      }

      // If no supervisor found (e.g. Admin System mode), create a dummy one for the header
      supervisor ??= User(
        id: 'system',
        firstName: 'Administrateur',
        lastName: 'ETPTS',
        role: 'admin',
        isActive: true,
      );
      
      // Fetch group names for the report
      final db = ref.read(appDatabaseProvider);
      final groups = await db.select(db.workGroups).get();
      final Map<String, String> groupMap = { for (var g in groups) g.id : g.name };

      await PdfService().generateSupervisorAttendanceReport(
        supervisor, 
        _participatingUsers,
        DateTime.now(),
        groupMap,
        _attendanceStatus,
        _checkOutTimes,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur impression: $e")));
    }
  }

  Widget _buildStatusBtn(String userId, String label, Color color, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _attendanceStatus[userId] = label;
        });
      },
      child: Container(
        width: 40, height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label, style: TextStyle(
          color: isSelected ? Colors.white : color, 
          fontWeight: FontWeight.bold
        )),
      ),
    );
  }
}
