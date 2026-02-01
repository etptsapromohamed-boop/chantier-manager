import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart'; 
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:chantier_manager/src/features/core/data/local/app_database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

class ExcelService {
  
  // --- USER EXPORT ---
  Future<void> exportUsers(List<User> users) async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['Users'];
    
    // Header
    List<String> headers = ['ID', 'Prénom', 'Nom', 'Téléphone', 'Email', 'Rôle', 'Poste', 'Numéro CNI', 'Mot de passe', 'Actif'];
    sheet.appendRow(headers.map((e) => TextCellValue(e)).toList());
    
    // Data
    for (var user in users) {
      sheet.appendRow([
        TextCellValue(user.id),
        TextCellValue(user.firstName),
        TextCellValue(user.lastName),
        TextCellValue(user.phoneNumber ?? ''),
        TextCellValue(user.email ?? ''),
        TextCellValue(user.role),
        TextCellValue(user.exactPosition ?? ''),
        TextCellValue(user.idCardNumber ?? ''),
        TextCellValue(user.password ?? ''),
        TextCellValue(user.isActive ? 'Oui' : 'Non'),
      ]);
    }
    
    await _saveFile(excel, 'users_export_${DateTime.now().millisecondsSinceEpoch}.xlsx');
  }

  // --- ATTENDANCE EXPORT ---
  Future<void> exportAttendance(List<Map<String, dynamic>> attendanceData) async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['Pointages'];

    // Header
    List<String> headers = ['Date', 'Employé', 'Rôle', 'Projet', 'Entrée', 'Sortie', 'Statut'];
    sheet.appendRow(headers.map((e) => TextCellValue(e)).toList());

    for (var row in attendanceData) {
      final date = row['date'] as DateTime?;
      final checkIn = row['checkIn'] as DateTime?;
      final checkOut = row['checkOut'] as DateTime?;

      sheet.appendRow([
        TextCellValue(date?.toIso8601String().split('T')[0] ?? '-'),
        TextCellValue("${row['firstName']} ${row['lastName']}"),
        TextCellValue(row['role']),
        TextCellValue(row['projectName'] ?? 'N/A'),
        TextCellValue(checkIn?.toIso8601String().split('T')[1].substring(0, 5) ?? '-'),
        TextCellValue(checkOut?.toIso8601String().split('T')[1].substring(0, 5) ?? '-'),
        TextCellValue(row['status']),
      ]);
    }

    await _saveFile(excel, 'pointages_export_${DateTime.now().millisecondsSinceEpoch}.xlsx');
  }

  // --- TEMPLATE GENERATION ---
  Future<void> downloadUserTemplate() async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['Template'];
    
    // Header
    List<String> headers = ['Prénom', 'Nom', 'Téléphone', 'Email', 'Rôle (worker/supervisor/admin)', 'Poste Exacte', 'Numéro CNI', 'Mot de passe (Admin)'];
    sheet.appendRow(headers.map((e) => TextCellValue(e)).toList());
    
    // Example Row
    sheet.appendRow([
      TextCellValue('Jean'),
      TextCellValue('Dupont'),
      TextCellValue('0612345678'),
      TextCellValue('jean@example.com'),
      TextCellValue('worker'),
      TextCellValue('Maçon'),
      TextCellValue('123456789'),
      TextCellValue(''),
    ]);
    
    await _saveFile(excel, 'user_import_template.xlsx');
  }

  // --- IMPORT USERS ---
  Future<List<UsersCompanion>> parseUserImport(PlatformFile file) async {
    try {
      var bytes = file.bytes;
      if (bytes == null && file.path != null) {
        bytes = File(file.path!).readAsBytesSync();
      }
      
      if (bytes == null) throw Exception("Impossible de lire le fichier");

      print("Decoding Excel bytes...");
      var excel = Excel.decodeBytes(bytes);
      List<UsersCompanion> newUsers = [];

      for (var table in excel.tables.keys) {
        var rows = excel.tables[table]?.rows ?? [];
        if (rows.isEmpty) continue;

        // Skip header row (index 0)
        for (int i = 1; i < rows.length; i++) {
          var row = rows[i];
          if (row.isEmpty) continue;

          // Helper to get string value safely from different CellValue types (Excel 4.0.6 compatible)
          String getVal(int idx) {
            if (row.length <= idx) return '';
            final cellValue = row[idx]?.value;
            if (cellValue == null) return '';
            
            // In excel 4.x, we must access .value or use .toString()
            // but for TextCellValue, .value is a TextSpan which doesn't auto-cast to String.
            if (cellValue is TextCellValue) return cellValue.value.toString();
            if (cellValue is IntCellValue) return cellValue.value.toString();
            if (cellValue is DoubleCellValue) return cellValue.value.toString();
            if (cellValue is DateCellValue) {
              return DateTime(cellValue.year, cellValue.month, cellValue.day).toIso8601String();
            }
            if (cellValue is TimeCellValue) {
              return "${cellValue.hour}:${cellValue.minute}:${cellValue.second}";
            }
            if (cellValue is BoolCellValue) return cellValue.value.toString();
            
            return cellValue.toString();
          }

          // Expected Columns: 0:First, 1:Last, 2:Phone, 3:Email, 4:Role, 5:Position, 6:CNI, 7:Password
          String firstName = getVal(0).trim();
          String lastName = getVal(1).trim();
          
          if (firstName.isEmpty || lastName.isEmpty) {
            print("Skipping row $i: Empty name ($firstName $lastName)");
            continue; 
          }

          print("Parsing row $i: $firstName $lastName");

          newUsers.add(UsersCompanion(
            id: drift.Value(Uuid().v4()),
            firstName: drift.Value(firstName),
            lastName: drift.Value(lastName),
            phoneNumber: drift.Value(getVal(2).trim()),
            email: drift.Value(getVal(3).trim()),
            role: drift.Value(getVal(4).trim().toLowerCase()), 
            exactPosition: drift.Value(getVal(5).trim()),
            idCardNumber: drift.Value(getVal(6).trim()),
            password: drift.Value(getVal(7).trim()),
            isActive: const drift.Value(true),
            createdAt: drift.Value(DateTime.now()),
          ));
        }
      }
      
      print("Found ${newUsers.length} users to import");
      return newUsers;
    } catch (e, stack) {
      print("CRITICAL ERROR in parseUserImport: $e");
      print(stack);
      rethrow;
    }
  }

  // --- INTERNAL: SAVE FILE logic (Web vs Native) ---
  Future<void> _saveFile(Excel excel, String fileName) async {
    var fileBytes = excel.save();
    if (fileBytes == null) return;

    if (kIsWeb) {
      final blob = html.Blob([fileBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", fileName)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      if (Platform.isAndroid || Platform.isIOS) {
          print("Saving not fully implemented for native mobile in this snippet.");
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final path = "${dir.path}/$fileName";
        File(path)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);
        print("File saved to $path");
      }
    }
  }
}
