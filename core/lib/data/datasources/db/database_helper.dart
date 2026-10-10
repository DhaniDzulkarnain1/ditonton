import 'dart:async';

import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  static const String movieWatchlistTable = 'watchlist';
  static const String tvSeriesWatchlistTable = 'tv_series_watchlist';

  Future<Database> get database async {
    return _database ??= await _initDb();
  }

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

    return openDatabase(databasePath, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $movieWatchlistTable (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE $tvSeriesWatchlistTable (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }

  Future<int> insertWatchlist(String table, Map<String, dynamic> item) async {
    final db = await database;
    return db.insert(table, item);
  }

  Future<int> removeWatchlist(String table, int id) async {
    final db = await database;
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getWatchlistById(String table, int id) async {
    final db = await database;
    final results = await db.query(table, where: 'id = ?', whereArgs: [id]);

    return results.isNotEmpty ? results.first : null;
  }

  Future<List<Map<String, dynamic>>> getWatchlist(String table) async {
    final db = await database;
    return db.query(table);
  }
}
