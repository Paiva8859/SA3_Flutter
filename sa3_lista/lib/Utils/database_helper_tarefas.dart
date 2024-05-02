import 'package:path/path.dart';
import 'package:sa3_lista/Model/tarefa.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperTarefas {
  late Database _db;

  Future<void> initializeDatabase() async {
    String path = await getDatabasesPath();
    path = join(path, 'authentication.db');

    _db = await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE tarefa (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        concluido INTEGER,
        categoria TEXT,
        username TEXT
      )
    ''');
  }

  Future<List<Tarefa>> getTarefasByUsername(String username) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'tarefa',
      where: 'username = ?',
      whereArgs: [username],
    );

    return List.generate(maps.length, (i) {
      return Tarefa.fromMap(maps[i]);
    });
  }

  Future<void> insertTarefa(Tarefa tarefa) async {
    await _db.insert('tarefa', tarefa.toMap());
  }

  Future<void> updateTarefa(Tarefa tarefa) async {
    await _db.update(
      'tarefa',
      tarefa.toMap(),
      where: 'id = ?',
      whereArgs: [tarefa.id],
    );
  }

  Future<void> deleteTarefa(int id) async {
    await _db.delete(
      'tarefa',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
