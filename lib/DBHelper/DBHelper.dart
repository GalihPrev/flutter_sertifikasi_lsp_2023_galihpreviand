import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/user.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'my_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE login(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            password TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE register(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            password TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE pengeluaran(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tanggal TEXT,
            keterangan TEXT,
            jumlah REAL
          )
        ''');

        await db.execute('''
          CREATE TABLE pemasukkan(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tanggal TEXT,
            keterangan TEXT,
            jumlah REAL
          )
        ''');
      },
    );
  }

  //Login user

  // Insert user from models User

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('login', user.toMap());
  }

  // Detele User

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('login', where: 'id = ?', whereArgs: [id]);
  }

  
  //  metode untuk operasi CRUD

  // Create (Insert) Data:
  Future<int> insertLogin(Map<String, dynamic> loginData) async {
    final db = await database;
    return await db.insert('login', loginData);
  }

//  Read (Select) Data:
  Future<List<Map<String, dynamic>>> getLoginList() async {
    final db = await database;
    return await db.query('login');
  }

// Update Data:
  Future<int> updateLogin(Map<String, dynamic> loginData) async {
    final db = await database;
    return await db.update('login', loginData,
        where: 'id = ?', whereArgs: [loginData['id']]);
  }

// Delete Data:
  Future<int> deleteLogin(int id) async {
    final db = await database;
    return await db.delete('login', where: 'id = ?', whereArgs: [id]);
  }
}
