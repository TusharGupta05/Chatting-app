import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:last_task/Message.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String colMessage = 'message';
  String colCreatedAt = 'createdAt';
  String colMode = 'mode';
  String colUser = 'user';
  String user;
  String messageTable = 'message_table';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '$messageTable.db';

    var userDb = openDatabase(path, version: 1, onCreate: _createDatabase);
    return userDb;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  void _createDatabase(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $messageTable($colCreatedAt TEXT, $colUser TEXT, $colMode TEXT, $colMessage, TEXT)');
  }

  Future<List<Map<String, dynamic>>> getMessageMapList(String username) async {
    Database db = await this.database;

    var result = await db
        .rawQuery('SELECT * FROM $messageTable WHERE user = "$username"');

    return result;
  }

  Future<int> insertMessage(Message message) async {
    this.user = message.user;
    Database db = await this.database;
    var result = await db.insert(messageTable, message.toMap());
    return result;
  }

  Future<int> updateMessage(Message message) async {
    var db = await this.database;
    var result = await db.update(messageTable, message.toMap(),
        where: '$colCreatedAt = ?', whereArgs: [message.createdAt]);
    return result;
  }

  Future<int> deleteMessage(Message message) async {
    var db = await this.database;
    int result = await db.delete(messageTable,
        where: '$colCreatedAt = ?', whereArgs: [message.createdAt]);
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $messageTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }
}
