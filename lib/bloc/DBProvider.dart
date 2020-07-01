import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uree/models/links_model.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = "${documentsDirectory.path}/urlShortener.db";
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE links ("
          "id INTEGER PRIMARY KEY,"
          "long TEXT,"
          "short TEXT,"
          "api TEXT,"
          "date_created TEXT"
          ")");
    });
  }

  newLink(Links newlink) async {
    final db = await database;
    var res = await db.insert('links', newlink.toMap());
    return res;
  }

  getAllLinks() async {
    final db = await database;
    var res = await db.query("links");
    List<Links> list =
    res.isNotEmpty ? res.map((c) => Links.fromMap(c)).toList() : [];
    return list;
  }

  deleteLink(id) async {
    final db = await database;
    db.delete("links", where: "id = ?", whereArgs: [id]);
  }

}
