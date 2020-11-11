import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'model.dart';

abstract class DB {
  static Database _db;

  static int get _version => 1;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      String _path = await getDatabasesPath() + 'manicureDb';
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
      print("success");
    } catch (ex) {
      print("failure");
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE categories (id INTEGER PRIMARY KEY NOT NULL, name STRING, color STRING, design STRING)');
    await db.execute(
        'CREATE TABLE manicure (id INTEGER PRIMARY KEY NOT NULL, name STRING, image STRING, categoryId INTEGER)');
    await db.execute(
        'CREATE TABLE favorite (id INTEGER PRIMARY KEY NOT NULL, name STRING, image STRING)');
  }

  static Future<List<Map<String, dynamic>>> query(String table) async =>
      await _db.query(table);

  static Future<int> insert(String table, Model model) async =>
      await _db.insert(table, model.toMap());

  static Future<int> update(String table, Model model) async => await _db
      .update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  static Future<int> delete(String table, Model model) async =>
      await _db.delete(table, where: 'id = ?', whereArgs: [model.id]);
}
