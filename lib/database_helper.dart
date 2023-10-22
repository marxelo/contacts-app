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


  // static Future
}
