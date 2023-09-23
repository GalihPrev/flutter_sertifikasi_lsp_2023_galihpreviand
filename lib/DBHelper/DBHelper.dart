import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

  // Register user
  Future<void> register(String username, String password) async {
    final db = await database;

    // Check if the username already exists in the "login" table
    final existingUser = await db.query(
      'login',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (existingUser.isEmpty) {
      // If username does not exist, insert the new user into the "login" table
      await db.insert(
        'login',
        {
          'username': username,
          'password': password,
        },
      );
    } else {
      throw Exception('Username already exists');
    }
  }

  // Login user
  Future<bool> login(String username, String password) async {
    final db = await database;

    // Query the "login" table to check if the provided username and password match
    final result = await db.query(
      'login',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    // If a record with the given username and password is found, return true (authenticated)
    return result.isNotEmpty;
  }
}
