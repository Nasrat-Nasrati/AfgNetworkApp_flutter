import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/operator.dart';
import '../models/service_package.dart';
import '../models/package.dart';
import '../models/package_detail.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'afg_network.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE operators (
        id INTEGER PRIMARY KEY,
        name TEXT,
        logo TEXT,
        description TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE service_packages (
        id INTEGER PRIMARY KEY,
        name TEXT,
        is_services INTEGER,
        operator_id INTEGER,
        FOREIGN KEY (operator_id) REFERENCES operators(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE packages (
        id INTEGER PRIMARY KEY,
        name TEXT,
        service_package_id INTEGER,
        FOREIGN KEY (service_package_id) REFERENCES service_packages(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE package_details (
        id INTEGER PRIMARY KEY,
        package_id INTEGER,
        name TEXT,
        price REAL,
        activation_code TEXT,
        deactivation_code TEXT,
        check_balance_code TEXT,
        code TEXT,
        description TEXT,
        button_active TEXT,
        button_deactive TEXT,
        button_check_blance TEXT,
        FOREIGN KEY (package_id) REFERENCES packages(id)
      );
    ''');
  }

  // ---------------- INSERT METHODS ----------------
  Future<void> insertOperator(Operator operator) async {
    final db = await database;
    await db.insert(
      'operators',
      {
        'id': operator.id,
        'name': operator.name,
        'logo': operator.logo,
        'description': operator.description,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertServicePackage(ServicePackage servicePackage) async {
    final db = await database;
    await db.insert(
      'service_packages',
      {
        'id': servicePackage.id,
        'name': servicePackage.name,
        'is_services': servicePackage.isServices ? 1 : 0,
        'operator_id': servicePackage.operatorId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertPackage(Package package) async {
    final db = await database;
    await db.insert(
      'packages',
      {
        'id': package.id,
        'name': package.name,
        'service_package_id': package.servicePackageId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertPackageDetail(PackageDetail detail) async {
    final db = await database;
    await db.insert(
      'package_details',
      {
        'id': detail.id,
        'package_id': detail.packageId,
        'name': detail.name,
        'price': detail.price,
        'activation_code': detail.activationCode,
        'deactivation_code': detail.deactivationCode,
        'check_balance_code': detail.checkBalanceCode,
        'code': detail.code,
        'description': detail.description,
        'button_active': detail.buttonActive,
        'button_deactive': detail.buttonDeactive,
        'button_check_blance': detail.buttonCheckBlance,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ---------------- GET METHODS ----------------

  Future<List<Operator>> getOperators() async {
    final db = await database;
    final maps = await db.query('operators');

    return List.generate(maps.length, (i) {
      return Operator(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
        logo: maps[i]['logo'] as String,
        description: maps[i]['description'] as String,
      );
    });
  }

  Future<List<ServicePackage>> getServicePackages(int operatorId) async {
    final db = await database;
    final maps = await db.query(
      'service_packages',
      where: 'operator_id = ?',
      whereArgs: [operatorId],
    );

    // ابتدا باید اپراتور والد را پیدا کنیم
    final operator = (await getOperators()).firstWhere((op) => op.id == operatorId);

    return List.generate(maps.length, (i) {
      return ServicePackage(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
        isServices: maps[i]['is_services'] == 1,
        operator: operator,
      );
    });
  }

  Future<List<Package>> getPackages(int servicePackageId) async {
    final db = await database;
    final maps = await db.query(
      'packages',
      where: 'service_package_id = ?',
      whereArgs: [servicePackageId],
    );

    final servicePackage = (await getServicePackages(
        (await db.query('service_packages', where: 'id = ?', whereArgs: [servicePackageId])).first['operator_id'] as int))
        .firstWhere((sp) => sp.id == servicePackageId);

    return List.generate(maps.length, (i) {
      return Package(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
        servicePackage: servicePackage,
      );
    });
  }

  Future<List<PackageDetail>> getPackageDetails(int packageId) async {
    final db = await database;
    final maps = await db.query(
      'package_details',
      where: 'package_id = ?',
      whereArgs: [packageId],
    );

    final package = (await getPackages(
        (await db.query('packages', where: 'id = ?', whereArgs: [packageId])).first['service_package_id'] as int))
        .firstWhere((p) => p.id == packageId);

    return List.generate(maps.length, (i) {
      return PackageDetail(
        id: maps[i]['id'] as int,
        package: package,
        name: maps[i]['name'] as String,
        price: (maps[i]['price'] as num?)?.toDouble(),
        activationCode: maps[i]['activation_code'] as String?,
        deactivationCode: maps[i]['deactivation_code'] as String?,
        checkBalanceCode: maps[i]['check_balance_code'] as String?,
        code: maps[i]['code'] as String,
        description: maps[i]['description'] as String?,
        buttonActive: maps[i]['button_active'] as String,
        buttonDeactive: maps[i]['button_deactive'] as String,
        buttonCheckBlance: maps[i]['button_check_blance'] as String,
      );
    });
  }
}

