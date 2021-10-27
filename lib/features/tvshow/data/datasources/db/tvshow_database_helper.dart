import 'dart:async';

import 'package:ditonton/features/tvshow/data/models/tvshow_table.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:hive/hive.dart';

class TvShowDatabaseHelper {
  static TvShowDatabaseHelper? _databaseHelper;
  TvShowDatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory TvShowDatabaseHelper() =>
      _databaseHelper ?? TvShowDatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initDb();
    }
    return _database;
  }

  static const String _tblWatchlist = 'tvshow_watchlist';
  static const String _tblCache = 'tvshow_cache';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';
    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
  }

  Future<void> insertCacheTransaction(
      List<TvShowTable> tvShows, String category) async {
    final db = await database;
    db!.transaction((txn) async {
      for (final tvShow in tvShows) {
        final tvshowJson = tvShow.toJson();
        tvshowJson['category'] = category;
        txn.insert(_tblCache, tvshowJson);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getCacheMovies(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblCache,
      where: 'category = ?',
      whereArgs: [category],
    );

    return results;
  }

  Future<int> clearCache(String category) async {
    final db = await database;
    return await db!.delete(
      _tblCache,
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  Future<int> insertWatchlist(TvShowTable tvShow) async {
    final db = await database;
    return await db!.insert(_tblWatchlist, tvShow.toJson());
  }

  Future<int> removeWatchlist(TvShowTable tvShow) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [tvShow.id],
    );
  }

  Future<Map<String, dynamic>?> getTvShowById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistTvShows() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tblWatchlist);

    return results;
  }
}
