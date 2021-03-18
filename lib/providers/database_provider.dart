import 'dart:io';
import 'package:flutter_sqlite/models/joke_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    //create a new db or return existing db
    if (_database != null) {
      return _database;
    } else {
      _database = await initDB();
    }
    return _database;
  }

  // Create the database
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'jokes.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Joke('
          'id INTEGER PRIMARY KEY,'
          'joke TEXT'
          ')');
    });
  }

  createJoke(Joke newJoke) async {
    final db = await database;
    final res = await db.insert('Joke', newJoke.toJson());

    return res;
  }

  Future<int> deleteAllJokes() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Joke');

    return res;
  }

  Future<List<Joke>> getAllJokes() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Joke");

    List<Joke> list =
        res.isNotEmpty ? res.map((c) => Joke.fromJson(c)).toList() : [];

    return list;
  }
}
