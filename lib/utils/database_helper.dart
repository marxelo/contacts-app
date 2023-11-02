import 'package:sqflite/sqflite.dart';
import "package:path/path.dart" as p;
import 'package:contacts_app/model/contact.dart';

class DatabaseHelper {
  static Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = p.join(databasePath, 'contacts_app.db');
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute(''' 
  CREATE TABLE IF NOT EXISTS contacts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name Text,
    phone Text,
    email Text,
    business Text,
    photo Text
  )
  ''');
  }

  static Future<int?> insertContact(Contact contact) async {
    final db = await _openDatabase();
    contact.id = await db.insert('contacts', contact.toMap());
    return contact.id;
  }

  static Future<List<Contact>> getContacts() async {
    final db = await _openDatabase();
    List<Map> maps = await db
        .rawQuery('SELECT * FROM contacts order by name COLLATE NOCASE');
    List<Contact> contacts = [];

    if (maps.isNotEmpty) {
      for (var map in maps) {
        contacts.add(Contact.fromMap(Map<String, dynamic>.from(map)));
      }
    }

    return contacts;
  }

  static Future<int> deleteContact(int id) async {
    final db = await _openDatabase();

    return await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }

  static Future<Contact?> getSingleContact(int id) async {
    final db = await _openDatabase();
    List<Map<String, dynamic>> result = await db.query(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    return result.isNotEmpty ? Contact.fromMap(result.first) : null;
  }

  static Future<int> updateContact(Contact contact) async {
    final db = await _openDatabase();
    return await db.update('contacts', contact.toMap(),
        where: 'id = ?', whereArgs: [contact.id]);
  }
}
