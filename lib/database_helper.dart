import 'package:sqflite/sqflite.dart';
import "package:path/path.dart";

class DatabaseHelper {
  static Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'contacts_app.db');
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute(''' 
  CREATE TABLE IF NOT EXISTS contacts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name Text,
    phone Text,
    email Text,
    photo Text
  )
  ''');
  }

  static Future<int> insertContact(
      String name, String phone, String email, String photo) async {
    final db = await _openDatabase();
    final data = {
      'name': name,
      'phone': phone,
      'email': email,
      'photo': photo,
    };
    return await db.insert('contacts', data);
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await _openDatabase();

    return await db.query('contacts', orderBy: 'name');
  }

  static Future<int> deleteData(int id) async {
    final db = await _openDatabase();

    return await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }

  static Future<Map<String, dynamic>?> getSingleData(int id) async {
    final db = await _openDatabase();
    List<Map<String, dynamic>> result = await db.query(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    return result.isNotEmpty ? result.first : null;
  }

  static Future<int> updateData(int id, Map<String, dynamic> data) async {
    final db = await _openDatabase();
    return await db.update('contacts', data, where: 'id = ?', whereArgs: [id]);
  }
}