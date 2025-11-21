import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/weather_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('weather.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE weather_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cityName TEXT NOT NULL,
        temperature REAL NOT NULL,
        description TEXT NOT NULL,
        icon TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');

    print('✅ Base de datos creada exitosamente');
  }

  // Guardar clima
  Future<int> saveWeather(Weather weather) async {
    final db = await database;
    final id = await db.insert('weather_history', weather.toJson());
    print('💾 Registro guardado en SQLite con ID: $id');
    return id;
  }

  // Obtener últimos 5 registros
  Future<List<Weather>> getRecentWeather({int limit = 5}) async {
    final db = await database;
    final result = await db.query(
      'weather_history',
      orderBy: 'timestamp DESC',
      limit: limit,
    );

    return result.map((json) => Weather.fromStoredJson(json)).toList();
  }

  // Obtener todo el historial
  Future<List<Weather>> getAllWeather() async {
    final db = await database;
    final result = await db.query(
      'weather_history',
      orderBy: 'timestamp DESC',
    );

    return result.map((json) => Weather.fromStoredJson(json)).toList();
  }

  // Limpiar historial
  Future<int> clearHistory() async {
    final db = await database;
    return await db.delete('weather_history');
  }

  // Cerrar base de datos
  Future close() async {
    final db = await database;
    db.close();
  }
}
