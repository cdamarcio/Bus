import 'package:flutter/foundation.dart'; // Para usar kIsWeb
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // Necessário para Web
import 'package:path/path.dart';
import 'package:bus/models/aluno_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // [IMPORTANTE] Inicialização para suporte Web no navegador
    if (kIsWeb) {
      // Define a fábrica de banco de dados para a versão Web
      databaseFactory = databaseFactoryFfiWeb;
      String path = 'frota_escolar_cda.db'; // Na web não usamos getDatabasesPath
      
      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    } else {
      // Configuração padrão para Android/iOS (Tablet real da SEMEC)
      String path = join(await getDatabasesPath(), 'frota_escolar_cda.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // Criação da tabela com Geotagging e Auditoria
    await db.execute('''
      CREATE TABLE alunos(
        matricula TEXT PRIMARY KEY,
        nome TEXT,
        foto_hash TEXT,
        escola TEXT,
        ponto_parada TEXT,
        embarcado INTEGER DEFAULT 0,
        data_hora_embarque TEXT,
        latitude REAL,
        longitude REAL
      )
    ''');
  }

  Future<void> insertAlunos(List<AlunoModel> alunos) async {
    final db = await database;
    Batch batch = db.batch();
    for (var aluno in alunos) {
      batch.insert('alunos', aluno.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }

  Future<List<AlunoModel>> getAlunos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('alunos');
    return List.generate(maps.length, (i) => AlunoModel.fromJson(maps[i]));
  }

  Future<void> registrarEmbarque(String matricula, double lat, double long) async {
    final db = await database;
    await db.update(
      'alunos',
      {
        'embarcado': 1,
        'data_hora_embarque': DateTime.now().toIso8601String(),
        'latitude': lat,
        'longitude': long,
      },
      where: 'matricula = ?',
      whereArgs: [matricula],
    );
  }
}