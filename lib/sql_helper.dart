import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  /*
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  */
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE conexiones(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nombre TEXT,
        ip TEXT,
        topic TEXT,
        port TEXT,
        identificador TEXT,
        usuario TEXT,
        pwd TEXT
      )
      """);
  }
// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'conexiones.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(String nombre, String ip, String topic,
      String port, String identificador, String? usuario, String? pwd) async {
    final db = await SQLHelper.db();

    final data = {
      'nombre': nombre,
      'ip': ip,
      'topic': topic,
      'port': port,
      'identificador': identificador,
      'usuario': usuario,
      'pwd': pwd
    };
    final id = await db.insert('conexiones', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('conexiones', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('conexiones', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(int id, String nombre, String ip, String topic,
      String port, String identificador, String? usuario, String? pwd) async {
    final db = await SQLHelper.db();

    final data = {
      'nombre': nombre,
      'ip': ip,
      'topic': topic,
      'port': port,
      'identificador': identificador,
      'usuario': usuario,
      'pwd': pwd
    };

    final result =
        await db.update('conexiones', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("conexiones", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
