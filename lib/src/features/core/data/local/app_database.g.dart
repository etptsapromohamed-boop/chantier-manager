// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WorkGroupsTable extends WorkGroups
    with TableInfo<$WorkGroupsTable, WorkGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _supervisorIdMeta =
      const VerificationMeta('supervisorId');
  @override
  late final GeneratedColumn<String> supervisorId = GeneratedColumn<String>(
      'supervisor_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, name, supervisorId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_groups';
  @override
  VerificationContext validateIntegrity(Insertable<WorkGroup> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('supervisor_id')) {
      context.handle(
          _supervisorIdMeta,
          supervisorId.isAcceptableOrUnknown(
              data['supervisor_id']!, _supervisorIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkGroup(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      supervisorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supervisor_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $WorkGroupsTable createAlias(String alias) {
    return $WorkGroupsTable(attachedDatabase, alias);
  }
}

class WorkGroup extends DataClass implements Insertable<WorkGroup> {
  final String id;
  final String name;
  final String? supervisorId;
  final DateTime createdAt;
  const WorkGroup(
      {required this.id,
      required this.name,
      this.supervisorId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || supervisorId != null) {
      map['supervisor_id'] = Variable<String>(supervisorId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WorkGroupsCompanion toCompanion(bool nullToAbsent) {
    return WorkGroupsCompanion(
      id: Value(id),
      name: Value(name),
      supervisorId: supervisorId == null && nullToAbsent
          ? const Value.absent()
          : Value(supervisorId),
      createdAt: Value(createdAt),
    );
  }

  factory WorkGroup.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkGroup(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      supervisorId: serializer.fromJson<String?>(json['supervisorId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'supervisorId': serializer.toJson<String?>(supervisorId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WorkGroup copyWith(
          {String? id,
          String? name,
          Value<String?> supervisorId = const Value.absent(),
          DateTime? createdAt}) =>
      WorkGroup(
        id: id ?? this.id,
        name: name ?? this.name,
        supervisorId:
            supervisorId.present ? supervisorId.value : this.supervisorId,
        createdAt: createdAt ?? this.createdAt,
      );
  WorkGroup copyWithCompanion(WorkGroupsCompanion data) {
    return WorkGroup(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      supervisorId: data.supervisorId.present
          ? data.supervisorId.value
          : this.supervisorId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkGroup(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('supervisorId: $supervisorId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, supervisorId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkGroup &&
          other.id == this.id &&
          other.name == this.name &&
          other.supervisorId == this.supervisorId &&
          other.createdAt == this.createdAt);
}

class WorkGroupsCompanion extends UpdateCompanion<WorkGroup> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> supervisorId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const WorkGroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.supervisorId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkGroupsCompanion.insert({
    required String id,
    required String name,
    this.supervisorId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<WorkGroup> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? supervisorId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (supervisorId != null) 'supervisor_id': supervisorId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkGroupsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? supervisorId,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return WorkGroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      supervisorId: supervisorId ?? this.supervisorId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (supervisorId.present) {
      map['supervisor_id'] = Variable<String>(supervisorId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkGroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('supervisorId: $supervisorId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _firstNameMeta =
      const VerificationMeta('firstName');
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
      'first_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastNameMeta =
      const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneNumberMeta =
      const VerificationMeta('phoneNumber');
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
      'phone_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _idCardNumberMeta =
      const VerificationMeta('idCardNumber');
  @override
  late final GeneratedColumn<String> idCardNumber = GeneratedColumn<String>(
      'id_card_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _exactPositionMeta =
      const VerificationMeta('exactPosition');
  @override
  late final GeneratedColumn<String> exactPosition = GeneratedColumn<String>(
      'exact_position', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _profilePicturePathMeta =
      const VerificationMeta('profilePicturePath');
  @override
  late final GeneratedColumn<String> profilePicturePath =
      GeneratedColumn<String>('profile_picture_path', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _idCardFrontPathMeta =
      const VerificationMeta('idCardFrontPath');
  @override
  late final GeneratedColumn<String> idCardFrontPath = GeneratedColumn<String>(
      'id_card_front_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _idCardBackPathMeta =
      const VerificationMeta('idCardBackPath');
  @override
  late final GeneratedColumn<String> idCardBackPath = GeneratedColumn<String>(
      'id_card_back_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
      'group_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES work_groups (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        role,
        firstName,
        lastName,
        phoneNumber,
        email,
        idCardNumber,
        exactPosition,
        password,
        profilePicturePath,
        idCardFrontPath,
        idCardBackPath,
        isActive,
        createdAt,
        updatedAt,
        groupId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
          _phoneNumberMeta,
          phoneNumber.isAcceptableOrUnknown(
              data['phone_number']!, _phoneNumberMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('id_card_number')) {
      context.handle(
          _idCardNumberMeta,
          idCardNumber.isAcceptableOrUnknown(
              data['id_card_number']!, _idCardNumberMeta));
    }
    if (data.containsKey('exact_position')) {
      context.handle(
          _exactPositionMeta,
          exactPosition.isAcceptableOrUnknown(
              data['exact_position']!, _exactPositionMeta));
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    }
    if (data.containsKey('profile_picture_path')) {
      context.handle(
          _profilePicturePathMeta,
          profilePicturePath.isAcceptableOrUnknown(
              data['profile_picture_path']!, _profilePicturePathMeta));
    }
    if (data.containsKey('id_card_front_path')) {
      context.handle(
          _idCardFrontPathMeta,
          idCardFrontPath.isAcceptableOrUnknown(
              data['id_card_front_path']!, _idCardFrontPathMeta));
    }
    if (data.containsKey('id_card_back_path')) {
      context.handle(
          _idCardBackPathMeta,
          idCardBackPath.isAcceptableOrUnknown(
              data['id_card_back_path']!, _idCardBackPathMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name'])!,
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name'])!,
      phoneNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone_number']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      idCardNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id_card_number']),
      exactPosition: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exact_position']),
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password']),
      profilePicturePath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}profile_picture_path']),
      idCardFrontPath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}id_card_front_path']),
      idCardBackPath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}id_card_back_path']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_id']),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String role;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? email;
  final String? idCardNumber;
  final String? exactPosition;
  final String? password;
  final String? profilePicturePath;
  final String? idCardFrontPath;
  final String? idCardBackPath;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? groupId;
  const User(
      {required this.id,
      required this.role,
      required this.firstName,
      required this.lastName,
      this.phoneNumber,
      this.email,
      this.idCardNumber,
      this.exactPosition,
      this.password,
      this.profilePicturePath,
      this.idCardFrontPath,
      this.idCardBackPath,
      required this.isActive,
      this.createdAt,
      this.updatedAt,
      this.groupId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['role'] = Variable<String>(role);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || idCardNumber != null) {
      map['id_card_number'] = Variable<String>(idCardNumber);
    }
    if (!nullToAbsent || exactPosition != null) {
      map['exact_position'] = Variable<String>(exactPosition);
    }
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String>(password);
    }
    if (!nullToAbsent || profilePicturePath != null) {
      map['profile_picture_path'] = Variable<String>(profilePicturePath);
    }
    if (!nullToAbsent || idCardFrontPath != null) {
      map['id_card_front_path'] = Variable<String>(idCardFrontPath);
    }
    if (!nullToAbsent || idCardBackPath != null) {
      map['id_card_back_path'] = Variable<String>(idCardBackPath);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<String>(groupId);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      role: Value(role),
      firstName: Value(firstName),
      lastName: Value(lastName),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      idCardNumber: idCardNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(idCardNumber),
      exactPosition: exactPosition == null && nullToAbsent
          ? const Value.absent()
          : Value(exactPosition),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      profilePicturePath: profilePicturePath == null && nullToAbsent
          ? const Value.absent()
          : Value(profilePicturePath),
      idCardFrontPath: idCardFrontPath == null && nullToAbsent
          ? const Value.absent()
          : Value(idCardFrontPath),
      idCardBackPath: idCardBackPath == null && nullToAbsent
          ? const Value.absent()
          : Value(idCardBackPath),
      isActive: Value(isActive),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      role: serializer.fromJson<String>(json['role']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      email: serializer.fromJson<String?>(json['email']),
      idCardNumber: serializer.fromJson<String?>(json['idCardNumber']),
      exactPosition: serializer.fromJson<String?>(json['exactPosition']),
      password: serializer.fromJson<String?>(json['password']),
      profilePicturePath:
          serializer.fromJson<String?>(json['profilePicturePath']),
      idCardFrontPath: serializer.fromJson<String?>(json['idCardFrontPath']),
      idCardBackPath: serializer.fromJson<String?>(json['idCardBackPath']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      groupId: serializer.fromJson<String?>(json['groupId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'role': serializer.toJson<String>(role),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'email': serializer.toJson<String?>(email),
      'idCardNumber': serializer.toJson<String?>(idCardNumber),
      'exactPosition': serializer.toJson<String?>(exactPosition),
      'password': serializer.toJson<String?>(password),
      'profilePicturePath': serializer.toJson<String?>(profilePicturePath),
      'idCardFrontPath': serializer.toJson<String?>(idCardFrontPath),
      'idCardBackPath': serializer.toJson<String?>(idCardBackPath),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'groupId': serializer.toJson<String?>(groupId),
    };
  }

  User copyWith(
          {String? id,
          String? role,
          String? firstName,
          String? lastName,
          Value<String?> phoneNumber = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> idCardNumber = const Value.absent(),
          Value<String?> exactPosition = const Value.absent(),
          Value<String?> password = const Value.absent(),
          Value<String?> profilePicturePath = const Value.absent(),
          Value<String?> idCardFrontPath = const Value.absent(),
          Value<String?> idCardBackPath = const Value.absent(),
          bool? isActive,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<String?> groupId = const Value.absent()}) =>
      User(
        id: id ?? this.id,
        role: role ?? this.role,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
        email: email.present ? email.value : this.email,
        idCardNumber:
            idCardNumber.present ? idCardNumber.value : this.idCardNumber,
        exactPosition:
            exactPosition.present ? exactPosition.value : this.exactPosition,
        password: password.present ? password.value : this.password,
        profilePicturePath: profilePicturePath.present
            ? profilePicturePath.value
            : this.profilePicturePath,
        idCardFrontPath: idCardFrontPath.present
            ? idCardFrontPath.value
            : this.idCardFrontPath,
        idCardBackPath:
            idCardBackPath.present ? idCardBackPath.value : this.idCardBackPath,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        groupId: groupId.present ? groupId.value : this.groupId,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      role: data.role.present ? data.role.value : this.role,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      phoneNumber:
          data.phoneNumber.present ? data.phoneNumber.value : this.phoneNumber,
      email: data.email.present ? data.email.value : this.email,
      idCardNumber: data.idCardNumber.present
          ? data.idCardNumber.value
          : this.idCardNumber,
      exactPosition: data.exactPosition.present
          ? data.exactPosition.value
          : this.exactPosition,
      password: data.password.present ? data.password.value : this.password,
      profilePicturePath: data.profilePicturePath.present
          ? data.profilePicturePath.value
          : this.profilePicturePath,
      idCardFrontPath: data.idCardFrontPath.present
          ? data.idCardFrontPath.value
          : this.idCardFrontPath,
      idCardBackPath: data.idCardBackPath.present
          ? data.idCardBackPath.value
          : this.idCardBackPath,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('email: $email, ')
          ..write('idCardNumber: $idCardNumber, ')
          ..write('exactPosition: $exactPosition, ')
          ..write('password: $password, ')
          ..write('profilePicturePath: $profilePicturePath, ')
          ..write('idCardFrontPath: $idCardFrontPath, ')
          ..write('idCardBackPath: $idCardBackPath, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('groupId: $groupId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      role,
      firstName,
      lastName,
      phoneNumber,
      email,
      idCardNumber,
      exactPosition,
      password,
      profilePicturePath,
      idCardFrontPath,
      idCardBackPath,
      isActive,
      createdAt,
      updatedAt,
      groupId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.role == this.role &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.phoneNumber == this.phoneNumber &&
          other.email == this.email &&
          other.idCardNumber == this.idCardNumber &&
          other.exactPosition == this.exactPosition &&
          other.password == this.password &&
          other.profilePicturePath == this.profilePicturePath &&
          other.idCardFrontPath == this.idCardFrontPath &&
          other.idCardBackPath == this.idCardBackPath &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.groupId == this.groupId);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> role;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String?> phoneNumber;
  final Value<String?> email;
  final Value<String?> idCardNumber;
  final Value<String?> exactPosition;
  final Value<String?> password;
  final Value<String?> profilePicturePath;
  final Value<String?> idCardFrontPath;
  final Value<String?> idCardBackPath;
  final Value<bool> isActive;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String?> groupId;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.role = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.email = const Value.absent(),
    this.idCardNumber = const Value.absent(),
    this.exactPosition = const Value.absent(),
    this.password = const Value.absent(),
    this.profilePicturePath = const Value.absent(),
    this.idCardFrontPath = const Value.absent(),
    this.idCardBackPath = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.groupId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String role,
    required String firstName,
    required String lastName,
    this.phoneNumber = const Value.absent(),
    this.email = const Value.absent(),
    this.idCardNumber = const Value.absent(),
    this.exactPosition = const Value.absent(),
    this.password = const Value.absent(),
    this.profilePicturePath = const Value.absent(),
    this.idCardFrontPath = const Value.absent(),
    this.idCardBackPath = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.groupId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        role = Value(role),
        firstName = Value(firstName),
        lastName = Value(lastName);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? role,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? phoneNumber,
    Expression<String>? email,
    Expression<String>? idCardNumber,
    Expression<String>? exactPosition,
    Expression<String>? password,
    Expression<String>? profilePicturePath,
    Expression<String>? idCardFrontPath,
    Expression<String>? idCardBackPath,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? groupId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (role != null) 'role': role,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (email != null) 'email': email,
      if (idCardNumber != null) 'id_card_number': idCardNumber,
      if (exactPosition != null) 'exact_position': exactPosition,
      if (password != null) 'password': password,
      if (profilePicturePath != null)
        'profile_picture_path': profilePicturePath,
      if (idCardFrontPath != null) 'id_card_front_path': idCardFrontPath,
      if (idCardBackPath != null) 'id_card_back_path': idCardBackPath,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (groupId != null) 'group_id': groupId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String>? role,
      Value<String>? firstName,
      Value<String>? lastName,
      Value<String?>? phoneNumber,
      Value<String?>? email,
      Value<String?>? idCardNumber,
      Value<String?>? exactPosition,
      Value<String?>? password,
      Value<String?>? profilePicturePath,
      Value<String?>? idCardFrontPath,
      Value<String?>? idCardBackPath,
      Value<bool>? isActive,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<String?>? groupId,
      Value<int>? rowid}) {
    return UsersCompanion(
      id: id ?? this.id,
      role: role ?? this.role,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      idCardNumber: idCardNumber ?? this.idCardNumber,
      exactPosition: exactPosition ?? this.exactPosition,
      password: password ?? this.password,
      profilePicturePath: profilePicturePath ?? this.profilePicturePath,
      idCardFrontPath: idCardFrontPath ?? this.idCardFrontPath,
      idCardBackPath: idCardBackPath ?? this.idCardBackPath,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      groupId: groupId ?? this.groupId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (idCardNumber.present) {
      map['id_card_number'] = Variable<String>(idCardNumber.value);
    }
    if (exactPosition.present) {
      map['exact_position'] = Variable<String>(exactPosition.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (profilePicturePath.present) {
      map['profile_picture_path'] = Variable<String>(profilePicturePath.value);
    }
    if (idCardFrontPath.present) {
      map['id_card_front_path'] = Variable<String>(idCardFrontPath.value);
    }
    if (idCardBackPath.present) {
      map['id_card_back_path'] = Variable<String>(idCardBackPath.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('email: $email, ')
          ..write('idCardNumber: $idCardNumber, ')
          ..write('exactPosition: $exactPosition, ')
          ..write('password: $password, ')
          ..write('profilePicturePath: $profilePicturePath, ')
          ..write('idCardFrontPath: $idCardFrontPath, ')
          ..write('idCardBackPath: $idCardBackPath, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('groupId: $groupId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _geofenceLatMeta =
      const VerificationMeta('geofenceLat');
  @override
  late final GeneratedColumn<double> geofenceLat = GeneratedColumn<double>(
      'geofence_lat', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _geofenceLongMeta =
      const VerificationMeta('geofenceLong');
  @override
  late final GeneratedColumn<double> geofenceLong = GeneratedColumn<double>(
      'geofence_long', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _geofenceRadiusMetersMeta =
      const VerificationMeta('geofenceRadiusMeters');
  @override
  late final GeneratedColumn<double> geofenceRadiusMeters =
      GeneratedColumn<double>('geofence_radius_meters', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(100.0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, geofenceLat, geofenceLong, geofenceRadiusMeters];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(Insertable<Project> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('geofence_lat')) {
      context.handle(
          _geofenceLatMeta,
          geofenceLat.isAcceptableOrUnknown(
              data['geofence_lat']!, _geofenceLatMeta));
    } else if (isInserting) {
      context.missing(_geofenceLatMeta);
    }
    if (data.containsKey('geofence_long')) {
      context.handle(
          _geofenceLongMeta,
          geofenceLong.isAcceptableOrUnknown(
              data['geofence_long']!, _geofenceLongMeta));
    } else if (isInserting) {
      context.missing(_geofenceLongMeta);
    }
    if (data.containsKey('geofence_radius_meters')) {
      context.handle(
          _geofenceRadiusMetersMeta,
          geofenceRadiusMeters.isAcceptableOrUnknown(
              data['geofence_radius_meters']!, _geofenceRadiusMetersMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      geofenceLat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}geofence_lat'])!,
      geofenceLong: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}geofence_long'])!,
      geofenceRadiusMeters: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}geofence_radius_meters'])!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  final String id;
  final String name;
  final double geofenceLat;
  final double geofenceLong;
  final double geofenceRadiusMeters;
  const Project(
      {required this.id,
      required this.name,
      required this.geofenceLat,
      required this.geofenceLong,
      required this.geofenceRadiusMeters});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['geofence_lat'] = Variable<double>(geofenceLat);
    map['geofence_long'] = Variable<double>(geofenceLong);
    map['geofence_radius_meters'] = Variable<double>(geofenceRadiusMeters);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      geofenceLat: Value(geofenceLat),
      geofenceLong: Value(geofenceLong),
      geofenceRadiusMeters: Value(geofenceRadiusMeters),
    );
  }

  factory Project.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      geofenceLat: serializer.fromJson<double>(json['geofenceLat']),
      geofenceLong: serializer.fromJson<double>(json['geofenceLong']),
      geofenceRadiusMeters:
          serializer.fromJson<double>(json['geofenceRadiusMeters']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'geofenceLat': serializer.toJson<double>(geofenceLat),
      'geofenceLong': serializer.toJson<double>(geofenceLong),
      'geofenceRadiusMeters': serializer.toJson<double>(geofenceRadiusMeters),
    };
  }

  Project copyWith(
          {String? id,
          String? name,
          double? geofenceLat,
          double? geofenceLong,
          double? geofenceRadiusMeters}) =>
      Project(
        id: id ?? this.id,
        name: name ?? this.name,
        geofenceLat: geofenceLat ?? this.geofenceLat,
        geofenceLong: geofenceLong ?? this.geofenceLong,
        geofenceRadiusMeters: geofenceRadiusMeters ?? this.geofenceRadiusMeters,
      );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      geofenceLat:
          data.geofenceLat.present ? data.geofenceLat.value : this.geofenceLat,
      geofenceLong: data.geofenceLong.present
          ? data.geofenceLong.value
          : this.geofenceLong,
      geofenceRadiusMeters: data.geofenceRadiusMeters.present
          ? data.geofenceRadiusMeters.value
          : this.geofenceRadiusMeters,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('geofenceLat: $geofenceLat, ')
          ..write('geofenceLong: $geofenceLong, ')
          ..write('geofenceRadiusMeters: $geofenceRadiusMeters')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, geofenceLat, geofenceLong, geofenceRadiusMeters);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.name == this.name &&
          other.geofenceLat == this.geofenceLat &&
          other.geofenceLong == this.geofenceLong &&
          other.geofenceRadiusMeters == this.geofenceRadiusMeters);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> geofenceLat;
  final Value<double> geofenceLong;
  final Value<double> geofenceRadiusMeters;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.geofenceLat = const Value.absent(),
    this.geofenceLong = const Value.absent(),
    this.geofenceRadiusMeters = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    required String name,
    required double geofenceLat,
    required double geofenceLong,
    this.geofenceRadiusMeters = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        geofenceLat = Value(geofenceLat),
        geofenceLong = Value(geofenceLong);
  static Insertable<Project> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? geofenceLat,
    Expression<double>? geofenceLong,
    Expression<double>? geofenceRadiusMeters,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (geofenceLat != null) 'geofence_lat': geofenceLat,
      if (geofenceLong != null) 'geofence_long': geofenceLong,
      if (geofenceRadiusMeters != null)
        'geofence_radius_meters': geofenceRadiusMeters,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<double>? geofenceLat,
      Value<double>? geofenceLong,
      Value<double>? geofenceRadiusMeters,
      Value<int>? rowid}) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      geofenceLat: geofenceLat ?? this.geofenceLat,
      geofenceLong: geofenceLong ?? this.geofenceLong,
      geofenceRadiusMeters: geofenceRadiusMeters ?? this.geofenceRadiusMeters,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (geofenceLat.present) {
      map['geofence_lat'] = Variable<double>(geofenceLat.value);
    }
    if (geofenceLong.present) {
      map['geofence_long'] = Variable<double>(geofenceLong.value);
    }
    if (geofenceRadiusMeters.present) {
      map['geofence_radius_meters'] =
          Variable<double>(geofenceRadiusMeters.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('geofenceLat: $geofenceLat, ')
          ..write('geofenceLong: $geofenceLong, ')
          ..write('geofenceRadiusMeters: $geofenceRadiusMeters, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localIdMeta =
      const VerificationMeta('localId');
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
      'local_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
      'project_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES projects (id)'));
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _taskCatalogIdMeta =
      const VerificationMeta('taskCatalogId');
  @override
  late final GeneratedColumn<String> taskCatalogId = GeneratedColumn<String>(
      'task_catalog_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _assignedGroupIdMeta =
      const VerificationMeta('assignedGroupId');
  @override
  late final GeneratedColumn<String> assignedGroupId = GeneratedColumn<String>(
      'assigned_group_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _completionPercentageMeta =
      const VerificationMeta('completionPercentage');
  @override
  late final GeneratedColumn<int> completionPercentage = GeneratedColumn<int>(
      'completion_percentage', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _lastLocallyUpdatedMeta =
      const VerificationMeta('lastLocallyUpdated');
  @override
  late final GeneratedColumn<DateTime> lastLocallyUpdated =
      GeneratedColumn<DateTime>('last_locally_updated', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        localId,
        title,
        description,
        projectId,
        parentId,
        taskCatalogId,
        assignedGroupId,
        status,
        completionPercentage,
        isSynced,
        lastLocallyUpdated
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(Insertable<Task> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('local_id')) {
      context.handle(_localIdMeta,
          localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('task_catalog_id')) {
      context.handle(
          _taskCatalogIdMeta,
          taskCatalogId.isAcceptableOrUnknown(
              data['task_catalog_id']!, _taskCatalogIdMeta));
    }
    if (data.containsKey('assigned_group_id')) {
      context.handle(
          _assignedGroupIdMeta,
          assignedGroupId.isAcceptableOrUnknown(
              data['assigned_group_id']!, _assignedGroupIdMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('completion_percentage')) {
      context.handle(
          _completionPercentageMeta,
          completionPercentage.isAcceptableOrUnknown(
              data['completion_percentage']!, _completionPercentageMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('last_locally_updated')) {
      context.handle(
          _lastLocallyUpdatedMeta,
          lastLocallyUpdated.isAcceptableOrUnknown(
              data['last_locally_updated']!, _lastLocallyUpdatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      localId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_id']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project_id'])!,
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_id']),
      taskCatalogId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_catalog_id']),
      assignedGroupId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}assigned_group_id']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      completionPercentage: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}completion_percentage'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      lastLocallyUpdated: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_locally_updated']),
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class Task extends DataClass implements Insertable<Task> {
  final String id;
  final String? localId;
  final String title;
  final String? description;
  final String projectId;
  final String? parentId;
  final String? taskCatalogId;
  final String? assignedGroupId;
  final String status;
  final int completionPercentage;
  final bool isSynced;
  final DateTime? lastLocallyUpdated;
  const Task(
      {required this.id,
      this.localId,
      required this.title,
      this.description,
      required this.projectId,
      this.parentId,
      this.taskCatalogId,
      this.assignedGroupId,
      required this.status,
      required this.completionPercentage,
      required this.isSynced,
      this.lastLocallyUpdated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || localId != null) {
      map['local_id'] = Variable<String>(localId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['project_id'] = Variable<String>(projectId);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    if (!nullToAbsent || taskCatalogId != null) {
      map['task_catalog_id'] = Variable<String>(taskCatalogId);
    }
    if (!nullToAbsent || assignedGroupId != null) {
      map['assigned_group_id'] = Variable<String>(assignedGroupId);
    }
    map['status'] = Variable<String>(status);
    map['completion_percentage'] = Variable<int>(completionPercentage);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || lastLocallyUpdated != null) {
      map['last_locally_updated'] = Variable<DateTime>(lastLocallyUpdated);
    }
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      localId: localId == null && nullToAbsent
          ? const Value.absent()
          : Value(localId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      projectId: Value(projectId),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      taskCatalogId: taskCatalogId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskCatalogId),
      assignedGroupId: assignedGroupId == null && nullToAbsent
          ? const Value.absent()
          : Value(assignedGroupId),
      status: Value(status),
      completionPercentage: Value(completionPercentage),
      isSynced: Value(isSynced),
      lastLocallyUpdated: lastLocallyUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLocallyUpdated),
    );
  }

  factory Task.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<String>(json['id']),
      localId: serializer.fromJson<String?>(json['localId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      projectId: serializer.fromJson<String>(json['projectId']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      taskCatalogId: serializer.fromJson<String?>(json['taskCatalogId']),
      assignedGroupId: serializer.fromJson<String?>(json['assignedGroupId']),
      status: serializer.fromJson<String>(json['status']),
      completionPercentage:
          serializer.fromJson<int>(json['completionPercentage']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      lastLocallyUpdated:
          serializer.fromJson<DateTime?>(json['lastLocallyUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'localId': serializer.toJson<String?>(localId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'projectId': serializer.toJson<String>(projectId),
      'parentId': serializer.toJson<String?>(parentId),
      'taskCatalogId': serializer.toJson<String?>(taskCatalogId),
      'assignedGroupId': serializer.toJson<String?>(assignedGroupId),
      'status': serializer.toJson<String>(status),
      'completionPercentage': serializer.toJson<int>(completionPercentage),
      'isSynced': serializer.toJson<bool>(isSynced),
      'lastLocallyUpdated': serializer.toJson<DateTime?>(lastLocallyUpdated),
    };
  }

  Task copyWith(
          {String? id,
          Value<String?> localId = const Value.absent(),
          String? title,
          Value<String?> description = const Value.absent(),
          String? projectId,
          Value<String?> parentId = const Value.absent(),
          Value<String?> taskCatalogId = const Value.absent(),
          Value<String?> assignedGroupId = const Value.absent(),
          String? status,
          int? completionPercentage,
          bool? isSynced,
          Value<DateTime?> lastLocallyUpdated = const Value.absent()}) =>
      Task(
        id: id ?? this.id,
        localId: localId.present ? localId.value : this.localId,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        projectId: projectId ?? this.projectId,
        parentId: parentId.present ? parentId.value : this.parentId,
        taskCatalogId:
            taskCatalogId.present ? taskCatalogId.value : this.taskCatalogId,
        assignedGroupId: assignedGroupId.present
            ? assignedGroupId.value
            : this.assignedGroupId,
        status: status ?? this.status,
        completionPercentage: completionPercentage ?? this.completionPercentage,
        isSynced: isSynced ?? this.isSynced,
        lastLocallyUpdated: lastLocallyUpdated.present
            ? lastLocallyUpdated.value
            : this.lastLocallyUpdated,
      );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      localId: data.localId.present ? data.localId.value : this.localId,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      taskCatalogId: data.taskCatalogId.present
          ? data.taskCatalogId.value
          : this.taskCatalogId,
      assignedGroupId: data.assignedGroupId.present
          ? data.assignedGroupId.value
          : this.assignedGroupId,
      status: data.status.present ? data.status.value : this.status,
      completionPercentage: data.completionPercentage.present
          ? data.completionPercentage.value
          : this.completionPercentage,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      lastLocallyUpdated: data.lastLocallyUpdated.present
          ? data.lastLocallyUpdated.value
          : this.lastLocallyUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('projectId: $projectId, ')
          ..write('parentId: $parentId, ')
          ..write('taskCatalogId: $taskCatalogId, ')
          ..write('assignedGroupId: $assignedGroupId, ')
          ..write('status: $status, ')
          ..write('completionPercentage: $completionPercentage, ')
          ..write('isSynced: $isSynced, ')
          ..write('lastLocallyUpdated: $lastLocallyUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      localId,
      title,
      description,
      projectId,
      parentId,
      taskCatalogId,
      assignedGroupId,
      status,
      completionPercentage,
      isSynced,
      lastLocallyUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.localId == this.localId &&
          other.title == this.title &&
          other.description == this.description &&
          other.projectId == this.projectId &&
          other.parentId == this.parentId &&
          other.taskCatalogId == this.taskCatalogId &&
          other.assignedGroupId == this.assignedGroupId &&
          other.status == this.status &&
          other.completionPercentage == this.completionPercentage &&
          other.isSynced == this.isSynced &&
          other.lastLocallyUpdated == this.lastLocallyUpdated);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<String> id;
  final Value<String?> localId;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> projectId;
  final Value<String?> parentId;
  final Value<String?> taskCatalogId;
  final Value<String?> assignedGroupId;
  final Value<String> status;
  final Value<int> completionPercentage;
  final Value<bool> isSynced;
  final Value<DateTime?> lastLocallyUpdated;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.localId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.projectId = const Value.absent(),
    this.parentId = const Value.absent(),
    this.taskCatalogId = const Value.absent(),
    this.assignedGroupId = const Value.absent(),
    this.status = const Value.absent(),
    this.completionPercentage = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.lastLocallyUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    this.localId = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required String projectId,
    this.parentId = const Value.absent(),
    this.taskCatalogId = const Value.absent(),
    this.assignedGroupId = const Value.absent(),
    this.status = const Value.absent(),
    this.completionPercentage = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.lastLocallyUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        projectId = Value(projectId);
  static Insertable<Task> custom({
    Expression<String>? id,
    Expression<String>? localId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? projectId,
    Expression<String>? parentId,
    Expression<String>? taskCatalogId,
    Expression<String>? assignedGroupId,
    Expression<String>? status,
    Expression<int>? completionPercentage,
    Expression<bool>? isSynced,
    Expression<DateTime>? lastLocallyUpdated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localId != null) 'local_id': localId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (projectId != null) 'project_id': projectId,
      if (parentId != null) 'parent_id': parentId,
      if (taskCatalogId != null) 'task_catalog_id': taskCatalogId,
      if (assignedGroupId != null) 'assigned_group_id': assignedGroupId,
      if (status != null) 'status': status,
      if (completionPercentage != null)
        'completion_percentage': completionPercentage,
      if (isSynced != null) 'is_synced': isSynced,
      if (lastLocallyUpdated != null)
        'last_locally_updated': lastLocallyUpdated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith(
      {Value<String>? id,
      Value<String?>? localId,
      Value<String>? title,
      Value<String?>? description,
      Value<String>? projectId,
      Value<String?>? parentId,
      Value<String?>? taskCatalogId,
      Value<String?>? assignedGroupId,
      Value<String>? status,
      Value<int>? completionPercentage,
      Value<bool>? isSynced,
      Value<DateTime?>? lastLocallyUpdated,
      Value<int>? rowid}) {
    return TasksCompanion(
      id: id ?? this.id,
      localId: localId ?? this.localId,
      title: title ?? this.title,
      description: description ?? this.description,
      projectId: projectId ?? this.projectId,
      parentId: parentId ?? this.parentId,
      taskCatalogId: taskCatalogId ?? this.taskCatalogId,
      assignedGroupId: assignedGroupId ?? this.assignedGroupId,
      status: status ?? this.status,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      isSynced: isSynced ?? this.isSynced,
      lastLocallyUpdated: lastLocallyUpdated ?? this.lastLocallyUpdated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (taskCatalogId.present) {
      map['task_catalog_id'] = Variable<String>(taskCatalogId.value);
    }
    if (assignedGroupId.present) {
      map['assigned_group_id'] = Variable<String>(assignedGroupId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (completionPercentage.present) {
      map['completion_percentage'] = Variable<int>(completionPercentage.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (lastLocallyUpdated.present) {
      map['last_locally_updated'] =
          Variable<DateTime>(lastLocallyUpdated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('projectId: $projectId, ')
          ..write('parentId: $parentId, ')
          ..write('taskCatalogId: $taskCatalogId, ')
          ..write('assignedGroupId: $assignedGroupId, ')
          ..write('status: $status, ')
          ..write('completionPercentage: $completionPercentage, ')
          ..write('isSynced: $isSynced, ')
          ..write('lastLocallyUpdated: $lastLocallyUpdated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskMediaTable extends TaskMedia
    with TableInfo<$TaskMediaTable, TaskMediaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskMediaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tasks (id)'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localPathMeta =
      const VerificationMeta('localPath');
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
      'local_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _storageUrlMeta =
      const VerificationMeta('storageUrl');
  @override
  late final GeneratedColumn<String> storageUrl = GeneratedColumn<String>(
      'storage_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isUploadedMeta =
      const VerificationMeta('isUploaded');
  @override
  late final GeneratedColumn<bool> isUploaded = GeneratedColumn<bool>(
      'is_uploaded', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_uploaded" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, taskId, type, localPath, storageUrl, isUploaded];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_media';
  @override
  VerificationContext validateIntegrity(Insertable<TaskMediaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(_localPathMeta,
          localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta));
    }
    if (data.containsKey('storage_url')) {
      context.handle(
          _storageUrlMeta,
          storageUrl.isAcceptableOrUnknown(
              data['storage_url']!, _storageUrlMeta));
    }
    if (data.containsKey('is_uploaded')) {
      context.handle(
          _isUploadedMeta,
          isUploaded.isAcceptableOrUnknown(
              data['is_uploaded']!, _isUploadedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskMediaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskMediaData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      localPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_path']),
      storageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}storage_url']),
      isUploaded: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_uploaded'])!,
    );
  }

  @override
  $TaskMediaTable createAlias(String alias) {
    return $TaskMediaTable(attachedDatabase, alias);
  }
}

class TaskMediaData extends DataClass implements Insertable<TaskMediaData> {
  final String id;
  final String taskId;
  final String type;
  final String? localPath;
  final String? storageUrl;
  final bool isUploaded;
  const TaskMediaData(
      {required this.id,
      required this.taskId,
      required this.type,
      this.localPath,
      this.storageUrl,
      required this.isUploaded});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    if (!nullToAbsent || storageUrl != null) {
      map['storage_url'] = Variable<String>(storageUrl);
    }
    map['is_uploaded'] = Variable<bool>(isUploaded);
    return map;
  }

  TaskMediaCompanion toCompanion(bool nullToAbsent) {
    return TaskMediaCompanion(
      id: Value(id),
      taskId: Value(taskId),
      type: Value(type),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      storageUrl: storageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(storageUrl),
      isUploaded: Value(isUploaded),
    );
  }

  factory TaskMediaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskMediaData(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      type: serializer.fromJson<String>(json['type']),
      localPath: serializer.fromJson<String?>(json['localPath']),
      storageUrl: serializer.fromJson<String?>(json['storageUrl']),
      isUploaded: serializer.fromJson<bool>(json['isUploaded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'type': serializer.toJson<String>(type),
      'localPath': serializer.toJson<String?>(localPath),
      'storageUrl': serializer.toJson<String?>(storageUrl),
      'isUploaded': serializer.toJson<bool>(isUploaded),
    };
  }

  TaskMediaData copyWith(
          {String? id,
          String? taskId,
          String? type,
          Value<String?> localPath = const Value.absent(),
          Value<String?> storageUrl = const Value.absent(),
          bool? isUploaded}) =>
      TaskMediaData(
        id: id ?? this.id,
        taskId: taskId ?? this.taskId,
        type: type ?? this.type,
        localPath: localPath.present ? localPath.value : this.localPath,
        storageUrl: storageUrl.present ? storageUrl.value : this.storageUrl,
        isUploaded: isUploaded ?? this.isUploaded,
      );
  TaskMediaData copyWithCompanion(TaskMediaCompanion data) {
    return TaskMediaData(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      type: data.type.present ? data.type.value : this.type,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      storageUrl:
          data.storageUrl.present ? data.storageUrl.value : this.storageUrl,
      isUploaded:
          data.isUploaded.present ? data.isUploaded.value : this.isUploaded,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskMediaData(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('type: $type, ')
          ..write('localPath: $localPath, ')
          ..write('storageUrl: $storageUrl, ')
          ..write('isUploaded: $isUploaded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, taskId, type, localPath, storageUrl, isUploaded);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskMediaData &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.type == this.type &&
          other.localPath == this.localPath &&
          other.storageUrl == this.storageUrl &&
          other.isUploaded == this.isUploaded);
}

class TaskMediaCompanion extends UpdateCompanion<TaskMediaData> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> type;
  final Value<String?> localPath;
  final Value<String?> storageUrl;
  final Value<bool> isUploaded;
  final Value<int> rowid;
  const TaskMediaCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.type = const Value.absent(),
    this.localPath = const Value.absent(),
    this.storageUrl = const Value.absent(),
    this.isUploaded = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskMediaCompanion.insert({
    required String id,
    required String taskId,
    required String type,
    this.localPath = const Value.absent(),
    this.storageUrl = const Value.absent(),
    this.isUploaded = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        taskId = Value(taskId),
        type = Value(type);
  static Insertable<TaskMediaData> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? type,
    Expression<String>? localPath,
    Expression<String>? storageUrl,
    Expression<bool>? isUploaded,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (type != null) 'type': type,
      if (localPath != null) 'local_path': localPath,
      if (storageUrl != null) 'storage_url': storageUrl,
      if (isUploaded != null) 'is_uploaded': isUploaded,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskMediaCompanion copyWith(
      {Value<String>? id,
      Value<String>? taskId,
      Value<String>? type,
      Value<String?>? localPath,
      Value<String?>? storageUrl,
      Value<bool>? isUploaded,
      Value<int>? rowid}) {
    return TaskMediaCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      type: type ?? this.type,
      localPath: localPath ?? this.localPath,
      storageUrl: storageUrl ?? this.storageUrl,
      isUploaded: isUploaded ?? this.isUploaded,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (storageUrl.present) {
      map['storage_url'] = Variable<String>(storageUrl.value);
    }
    if (isUploaded.present) {
      map['is_uploaded'] = Variable<bool>(isUploaded.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskMediaCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('type: $type, ')
          ..write('localPath: $localPath, ')
          ..write('storageUrl: $storageUrl, ')
          ..write('isUploaded: $isUploaded, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttendanceTable extends Attendance
    with TableInfo<$AttendanceTable, AttendanceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendanceTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
      'project_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES projects (id)'));
  static const VerificationMeta _checkInMeta =
      const VerificationMeta('checkIn');
  @override
  late final GeneratedColumn<DateTime> checkIn = GeneratedColumn<DateTime>(
      'check_in', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _checkOutMeta =
      const VerificationMeta('checkOut');
  @override
  late final GeneratedColumn<DateTime> checkOut = GeneratedColumn<DateTime>(
      'check_out', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('present'));
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, projectId, checkIn, checkOut, date, status, isSynced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendance';
  @override
  VerificationContext validateIntegrity(Insertable<AttendanceData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    }
    if (data.containsKey('check_in')) {
      context.handle(_checkInMeta,
          checkIn.isAcceptableOrUnknown(data['check_in']!, _checkInMeta));
    } else if (isInserting) {
      context.missing(_checkInMeta);
    }
    if (data.containsKey('check_out')) {
      context.handle(_checkOutMeta,
          checkOut.isAcceptableOrUnknown(data['check_out']!, _checkOutMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttendanceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttendanceData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project_id']),
      checkIn: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}check_in'])!,
      checkOut: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}check_out']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
    );
  }

  @override
  $AttendanceTable createAlias(String alias) {
    return $AttendanceTable(attachedDatabase, alias);
  }
}

class AttendanceData extends DataClass implements Insertable<AttendanceData> {
  final String id;
  final String userId;
  final String? projectId;
  final DateTime checkIn;
  final DateTime? checkOut;
  final DateTime date;
  final String status;
  final bool isSynced;
  const AttendanceData(
      {required this.id,
      required this.userId,
      this.projectId,
      required this.checkIn,
      this.checkOut,
      required this.date,
      required this.status,
      required this.isSynced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    map['check_in'] = Variable<DateTime>(checkIn);
    if (!nullToAbsent || checkOut != null) {
      map['check_out'] = Variable<DateTime>(checkOut);
    }
    map['date'] = Variable<DateTime>(date);
    map['status'] = Variable<String>(status);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  AttendanceCompanion toCompanion(bool nullToAbsent) {
    return AttendanceCompanion(
      id: Value(id),
      userId: Value(userId),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      checkIn: Value(checkIn),
      checkOut: checkOut == null && nullToAbsent
          ? const Value.absent()
          : Value(checkOut),
      date: Value(date),
      status: Value(status),
      isSynced: Value(isSynced),
    );
  }

  factory AttendanceData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttendanceData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      checkIn: serializer.fromJson<DateTime>(json['checkIn']),
      checkOut: serializer.fromJson<DateTime?>(json['checkOut']),
      date: serializer.fromJson<DateTime>(json['date']),
      status: serializer.fromJson<String>(json['status']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'projectId': serializer.toJson<String?>(projectId),
      'checkIn': serializer.toJson<DateTime>(checkIn),
      'checkOut': serializer.toJson<DateTime?>(checkOut),
      'date': serializer.toJson<DateTime>(date),
      'status': serializer.toJson<String>(status),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  AttendanceData copyWith(
          {String? id,
          String? userId,
          Value<String?> projectId = const Value.absent(),
          DateTime? checkIn,
          Value<DateTime?> checkOut = const Value.absent(),
          DateTime? date,
          String? status,
          bool? isSynced}) =>
      AttendanceData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        projectId: projectId.present ? projectId.value : this.projectId,
        checkIn: checkIn ?? this.checkIn,
        checkOut: checkOut.present ? checkOut.value : this.checkOut,
        date: date ?? this.date,
        status: status ?? this.status,
        isSynced: isSynced ?? this.isSynced,
      );
  AttendanceData copyWithCompanion(AttendanceCompanion data) {
    return AttendanceData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      checkIn: data.checkIn.present ? data.checkIn.value : this.checkIn,
      checkOut: data.checkOut.present ? data.checkOut.value : this.checkOut,
      date: data.date.present ? data.date.value : this.date,
      status: data.status.present ? data.status.value : this.status,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('projectId: $projectId, ')
          ..write('checkIn: $checkIn, ')
          ..write('checkOut: $checkOut, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, userId, projectId, checkIn, checkOut, date, status, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendanceData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.projectId == this.projectId &&
          other.checkIn == this.checkIn &&
          other.checkOut == this.checkOut &&
          other.date == this.date &&
          other.status == this.status &&
          other.isSynced == this.isSynced);
}

class AttendanceCompanion extends UpdateCompanion<AttendanceData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String?> projectId;
  final Value<DateTime> checkIn;
  final Value<DateTime?> checkOut;
  final Value<DateTime> date;
  final Value<String> status;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const AttendanceCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.checkIn = const Value.absent(),
    this.checkOut = const Value.absent(),
    this.date = const Value.absent(),
    this.status = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttendanceCompanion.insert({
    required String id,
    required String userId,
    this.projectId = const Value.absent(),
    required DateTime checkIn,
    this.checkOut = const Value.absent(),
    required DateTime date,
    this.status = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        checkIn = Value(checkIn),
        date = Value(date);
  static Insertable<AttendanceData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? projectId,
    Expression<DateTime>? checkIn,
    Expression<DateTime>? checkOut,
    Expression<DateTime>? date,
    Expression<String>? status,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (projectId != null) 'project_id': projectId,
      if (checkIn != null) 'check_in': checkIn,
      if (checkOut != null) 'check_out': checkOut,
      if (date != null) 'date': date,
      if (status != null) 'status': status,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttendanceCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String?>? projectId,
      Value<DateTime>? checkIn,
      Value<DateTime?>? checkOut,
      Value<DateTime>? date,
      Value<String>? status,
      Value<bool>? isSynced,
      Value<int>? rowid}) {
    return AttendanceCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      projectId: projectId ?? this.projectId,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      date: date ?? this.date,
      status: status ?? this.status,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (checkIn.present) {
      map['check_in'] = Variable<DateTime>(checkIn.value);
    }
    if (checkOut.present) {
      map['check_out'] = Variable<DateTime>(checkOut.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('projectId: $projectId, ')
          ..write('checkIn: $checkIn, ')
          ..write('checkOut: $checkOut, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _actionTypeMeta =
      const VerificationMeta('actionType');
  @override
  late final GeneratedColumn<String> actionType = GeneratedColumn<String>(
      'action_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetTableMeta =
      const VerificationMeta('targetTable');
  @override
  late final GeneratedColumn<String> targetTable = GeneratedColumn<String>(
      'target_table', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      payload = GeneratedColumn<String>('payload', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>(
              $SyncQueueTable.$converterpayload);
  static const VerificationMeta _localIdMeta =
      const VerificationMeta('localId');
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
      'local_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('PENDING'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        actionType,
        targetTable,
        payload,
        localId,
        retryCount,
        status,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('action_type')) {
      context.handle(
          _actionTypeMeta,
          actionType.isAcceptableOrUnknown(
              data['action_type']!, _actionTypeMeta));
    } else if (isInserting) {
      context.missing(_actionTypeMeta);
    }
    if (data.containsKey('target_table')) {
      context.handle(
          _targetTableMeta,
          targetTable.isAcceptableOrUnknown(
              data['target_table']!, _targetTableMeta));
    } else if (isInserting) {
      context.missing(_targetTableMeta);
    }
    if (data.containsKey('local_id')) {
      context.handle(_localIdMeta,
          localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      actionType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action_type'])!,
      targetTable: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_table'])!,
      payload: $SyncQueueTable.$converterpayload.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!),
      localId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_id']),
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converterpayload =
      const JsonConverter();
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;
  final String actionType;
  final String targetTable;
  final Map<String, dynamic> payload;
  final String? localId;
  final int retryCount;
  final String status;
  final DateTime createdAt;
  const SyncQueueData(
      {required this.id,
      required this.actionType,
      required this.targetTable,
      required this.payload,
      this.localId,
      required this.retryCount,
      required this.status,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['action_type'] = Variable<String>(actionType);
    map['target_table'] = Variable<String>(targetTable);
    {
      map['payload'] =
          Variable<String>($SyncQueueTable.$converterpayload.toSql(payload));
    }
    if (!nullToAbsent || localId != null) {
      map['local_id'] = Variable<String>(localId);
    }
    map['retry_count'] = Variable<int>(retryCount);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      actionType: Value(actionType),
      targetTable: Value(targetTable),
      payload: Value(payload),
      localId: localId == null && nullToAbsent
          ? const Value.absent()
          : Value(localId),
      retryCount: Value(retryCount),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory SyncQueueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      actionType: serializer.fromJson<String>(json['actionType']),
      targetTable: serializer.fromJson<String>(json['targetTable']),
      payload: serializer.fromJson<Map<String, dynamic>>(json['payload']),
      localId: serializer.fromJson<String?>(json['localId']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'actionType': serializer.toJson<String>(actionType),
      'targetTable': serializer.toJson<String>(targetTable),
      'payload': serializer.toJson<Map<String, dynamic>>(payload),
      'localId': serializer.toJson<String?>(localId),
      'retryCount': serializer.toJson<int>(retryCount),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncQueueData copyWith(
          {int? id,
          String? actionType,
          String? targetTable,
          Map<String, dynamic>? payload,
          Value<String?> localId = const Value.absent(),
          int? retryCount,
          String? status,
          DateTime? createdAt}) =>
      SyncQueueData(
        id: id ?? this.id,
        actionType: actionType ?? this.actionType,
        targetTable: targetTable ?? this.targetTable,
        payload: payload ?? this.payload,
        localId: localId.present ? localId.value : this.localId,
        retryCount: retryCount ?? this.retryCount,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      actionType:
          data.actionType.present ? data.actionType.value : this.actionType,
      targetTable:
          data.targetTable.present ? data.targetTable.value : this.targetTable,
      payload: data.payload.present ? data.payload.value : this.payload,
      localId: data.localId.present ? data.localId.value : this.localId,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('actionType: $actionType, ')
          ..write('targetTable: $targetTable, ')
          ..write('payload: $payload, ')
          ..write('localId: $localId, ')
          ..write('retryCount: $retryCount, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, actionType, targetTable, payload, localId,
      retryCount, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.actionType == this.actionType &&
          other.targetTable == this.targetTable &&
          other.payload == this.payload &&
          other.localId == this.localId &&
          other.retryCount == this.retryCount &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<String> actionType;
  final Value<String> targetTable;
  final Value<Map<String, dynamic>> payload;
  final Value<String?> localId;
  final Value<int> retryCount;
  final Value<String> status;
  final Value<DateTime> createdAt;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.actionType = const Value.absent(),
    this.targetTable = const Value.absent(),
    this.payload = const Value.absent(),
    this.localId = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String actionType,
    required String targetTable,
    required Map<String, dynamic> payload,
    this.localId = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : actionType = Value(actionType),
        targetTable = Value(targetTable),
        payload = Value(payload);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? actionType,
    Expression<String>? targetTable,
    Expression<String>? payload,
    Expression<String>? localId,
    Expression<int>? retryCount,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (actionType != null) 'action_type': actionType,
      if (targetTable != null) 'target_table': targetTable,
      if (payload != null) 'payload': payload,
      if (localId != null) 'local_id': localId,
      if (retryCount != null) 'retry_count': retryCount,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SyncQueueCompanion copyWith(
      {Value<int>? id,
      Value<String>? actionType,
      Value<String>? targetTable,
      Value<Map<String, dynamic>>? payload,
      Value<String?>? localId,
      Value<int>? retryCount,
      Value<String>? status,
      Value<DateTime>? createdAt}) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      actionType: actionType ?? this.actionType,
      targetTable: targetTable ?? this.targetTable,
      payload: payload ?? this.payload,
      localId: localId ?? this.localId,
      retryCount: retryCount ?? this.retryCount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (actionType.present) {
      map['action_type'] = Variable<String>(actionType.value);
    }
    if (targetTable.present) {
      map['target_table'] = Variable<String>(targetTable.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(
          $SyncQueueTable.$converterpayload.toSql(payload.value));
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('actionType: $actionType, ')
          ..write('targetTable: $targetTable, ')
          ..write('payload: $payload, ')
          ..write('localId: $localId, ')
          ..write('retryCount: $retryCount, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
      'updated_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, key, value, type, category, updatedAt, updatedBy];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AppSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_by']),
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String id;
  final String key;
  final String value;
  final String type;
  final String category;
  final DateTime updatedAt;
  final String? updatedBy;
  const AppSetting(
      {required this.id,
      required this.key,
      required this.value,
      required this.type,
      required this.category,
      required this.updatedAt,
      this.updatedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['type'] = Variable<String>(type);
    map['category'] = Variable<String>(category);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || updatedBy != null) {
      map['updated_by'] = Variable<String>(updatedBy);
    }
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      key: Value(key),
      value: Value(value),
      type: Value(type),
      category: Value(category),
      updatedAt: Value(updatedAt),
      updatedBy: updatedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedBy),
    );
  }

  factory AppSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<String>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      type: serializer.fromJson<String>(json['type']),
      category: serializer.fromJson<String>(json['category']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String?>(json['updatedBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'type': serializer.toJson<String>(type),
      'category': serializer.toJson<String>(category),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String?>(updatedBy),
    };
  }

  AppSetting copyWith(
          {String? id,
          String? key,
          String? value,
          String? type,
          String? category,
          DateTime? updatedAt,
          Value<String?> updatedBy = const Value.absent()}) =>
      AppSetting(
        id: id ?? this.id,
        key: key ?? this.key,
        value: value ?? this.value,
        type: type ?? this.type,
        category: category ?? this.category,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      type: data.type.present ? data.type.value : this.type,
      category: data.category.present ? data.category.value : this.category,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, key, value, type, category, updatedAt, updatedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.key == this.key &&
          other.value == this.value &&
          other.type == this.type &&
          other.category == this.category &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> id;
  final Value<String> key;
  final Value<String> value;
  final Value<String> type;
  final Value<String> category;
  final Value<DateTime> updatedAt;
  final Value<String?> updatedBy;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String id,
    required String key,
    required String value,
    required String type,
    required String category,
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        key = Value(key),
        value = Value(value),
        type = Value(type),
        category = Value(category);
  static Insertable<AppSetting> custom({
    Expression<String>? id,
    Expression<String>? key,
    Expression<String>? value,
    Expression<String>? type,
    Expression<String>? category,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (type != null) 'type': type,
      if (category != null) 'category': category,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith(
      {Value<String>? id,
      Value<String>? key,
      Value<String>? value,
      Value<String>? type,
      Value<String>? category,
      Value<DateTime>? updatedAt,
      Value<String?>? updatedBy,
      Value<int>? rowid}) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
      type: type ?? this.type,
      category: category ?? this.category,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorkGroupsTable workGroups = $WorkGroupsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $TaskMediaTable taskMedia = $TaskMediaTable(this);
  late final $AttendanceTable attendance = $AttendanceTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        workGroups,
        users,
        projects,
        tasks,
        taskMedia,
        attendance,
        syncQueue,
        appSettings
      ];
}

typedef $$WorkGroupsTableCreateCompanionBuilder = WorkGroupsCompanion Function({
  required String id,
  required String name,
  Value<String?> supervisorId,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$WorkGroupsTableUpdateCompanionBuilder = WorkGroupsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> supervisorId,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$WorkGroupsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkGroupsTable, WorkGroup> {
  $$WorkGroupsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UsersTable, List<User>> _usersRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.users,
          aliasName: $_aliasNameGenerator(db.workGroups.id, db.users.groupId));

  $$UsersTableProcessedTableManager get usersRefs {
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_usersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WorkGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkGroupsTable> {
  $$WorkGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supervisorId => $composableBuilder(
      column: $table.supervisorId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> usersRefs(
      Expression<bool> Function($$UsersTableFilterComposer f) f) {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WorkGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkGroupsTable> {
  $$WorkGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supervisorId => $composableBuilder(
      column: $table.supervisorId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$WorkGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkGroupsTable> {
  $$WorkGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get supervisorId => $composableBuilder(
      column: $table.supervisorId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> usersRefs<T extends Object>(
      Expression<T> Function($$UsersTableAnnotationComposer a) f) {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WorkGroupsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkGroupsTable,
    WorkGroup,
    $$WorkGroupsTableFilterComposer,
    $$WorkGroupsTableOrderingComposer,
    $$WorkGroupsTableAnnotationComposer,
    $$WorkGroupsTableCreateCompanionBuilder,
    $$WorkGroupsTableUpdateCompanionBuilder,
    (WorkGroup, $$WorkGroupsTableReferences),
    WorkGroup,
    PrefetchHooks Function({bool usersRefs})> {
  $$WorkGroupsTableTableManager(_$AppDatabase db, $WorkGroupsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> supervisorId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkGroupsCompanion(
            id: id,
            name: name,
            supervisorId: supervisorId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> supervisorId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkGroupsCompanion.insert(
            id: id,
            name: name,
            supervisorId: supervisorId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorkGroupsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({usersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (usersRefs) db.users],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (usersRefs)
                    await $_getPrefetchedData<WorkGroup, $WorkGroupsTable,
                            User>(
                        currentTable: table,
                        referencedTable:
                            $$WorkGroupsTableReferences._usersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WorkGroupsTableReferences(db, table, p0)
                                .usersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.groupId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$WorkGroupsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkGroupsTable,
    WorkGroup,
    $$WorkGroupsTableFilterComposer,
    $$WorkGroupsTableOrderingComposer,
    $$WorkGroupsTableAnnotationComposer,
    $$WorkGroupsTableCreateCompanionBuilder,
    $$WorkGroupsTableUpdateCompanionBuilder,
    (WorkGroup, $$WorkGroupsTableReferences),
    WorkGroup,
    PrefetchHooks Function({bool usersRefs})>;
typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  required String role,
  required String firstName,
  required String lastName,
  Value<String?> phoneNumber,
  Value<String?> email,
  Value<String?> idCardNumber,
  Value<String?> exactPosition,
  Value<String?> password,
  Value<String?> profilePicturePath,
  Value<String?> idCardFrontPath,
  Value<String?> idCardBackPath,
  Value<bool> isActive,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String?> groupId,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String> role,
  Value<String> firstName,
  Value<String> lastName,
  Value<String?> phoneNumber,
  Value<String?> email,
  Value<String?> idCardNumber,
  Value<String?> exactPosition,
  Value<String?> password,
  Value<String?> profilePicturePath,
  Value<String?> idCardFrontPath,
  Value<String?> idCardBackPath,
  Value<bool> isActive,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String?> groupId,
  Value<int> rowid,
});

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkGroupsTable _groupIdTable(_$AppDatabase db) => db.workGroups
      .createAlias($_aliasNameGenerator(db.users.groupId, db.workGroups.id));

  $$WorkGroupsTableProcessedTableManager? get groupId {
    final $_column = $_itemColumn<String>('group_id');
    if ($_column == null) return null;
    final manager = $$WorkGroupsTableTableManager($_db, $_db.workGroups)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$AttendanceTable, List<AttendanceData>>
      _attendanceRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.attendance,
          aliasName: $_aliasNameGenerator(db.users.id, db.attendance.userId));

  $$AttendanceTableProcessedTableManager get attendanceRefs {
    final manager = $$AttendanceTableTableManager($_db, $_db.attendance)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_attendanceRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get idCardNumber => $composableBuilder(
      column: $table.idCardNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exactPosition => $composableBuilder(
      column: $table.exactPosition, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profilePicturePath => $composableBuilder(
      column: $table.profilePicturePath,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get idCardFrontPath => $composableBuilder(
      column: $table.idCardFrontPath,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get idCardBackPath => $composableBuilder(
      column: $table.idCardBackPath,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$WorkGroupsTableFilterComposer get groupId {
    final $$WorkGroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.workGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkGroupsTableFilterComposer(
              $db: $db,
              $table: $db.workGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> attendanceRefs(
      Expression<bool> Function($$AttendanceTableFilterComposer f) f) {
    final $$AttendanceTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attendance,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttendanceTableFilterComposer(
              $db: $db,
              $table: $db.attendance,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get idCardNumber => $composableBuilder(
      column: $table.idCardNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exactPosition => $composableBuilder(
      column: $table.exactPosition,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profilePicturePath => $composableBuilder(
      column: $table.profilePicturePath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get idCardFrontPath => $composableBuilder(
      column: $table.idCardFrontPath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get idCardBackPath => $composableBuilder(
      column: $table.idCardBackPath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$WorkGroupsTableOrderingComposer get groupId {
    final $$WorkGroupsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.workGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkGroupsTableOrderingComposer(
              $db: $db,
              $table: $db.workGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get idCardNumber => $composableBuilder(
      column: $table.idCardNumber, builder: (column) => column);

  GeneratedColumn<String> get exactPosition => $composableBuilder(
      column: $table.exactPosition, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get profilePicturePath => $composableBuilder(
      column: $table.profilePicturePath, builder: (column) => column);

  GeneratedColumn<String> get idCardFrontPath => $composableBuilder(
      column: $table.idCardFrontPath, builder: (column) => column);

  GeneratedColumn<String> get idCardBackPath => $composableBuilder(
      column: $table.idCardBackPath, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$WorkGroupsTableAnnotationComposer get groupId {
    final $$WorkGroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.workGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkGroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.workGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> attendanceRefs<T extends Object>(
      Expression<T> Function($$AttendanceTableAnnotationComposer a) f) {
    final $$AttendanceTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attendance,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttendanceTableAnnotationComposer(
              $db: $db,
              $table: $db.attendance,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function({bool groupId, bool attendanceRefs})> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String> firstName = const Value.absent(),
            Value<String> lastName = const Value.absent(),
            Value<String?> phoneNumber = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> idCardNumber = const Value.absent(),
            Value<String?> exactPosition = const Value.absent(),
            Value<String?> password = const Value.absent(),
            Value<String?> profilePicturePath = const Value.absent(),
            Value<String?> idCardFrontPath = const Value.absent(),
            Value<String?> idCardBackPath = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> groupId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            role: role,
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            email: email,
            idCardNumber: idCardNumber,
            exactPosition: exactPosition,
            password: password,
            profilePicturePath: profilePicturePath,
            idCardFrontPath: idCardFrontPath,
            idCardBackPath: idCardBackPath,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            groupId: groupId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String role,
            required String firstName,
            required String lastName,
            Value<String?> phoneNumber = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> idCardNumber = const Value.absent(),
            Value<String?> exactPosition = const Value.absent(),
            Value<String?> password = const Value.absent(),
            Value<String?> profilePicturePath = const Value.absent(),
            Value<String?> idCardFrontPath = const Value.absent(),
            Value<String?> idCardBackPath = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> groupId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            role: role,
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            email: email,
            idCardNumber: idCardNumber,
            exactPosition: exactPosition,
            password: password,
            profilePicturePath: profilePicturePath,
            idCardFrontPath: idCardFrontPath,
            idCardBackPath: idCardBackPath,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            groupId: groupId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UsersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({groupId = false, attendanceRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (attendanceRefs) db.attendance],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (groupId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.groupId,
                    referencedTable: $$UsersTableReferences._groupIdTable(db),
                    referencedColumn:
                        $$UsersTableReferences._groupIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (attendanceRefs)
                    await $_getPrefetchedData<User, $UsersTable,
                            AttendanceData>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._attendanceRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .attendanceRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function({bool groupId, bool attendanceRefs})>;
typedef $$ProjectsTableCreateCompanionBuilder = ProjectsCompanion Function({
  required String id,
  required String name,
  required double geofenceLat,
  required double geofenceLong,
  Value<double> geofenceRadiusMeters,
  Value<int> rowid,
});
typedef $$ProjectsTableUpdateCompanionBuilder = ProjectsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<double> geofenceLat,
  Value<double> geofenceLong,
  Value<double> geofenceRadiusMeters,
  Value<int> rowid,
});

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, Project> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TasksTable, List<Task>> _tasksRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.tasks,
          aliasName: $_aliasNameGenerator(db.projects.id, db.tasks.projectId));

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager($_db, $_db.tasks)
        .filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AttendanceTable, List<AttendanceData>>
      _attendanceRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.attendance,
          aliasName:
              $_aliasNameGenerator(db.projects.id, db.attendance.projectId));

  $$AttendanceTableProcessedTableManager get attendanceRefs {
    final manager = $$AttendanceTableTableManager($_db, $_db.attendance)
        .filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_attendanceRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get geofenceLat => $composableBuilder(
      column: $table.geofenceLat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get geofenceLong => $composableBuilder(
      column: $table.geofenceLong, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get geofenceRadiusMeters => $composableBuilder(
      column: $table.geofenceRadiusMeters,
      builder: (column) => ColumnFilters(column));

  Expression<bool> tasksRefs(
      Expression<bool> Function($$TasksTableFilterComposer f) f) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tasks,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TasksTableFilterComposer(
              $db: $db,
              $table: $db.tasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> attendanceRefs(
      Expression<bool> Function($$AttendanceTableFilterComposer f) f) {
    final $$AttendanceTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attendance,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttendanceTableFilterComposer(
              $db: $db,
              $table: $db.attendance,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get geofenceLat => $composableBuilder(
      column: $table.geofenceLat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get geofenceLong => $composableBuilder(
      column: $table.geofenceLong,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get geofenceRadiusMeters => $composableBuilder(
      column: $table.geofenceRadiusMeters,
      builder: (column) => ColumnOrderings(column));
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get geofenceLat => $composableBuilder(
      column: $table.geofenceLat, builder: (column) => column);

  GeneratedColumn<double> get geofenceLong => $composableBuilder(
      column: $table.geofenceLong, builder: (column) => column);

  GeneratedColumn<double> get geofenceRadiusMeters => $composableBuilder(
      column: $table.geofenceRadiusMeters, builder: (column) => column);

  Expression<T> tasksRefs<T extends Object>(
      Expression<T> Function($$TasksTableAnnotationComposer a) f) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tasks,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TasksTableAnnotationComposer(
              $db: $db,
              $table: $db.tasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> attendanceRefs<T extends Object>(
      Expression<T> Function($$AttendanceTableAnnotationComposer a) f) {
    final $$AttendanceTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attendance,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttendanceTableAnnotationComposer(
              $db: $db,
              $table: $db.attendance,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProjectsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProjectsTable,
    Project,
    $$ProjectsTableFilterComposer,
    $$ProjectsTableOrderingComposer,
    $$ProjectsTableAnnotationComposer,
    $$ProjectsTableCreateCompanionBuilder,
    $$ProjectsTableUpdateCompanionBuilder,
    (Project, $$ProjectsTableReferences),
    Project,
    PrefetchHooks Function({bool tasksRefs, bool attendanceRefs})> {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> geofenceLat = const Value.absent(),
            Value<double> geofenceLong = const Value.absent(),
            Value<double> geofenceRadiusMeters = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProjectsCompanion(
            id: id,
            name: name,
            geofenceLat: geofenceLat,
            geofenceLong: geofenceLong,
            geofenceRadiusMeters: geofenceRadiusMeters,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required double geofenceLat,
            required double geofenceLong,
            Value<double> geofenceRadiusMeters = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProjectsCompanion.insert(
            id: id,
            name: name,
            geofenceLat: geofenceLat,
            geofenceLong: geofenceLong,
            geofenceRadiusMeters: geofenceRadiusMeters,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProjectsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({tasksRefs = false, attendanceRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (tasksRefs) db.tasks,
                if (attendanceRefs) db.attendance
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tasksRefs)
                    await $_getPrefetchedData<Project, $ProjectsTable, Task>(
                        currentTable: table,
                        referencedTable:
                            $$ProjectsTableReferences._tasksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProjectsTableReferences(db, table, p0).tasksRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.projectId == item.id),
                        typedResults: items),
                  if (attendanceRefs)
                    await $_getPrefetchedData<Project, $ProjectsTable,
                            AttendanceData>(
                        currentTable: table,
                        referencedTable:
                            $$ProjectsTableReferences._attendanceRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProjectsTableReferences(db, table, p0)
                                .attendanceRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.projectId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProjectsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProjectsTable,
    Project,
    $$ProjectsTableFilterComposer,
    $$ProjectsTableOrderingComposer,
    $$ProjectsTableAnnotationComposer,
    $$ProjectsTableCreateCompanionBuilder,
    $$ProjectsTableUpdateCompanionBuilder,
    (Project, $$ProjectsTableReferences),
    Project,
    PrefetchHooks Function({bool tasksRefs, bool attendanceRefs})>;
typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  required String id,
  Value<String?> localId,
  required String title,
  Value<String?> description,
  required String projectId,
  Value<String?> parentId,
  Value<String?> taskCatalogId,
  Value<String?> assignedGroupId,
  Value<String> status,
  Value<int> completionPercentage,
  Value<bool> isSynced,
  Value<DateTime?> lastLocallyUpdated,
  Value<int> rowid,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<String> id,
  Value<String?> localId,
  Value<String> title,
  Value<String?> description,
  Value<String> projectId,
  Value<String?> parentId,
  Value<String?> taskCatalogId,
  Value<String?> assignedGroupId,
  Value<String> status,
  Value<int> completionPercentage,
  Value<bool> isSynced,
  Value<DateTime?> lastLocallyUpdated,
  Value<int> rowid,
});

final class $$TasksTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTable, Task> {
  $$TasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) => db.projects
      .createAlias($_aliasNameGenerator(db.tasks.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager($_db, $_db.projects)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TaskMediaTable, List<TaskMediaData>>
      _taskMediaRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.taskMedia,
          aliasName: $_aliasNameGenerator(db.tasks.id, db.taskMedia.taskId));

  $$TaskMediaTableProcessedTableManager get taskMediaRefs {
    final manager = $$TaskMediaTableTableManager($_db, $_db.taskMedia)
        .filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskMediaRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taskCatalogId => $composableBuilder(
      column: $table.taskCatalogId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assignedGroupId => $composableBuilder(
      column: $table.assignedGroupId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get completionPercentage => $composableBuilder(
      column: $table.completionPercentage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastLocallyUpdated => $composableBuilder(
      column: $table.lastLocallyUpdated,
      builder: (column) => ColumnFilters(column));

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableFilterComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> taskMediaRefs(
      Expression<bool> Function($$TaskMediaTableFilterComposer f) f) {
    final $$TaskMediaTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.taskMedia,
        getReferencedColumn: (t) => t.taskId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TaskMediaTableFilterComposer(
              $db: $db,
              $table: $db.taskMedia,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taskCatalogId => $composableBuilder(
      column: $table.taskCatalogId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assignedGroupId => $composableBuilder(
      column: $table.assignedGroupId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get completionPercentage => $composableBuilder(
      column: $table.completionPercentage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastLocallyUpdated => $composableBuilder(
      column: $table.lastLocallyUpdated,
      builder: (column) => ColumnOrderings(column));

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableOrderingComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get taskCatalogId => $composableBuilder(
      column: $table.taskCatalogId, builder: (column) => column);

  GeneratedColumn<String> get assignedGroupId => $composableBuilder(
      column: $table.assignedGroupId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get completionPercentage => $composableBuilder(
      column: $table.completionPercentage, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get lastLocallyUpdated => $composableBuilder(
      column: $table.lastLocallyUpdated, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> taskMediaRefs<T extends Object>(
      Expression<T> Function($$TaskMediaTableAnnotationComposer a) f) {
    final $$TaskMediaTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.taskMedia,
        getReferencedColumn: (t) => t.taskId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TaskMediaTableAnnotationComposer(
              $db: $db,
              $table: $db.taskMedia,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TasksTable,
    Task,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (Task, $$TasksTableReferences),
    Task,
    PrefetchHooks Function({bool projectId, bool taskMediaRefs})> {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> localId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> projectId = const Value.absent(),
            Value<String?> parentId = const Value.absent(),
            Value<String?> taskCatalogId = const Value.absent(),
            Value<String?> assignedGroupId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> completionPercentage = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> lastLocallyUpdated = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksCompanion(
            id: id,
            localId: localId,
            title: title,
            description: description,
            projectId: projectId,
            parentId: parentId,
            taskCatalogId: taskCatalogId,
            assignedGroupId: assignedGroupId,
            status: status,
            completionPercentage: completionPercentage,
            isSynced: isSynced,
            lastLocallyUpdated: lastLocallyUpdated,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> localId = const Value.absent(),
            required String title,
            Value<String?> description = const Value.absent(),
            required String projectId,
            Value<String?> parentId = const Value.absent(),
            Value<String?> taskCatalogId = const Value.absent(),
            Value<String?> assignedGroupId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> completionPercentage = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> lastLocallyUpdated = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksCompanion.insert(
            id: id,
            localId: localId,
            title: title,
            description: description,
            projectId: projectId,
            parentId: parentId,
            taskCatalogId: taskCatalogId,
            assignedGroupId: assignedGroupId,
            status: status,
            completionPercentage: completionPercentage,
            isSynced: isSynced,
            lastLocallyUpdated: lastLocallyUpdated,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TasksTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({projectId = false, taskMediaRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (taskMediaRefs) db.taskMedia],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (projectId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.projectId,
                    referencedTable: $$TasksTableReferences._projectIdTable(db),
                    referencedColumn:
                        $$TasksTableReferences._projectIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (taskMediaRefs)
                    await $_getPrefetchedData<Task, $TasksTable, TaskMediaData>(
                        currentTable: table,
                        referencedTable:
                            $$TasksTableReferences._taskMediaRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TasksTableReferences(db, table, p0).taskMediaRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.taskId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TasksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TasksTable,
    Task,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (Task, $$TasksTableReferences),
    Task,
    PrefetchHooks Function({bool projectId, bool taskMediaRefs})>;
typedef $$TaskMediaTableCreateCompanionBuilder = TaskMediaCompanion Function({
  required String id,
  required String taskId,
  required String type,
  Value<String?> localPath,
  Value<String?> storageUrl,
  Value<bool> isUploaded,
  Value<int> rowid,
});
typedef $$TaskMediaTableUpdateCompanionBuilder = TaskMediaCompanion Function({
  Value<String> id,
  Value<String> taskId,
  Value<String> type,
  Value<String?> localPath,
  Value<String?> storageUrl,
  Value<bool> isUploaded,
  Value<int> rowid,
});

final class $$TaskMediaTableReferences
    extends BaseReferences<_$AppDatabase, $TaskMediaTable, TaskMediaData> {
  $$TaskMediaTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TasksTable _taskIdTable(_$AppDatabase db) => db.tasks
      .createAlias($_aliasNameGenerator(db.taskMedia.taskId, db.tasks.id));

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableManager($_db, $_db.tasks)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TaskMediaTableFilterComposer
    extends Composer<_$AppDatabase, $TaskMediaTable> {
  $$TaskMediaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get storageUrl => $composableBuilder(
      column: $table.storageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isUploaded => $composableBuilder(
      column: $table.isUploaded, builder: (column) => ColumnFilters(column));

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taskId,
        referencedTable: $db.tasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TasksTableFilterComposer(
              $db: $db,
              $table: $db.tasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TaskMediaTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskMediaTable> {
  $$TaskMediaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get storageUrl => $composableBuilder(
      column: $table.storageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isUploaded => $composableBuilder(
      column: $table.isUploaded, builder: (column) => ColumnOrderings(column));

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taskId,
        referencedTable: $db.tasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TasksTableOrderingComposer(
              $db: $db,
              $table: $db.tasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TaskMediaTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskMediaTable> {
  $$TaskMediaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get storageUrl => $composableBuilder(
      column: $table.storageUrl, builder: (column) => column);

  GeneratedColumn<bool> get isUploaded => $composableBuilder(
      column: $table.isUploaded, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taskId,
        referencedTable: $db.tasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TasksTableAnnotationComposer(
              $db: $db,
              $table: $db.tasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TaskMediaTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TaskMediaTable,
    TaskMediaData,
    $$TaskMediaTableFilterComposer,
    $$TaskMediaTableOrderingComposer,
    $$TaskMediaTableAnnotationComposer,
    $$TaskMediaTableCreateCompanionBuilder,
    $$TaskMediaTableUpdateCompanionBuilder,
    (TaskMediaData, $$TaskMediaTableReferences),
    TaskMediaData,
    PrefetchHooks Function({bool taskId})> {
  $$TaskMediaTableTableManager(_$AppDatabase db, $TaskMediaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskMediaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskMediaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskMediaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> taskId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> localPath = const Value.absent(),
            Value<String?> storageUrl = const Value.absent(),
            Value<bool> isUploaded = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskMediaCompanion(
            id: id,
            taskId: taskId,
            type: type,
            localPath: localPath,
            storageUrl: storageUrl,
            isUploaded: isUploaded,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String taskId,
            required String type,
            Value<String?> localPath = const Value.absent(),
            Value<String?> storageUrl = const Value.absent(),
            Value<bool> isUploaded = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskMediaCompanion.insert(
            id: id,
            taskId: taskId,
            type: type,
            localPath: localPath,
            storageUrl: storageUrl,
            isUploaded: isUploaded,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TaskMediaTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (taskId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.taskId,
                    referencedTable:
                        $$TaskMediaTableReferences._taskIdTable(db),
                    referencedColumn:
                        $$TaskMediaTableReferences._taskIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TaskMediaTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TaskMediaTable,
    TaskMediaData,
    $$TaskMediaTableFilterComposer,
    $$TaskMediaTableOrderingComposer,
    $$TaskMediaTableAnnotationComposer,
    $$TaskMediaTableCreateCompanionBuilder,
    $$TaskMediaTableUpdateCompanionBuilder,
    (TaskMediaData, $$TaskMediaTableReferences),
    TaskMediaData,
    PrefetchHooks Function({bool taskId})>;
typedef $$AttendanceTableCreateCompanionBuilder = AttendanceCompanion Function({
  required String id,
  required String userId,
  Value<String?> projectId,
  required DateTime checkIn,
  Value<DateTime?> checkOut,
  required DateTime date,
  Value<String> status,
  Value<bool> isSynced,
  Value<int> rowid,
});
typedef $$AttendanceTableUpdateCompanionBuilder = AttendanceCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String?> projectId,
  Value<DateTime> checkIn,
  Value<DateTime?> checkOut,
  Value<DateTime> date,
  Value<String> status,
  Value<bool> isSynced,
  Value<int> rowid,
});

final class $$AttendanceTableReferences
    extends BaseReferences<_$AppDatabase, $AttendanceTable, AttendanceData> {
  $$AttendanceTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.attendance.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias(
          $_aliasNameGenerator(db.attendance.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager? get projectId {
    final $_column = $_itemColumn<String>('project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager($_db, $_db.projects)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AttendanceTableFilterComposer
    extends Composer<_$AppDatabase, $AttendanceTable> {
  $$AttendanceTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get checkIn => $composableBuilder(
      column: $table.checkIn, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get checkOut => $composableBuilder(
      column: $table.checkOut, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableFilterComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttendanceTableOrderingComposer
    extends Composer<_$AppDatabase, $AttendanceTable> {
  $$AttendanceTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get checkIn => $composableBuilder(
      column: $table.checkIn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get checkOut => $composableBuilder(
      column: $table.checkOut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableOrderingComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttendanceTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttendanceTable> {
  $$AttendanceTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get checkIn =>
      $composableBuilder(column: $table.checkIn, builder: (column) => column);

  GeneratedColumn<DateTime> get checkOut =>
      $composableBuilder(column: $table.checkOut, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttendanceTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AttendanceTable,
    AttendanceData,
    $$AttendanceTableFilterComposer,
    $$AttendanceTableOrderingComposer,
    $$AttendanceTableAnnotationComposer,
    $$AttendanceTableCreateCompanionBuilder,
    $$AttendanceTableUpdateCompanionBuilder,
    (AttendanceData, $$AttendanceTableReferences),
    AttendanceData,
    PrefetchHooks Function({bool userId, bool projectId})> {
  $$AttendanceTableTableManager(_$AppDatabase db, $AttendanceTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendanceTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendanceTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendanceTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String?> projectId = const Value.absent(),
            Value<DateTime> checkIn = const Value.absent(),
            Value<DateTime?> checkOut = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AttendanceCompanion(
            id: id,
            userId: userId,
            projectId: projectId,
            checkIn: checkIn,
            checkOut: checkOut,
            date: date,
            status: status,
            isSynced: isSynced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            Value<String?> projectId = const Value.absent(),
            required DateTime checkIn,
            Value<DateTime?> checkOut = const Value.absent(),
            required DateTime date,
            Value<String> status = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AttendanceCompanion.insert(
            id: id,
            userId: userId,
            projectId: projectId,
            checkIn: checkIn,
            checkOut: checkOut,
            date: date,
            status: status,
            isSynced: isSynced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AttendanceTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false, projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$AttendanceTableReferences._userIdTable(db),
                    referencedColumn:
                        $$AttendanceTableReferences._userIdTable(db).id,
                  ) as T;
                }
                if (projectId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.projectId,
                    referencedTable:
                        $$AttendanceTableReferences._projectIdTable(db),
                    referencedColumn:
                        $$AttendanceTableReferences._projectIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AttendanceTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AttendanceTable,
    AttendanceData,
    $$AttendanceTableFilterComposer,
    $$AttendanceTableOrderingComposer,
    $$AttendanceTableAnnotationComposer,
    $$AttendanceTableCreateCompanionBuilder,
    $$AttendanceTableUpdateCompanionBuilder,
    (AttendanceData, $$AttendanceTableReferences),
    AttendanceData,
    PrefetchHooks Function({bool userId, bool projectId})>;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  required String actionType,
  required String targetTable,
  required Map<String, dynamic> payload,
  Value<String?> localId,
  Value<int> retryCount,
  Value<String> status,
  Value<DateTime> createdAt,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  Value<String> actionType,
  Value<String> targetTable,
  Value<Map<String, dynamic>> payload,
  Value<String?> localId,
  Value<int> retryCount,
  Value<String> status,
  Value<DateTime> createdAt,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actionType => $composableBuilder(
      column: $table.actionType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetTable => $composableBuilder(
      column: $table.targetTable, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>, Map<String, dynamic>,
          String>
      get payload => $composableBuilder(
          column: $table.payload,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actionType => $composableBuilder(
      column: $table.actionType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetTable => $composableBuilder(
      column: $table.targetTable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get actionType => $composableBuilder(
      column: $table.actionType, builder: (column) => column);

  GeneratedColumn<String> get targetTable => $composableBuilder(
      column: $table.targetTable, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> actionType = const Value.absent(),
            Value<String> targetTable = const Value.absent(),
            Value<Map<String, dynamic>> payload = const Value.absent(),
            Value<String?> localId = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SyncQueueCompanion(
            id: id,
            actionType: actionType,
            targetTable: targetTable,
            payload: payload,
            localId: localId,
            retryCount: retryCount,
            status: status,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String actionType,
            required String targetTable,
            required Map<String, dynamic> payload,
            Value<String?> localId = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SyncQueueCompanion.insert(
            id: id,
            actionType: actionType,
            targetTable: targetTable,
            payload: payload,
            localId: localId,
            retryCount: retryCount,
            status: status,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()>;
typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion
    Function({
  required String id,
  required String key,
  required String value,
  required String type,
  required String category,
  Value<DateTime> updatedAt,
  Value<String?> updatedBy,
  Value<int> rowid,
});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<String> id,
  Value<String> key,
  Value<String> value,
  Value<String> type,
  Value<String> category,
  Value<DateTime> updatedAt,
  Value<String?> updatedBy,
  Value<int> rowid,
});

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);
}

class $$AppSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String?> updatedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion(
            id: id,
            key: key,
            value: value,
            type: type,
            category: category,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String key,
            required String value,
            required String type,
            required String category,
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String?> updatedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion.insert(
            id: id,
            key: key,
            value: value,
            type: type,
            category: category,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorkGroupsTableTableManager get workGroups =>
      $$WorkGroupsTableTableManager(_db, _db.workGroups);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$TaskMediaTableTableManager get taskMedia =>
      $$TaskMediaTableTableManager(_db, _db.taskMedia);
  $$AttendanceTableTableManager get attendance =>
      $$AttendanceTableTableManager(_db, _db.attendance);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'3d3a397d2ea952fc020fce0506793a5564e93530';

/// See also [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = Provider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = ProviderRef<AppDatabase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
