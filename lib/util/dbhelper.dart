import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app/model/shoppingItem.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();
  String tblShopItem = 'shopitem';
  String colId = "id";
  String colName = "name";
  String colAmount = "amount";

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "shoppingitems.db";
    var dbShoppingItems = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbShoppingItems;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
      "CREATE TABLE $tblShopItem($colId INTEGER PRIMARY KEY, $colName TEXT, $colAmount INTEGER)"
    );
  }

  Future<int> insertShopItem(ShoppingItem shopItem) async {
    Database db = await this.db;
    var result = await db.insert(tblShopItem, shopItem.toMap());
    return result;
  }

  Future<List> getShopItems() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM $tblShopItem order by $colName ASC");
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.db;
    var result =Sqflite.firstIntValue(
      await db.rawQuery("select count (*) from $tblShopItem")
    );
    return result;
  }

  Future<int> updateShopItem(ShoppingItem shopItem) async {
    var db = await this.db;
    var result = await db.update(tblShopItem, shopItem.toMap(),
    where: "$colId = ?", whereArgs: [shopItem.id]);
    return result;
  }

  Future<int> deleteShopItem(int id) async {
    var db = await this.db;
    var result = await db.rawDelete("DELETE FROM $tblShopItem WHERE $colId = $id");
    return result;
  }

}