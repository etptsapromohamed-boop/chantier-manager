import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart'; // For sharing/printing directly
import 'package:intl/intl.dart';
import 'package:chantier_manager/src/features/core/data/local/app_database.dart';
import 'package:chantier_manager/src/features/settings/data/settings_repository.dart';

class PdfService {
  final SettingsRepository? settingsRepo;
  
  PdfService({this.settingsRepo});
  
  Future<void> generateAttendanceReport(
    List<Map<String, dynamic>> data,
    String periodLabel,
    String filterLabel,
  ) async {
    // Load settings first
    final headerText = await settingsRepo?.getSetting<String>('pdf.header_text') ?? "RAPPORT GÉNÉRAL DES POINTAGES";
    final companyName = await settingsRepo?.getSetting<String>('company.name') ?? "ETPTS 2026 - Gestion de Chantier";
    
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return [
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(headerText, 
                      style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                    pw.Text(companyName, 
                      style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
                  ],
                ),
                pw.Text(DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()), 
                  style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
              ],
            ),
            pw.Divider(thickness: 2, color: PdfColors.blue800),
            pw.SizedBox(height: 10),

            // Metadata
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Période : $periodLabel", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("Filtre : ${filterLabel.toUpperCase()}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.SizedBox(height: 20),
            
            // Table
            pw.Table.fromTextArray(
              context: context,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
              rowDecoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5))),
              cellAlignment: pw.Alignment.centerLeft,
              cellPadding: const pw.EdgeInsets.all(5),
              headers: ['Date', 'Employé', 'Rôle', 'Projet', 'Entrée', 'Sortie', 'Statut'],
              data: data.map((row) => [
                _formatDate(row['date']),
                "${row['firstName']} ${row['lastName']}",
                (row['role'] as String? ?? '').toUpperCase(),
                row['projectName'] ?? 'N/A',
                _formatTime(row['checkIn']),
                _formatTime(row['checkOut']),
                (row['status'] as String? ?? 'present').toUpperCase(),
              ]).toList(),
            ),

            pw.SizedBox(height: 40),

            // Footer / Signatures
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  children: [
                    pw.Text("Signature Superviseur", style: pw.TextStyle(decoration: pw.TextDecoration.underline)),
                    pw.SizedBox(height: 40, width: 100),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text("Cachet Administration", style: pw.TextStyle(decoration: pw.TextDecoration.underline)),
                    pw.SizedBox(height: 40, width: 100),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    // Using layoutPdf is more reliable on Web for direct download/print preview
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Rapport_Pointages_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return '-';
    if (date is DateTime) return DateFormat('dd/MM/yyyy').format(date);
    return date.toString().split(' ')[0];
  }

  String _formatTime(dynamic time) {
    if (time == null) return '-';
    if (time is DateTime) return DateFormat('HH:mm').format(time);
    return time.toString();
  }

  Future<void> generateSupervisorAttendanceReport(
    User supervisor,
    List<User> workers,
    DateTime date,
    Map<String, String> groupNames,
    Map<String, String> attendanceStatus,
    Map<String, DateTime?> checkOutTimes,
  ) async {
    final pdf = pw.Document();
    final dateStr = DateFormat('dd/MM/yyyy').format(date);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return [
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("FICHE DE POINTAGE QUOTIDIEN", 
                      style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                    pw.Text("Date : $dateStr", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text("Superviseur : ${supervisor.firstName} ${supervisor.lastName}", 
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Rôle : ${supervisor.role.toUpperCase()}"),
                  ],
                ),
              ],
            ),
            pw.Divider(thickness: 1, color: PdfColors.blue900),
            pw.SizedBox(height: 15),

            // [NEW] Grouped workers logic
            ..._groupWorkers(workers).entries.map((entry) {
              final groupName = groupNames[entry.key] ?? entry.key;
              return _buildGroupTable(context, groupName, entry.value, attendanceStatus, checkOutTimes);
            }).toList(),

            pw.Spacer(),

            // Footer
            pw.Divider(color: PdfColors.grey),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("ETPTS 2026 - Chantier Manager", style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
                pw.Text("Signature de l'administration", style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
              ],
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Fiche_Pointage_${supervisor.lastName}_$dateStr.pdf',
    );
  }

  Map<String, List<User>> _groupWorkers(List<User> workers) {
    final groups = <String, List<User>>{};
    for (var w in workers) {
      final key = w.groupId ?? "Personnel sans équipe";
      if (!groups.containsKey(key)) groups[key] = [];
      groups[key]!.add(w);
    }
    return groups;
  }

  // Helper to draw a table for a group
  pw.Widget _buildGroupTable(
    pw.Context context, 
    String groupName, 
    List<User> workers,
    Map<String, String> attendanceStatus,
    Map<String, DateTime?> checkOutTimes,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 5),
          child: pw.Text("Groupe : $groupName", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey)),
        ),
        pw.Table.fromTextArray(
          context: context,
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey700),
          rowDecoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5))),
          cellAlignment: pw.Alignment.centerLeft,
          cellPadding: const pw.EdgeInsets.all(5),
          headers: ['Nom & Prénom', 'Poste / Position', 'Présence', 'Sortie', 'Signature'],
          columnWidths: {
            0: const pw.FlexColumnWidth(3),
            1: const pw.FlexColumnWidth(2),
            2: const pw.FlexColumnWidth(1),
            3: const pw.FlexColumnWidth(1),
            4: const pw.FlexColumnWidth(2),
          },
          data: workers.map((worker) {
            final status = attendanceStatus[worker.id] ?? "";
            final checkOut = checkOutTimes[worker.id];
            
            return [
              "${worker.firstName} ${worker.lastName}",
              worker.exactPosition ?? "Ouvrier",
              status,
              _formatTime(checkOut),
              "",
            ];
          }).toList().cast<List<dynamic>>(),
        ),
        pw.SizedBox(height: 15),
      ],
    );
  }
}
