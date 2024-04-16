import 'package:sa3_lista/Model/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal() {
    initDb();
  }

  late Database _db;

  Future<void> initDb() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'authentication.db');

    _db = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS users(
            username TEXT PRIMARY KEY,
            password TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertUser(User user) async {
    await initDb();
    final dbClient = _db;
    return await dbClient.insert('users', user.toMap());
  }

  Future<User?> getUser(String username, String password) async {
    
    await initDb();
    final dbClient = _db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  Future<int> deleteUser(String username) async {
    print('Chamado deleteUser com username: $username');
    await initDb();
    final dbClient = _db;
    final rowsDeleted = await dbClient.delete(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    print('Registros excluídos: $rowsDeleted');
    return rowsDeleted;
  }
}
