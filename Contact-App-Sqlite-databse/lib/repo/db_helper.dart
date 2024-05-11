import 'dart:io' as io;

import 'package:contact_list_project/model/contact.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/category.dart';

class DBHelper {
  static const String TABLE_CATEGORY = "Category";
  static const String TABLE_CONTACT = "Contact";

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'contact_db.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $TABLE_CATEGORY (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT NOT NULL)');

    await db.execute('''
      CREATE TABLE $TABLE_CONTACT (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT,
        lastName TEXT,
        mobileNumber TEXT,
        email TEXT,
        category TEXT,
        imagePath TEXT
      )
    ''');
  }

  // CRUD operations for Category
  Future<Category> insertCategory(Category category) async {
    var dbClient = await db;
    await dbClient!.insert(TABLE_CATEGORY, category.toJson());
    return category;
  }

  Future<List<Map<String, dynamic>>?> getAllCategories() async {
    var dbClient = await db;
    return await dbClient?.query(TABLE_CATEGORY);
  }

  Future<int?> updateCategory(Category category) async {
    var dbClient = await db;
    int id = category.id!;
    Map<String, dynamic> row = category.toJson();
    return await dbClient
        ?.update(TABLE_CATEGORY, row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int?> deleteCategory(int id) async {
    var dbClient = await db;
    return await dbClient
        ?.delete(TABLE_CATEGORY, where: 'id = ?', whereArgs: [id]);
  }

  // CRUD operations for Contact
  Future<int?> insertContact(Contact contact) async {
    var dbClient = await db;
    return await dbClient?.insert(TABLE_CONTACT, contact.toJson());
  }

  Future<List<Map<String, dynamic>>?> getAllContacts() async {
    var dbClient = await db;
    return await dbClient?.query(TABLE_CONTACT);
  }

  Future<List<Map<String, dynamic>>?> getAllContactsByCategoryId(
      int category_id) async {
    var dbClient = await db;
    return await dbClient?.query(TABLE_CONTACT,
        where: 'category_id = ?', whereArgs: [category_id]);
  }

  Future<int?> updateContact(Contact contact) async {
    var dbClient = await db;
    int id = contact.id!;
    Map<String, dynamic> row = contact.toJson();
    return await dbClient
        ?.update(TABLE_CONTACT, row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int?> deleteContact(int id) async {
    var dbClient = await db;
    return await dbClient
        ?.delete(TABLE_CONTACT, where: 'id = ?', whereArgs: [id]);
  }
}
