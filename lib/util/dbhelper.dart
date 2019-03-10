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

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }
}