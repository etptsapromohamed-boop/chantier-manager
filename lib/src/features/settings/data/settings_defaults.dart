import 'dart:convert';

/// Default configuration values for the application
class SettingsDefaults {
  static const String companyName = 'ETPTS 2026';
  static const String companyAddress = 'Tunis, Tunisie';
  static const String companyPhone = '+216 XX XXX XXX';
  static const String companyEmail = 'contact@etpts.tn';
  static const String companyWebsite = 'www.etpts.tn';
  static const String companyFiscalId = '';
  static const String companyTaxNumber = '';
  static const String companyRegistrationNumber = '';
  
  // Attendance defaults
  static const String workStartTime = '07:00';
  static const String workEndTime = '17:00';
  static const int lunchBreakMinutes = 60;
  static const int lateToleranceMinutes = 15;
  static const bool geolocationRequired = true;
  static const double defaultGeofenceRadius = 100.0;
  static const bool autoCheckoutEnabled = true;
  static const String autoCheckoutTime = '18:00';
  static const bool overtimeEnabled = false;
  static const String overtimeAfterHour = '17:00';
  
  // PDF Export defaults
  static const String pdfHeaderText = 'ETPTS 2026 - Gestion de Chantier';
  static const String pdfFooterText = 'Document généré automatiquement';
  static const bool includeLogo = false;
  static const String primaryColor = '#1976D2'; // Blue
  static const String paperFormat = 'A4';
  static const bool includeStamp = false;
  
  // User defaults
  static const bool passwordRequired = true;
  static const List<String> passwordRequiredRoles = ['admin', 'supervisor', 'worker'];
  static const int minPasswordLength = 6;
  static const bool profilePictureRequired = false;
  static const bool idCardRequired = false;
  
  // General defaults
  static const String language = 'fr';
  static const String dateFormat = 'DD/MM/YYYY';
  static const String timeFormat = '24h';
  static const String timezone = 'Africa/Tunis';
  static const String currency = 'TND'; // TND, EUR, USD, DZD
  
  // Sync defaults
  static const bool autoSync = false;
  static const int syncIntervalMinutes = 15;
  static const bool syncOnChange = false;
  static const bool offlineMode = true;

  /// Returns all default settings as a map
  static Map<String, Map<String, dynamic>> getAllDefaults() {
    return {
      // Company Information
      'company.name': {'value': companyName, 'type': 'string', 'category': 'company'},
      'company.address': {'value': companyAddress, 'type': 'string', 'category': 'company'},
      'company.phone': {'value': companyPhone, 'type': 'string', 'category': 'company'},
      'company.email': {'value': companyEmail, 'type': 'string', 'category': 'company'},
      'company.website': {'value': companyWebsite, 'type': 'string', 'category': 'company'},
      'company.fiscal_id': {'value': companyFiscalId, 'type': 'string', 'category': 'company'},
      'company.tax_number': {'value': companyTaxNumber, 'type': 'string', 'category': 'company'},
      'company.registration_number': {'value': companyRegistrationNumber, 'type': 'string', 'category': 'company'},
      'company.logo': {'value': '', 'type': 'image', 'category': 'company'},
      'company.stamp': {'value': '', 'type': 'image', 'category': 'company'},
      
      // Attendance
      'attendance.work_start': {'value': workStartTime, 'type': 'string', 'category': 'attendance'},
      'attendance.work_end': {'value': workEndTime, 'type': 'string', 'category': 'attendance'},
      'attendance.lunch_break_minutes': {'value': lunchBreakMinutes, 'type': 'int', 'category': 'attendance'},
      'attendance.late_tolerance_minutes': {'value': lateToleranceMinutes, 'type': 'int', 'category': 'attendance'},
      'attendance.geolocation_required': {'value': geolocationRequired, 'type': 'bool', 'category': 'attendance'},
      'attendance.default_geofence_radius': {'value': defaultGeofenceRadius, 'type': 'double', 'category': 'attendance'},
      'attendance.auto_checkout_enabled': {'value': autoCheckoutEnabled, 'type': 'bool', 'category': 'attendance'},
      'attendance.auto_checkout_time': {'value': autoCheckoutTime, 'type': 'string', 'category': 'attendance'},
      'attendance.overtime_enabled': {'value': overtimeEnabled, 'type': 'bool', 'category': 'attendance'},
      'attendance.overtime_after_hour': {'value': overtimeAfterHour, 'type': 'string', 'category': 'attendance'},
      
      // Projects
      'projects.default_name': {'value': 'Nouveau Projet', 'type': 'string', 'category': 'projects'},
      'projects.default_geofence_radius': {'value': defaultGeofenceRadius, 'type': 'double', 'category': 'projects'},
      'projects.use_gps_if_empty': {'value': true, 'type': 'bool', 'category': 'projects'},
      'projects.strict_geofencing': {'value': false, 'type': 'bool', 'category': 'projects'},
      
      // PDF Export
      'pdf.header_text': {'value': pdfHeaderText, 'type': 'string', 'category': 'export'},
      'pdf.footer_text': {'value': pdfFooterText, 'type': 'string', 'category': 'export'},
      'pdf.include_logo': {'value': includeLogo, 'type': 'bool', 'category': 'export'},
      'pdf.primary_color': {'value': primaryColor, 'type': 'color', 'category': 'export'},
      'pdf.paper_format': {'value': paperFormat, 'type': 'string', 'category': 'export'},
      'pdf.include_stamp': {'value': includeStamp, 'type': 'bool', 'category': 'export'},
      
      // Users
      'users.password_required': {'value': passwordRequired, 'type': 'bool', 'category': 'users'},
      'users.password_required_roles': {'value': passwordRequiredRoles, 'type': 'list', 'category': 'users'},
      'users.min_password_length': {'value': minPasswordLength, 'type': 'int', 'category': 'users'},
      'users.profile_picture_required': {'value': profilePictureRequired, 'type': 'bool', 'category': 'users'},
      'users.id_card_required': {'value': idCardRequired, 'type': 'bool', 'category': 'users'},
      
      // General
      'general.language': {'value': language, 'type': 'string', 'category': 'general'},
      'general.date_format': {'value': dateFormat, 'type': 'string', 'category': 'general'},
      'general.time_format': {'value': timeFormat, 'type': 'string', 'category': 'general'},
      'general.timezone': {'value': timezone, 'type': 'string', 'category': 'general'},
      'general.currency': {'value': currency, 'type': 'string', 'category': 'general'},
      
      // Sync
      'sync.auto_sync': {'value': autoSync, 'type': 'bool', 'category': 'sync'},
      'sync.interval_minutes': {'value': syncIntervalMinutes, 'type': 'int', 'category': 'sync'},
      'sync.sync_on_change': {'value': syncOnChange, 'type': 'bool', 'category': 'sync'},
      'sync.offline_mode': {'value': offlineMode, 'type': 'bool', 'category': 'sync'},
    };
  }
}
