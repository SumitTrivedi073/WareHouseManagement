import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper {

  static final _databaseName = "WareHouseManagement.db";
  static final _databaseVersion = 1;

  static final table = 'productDetails';
  static final columnId = 'column_id';
  static final ownerGuid = 'owner_guid';
  static final locationGuid = 'location_guid';
  static final requester = 'requester';
  static final categoryId = 'category_id';
  static final categorySubId = 'category_subId';
  static final makeGuid = 'make_guid';
  static final modelNumber = 'model_number';
  static final title = 'title';
  static final assetDetail = 'assets_details';
  static final serialNumber = 'setial_number';
  static final selectedDate = 'select_date';
  static final productStatus = 'product_status';
  static final barcode = 'barcode';
  static final purPujNo = 'pur_puj_no';
  static final sellType = 'sell_type';
  static final classType = 'class_type';
  static final lengthActual = 'length_actual';
  static final widthActual = 'width_actual';
  static final heightActual = 'height_actual';
  static final lengthShipping = 'length_shipping';
  static final weightLbsActual = 'weight_lbs_actual';
  static final weightLbsShipping = 'weight_lbs_shipping';
  static final description = 'description';
  static final photo1 = 'photo1';
  static final photo2 = 'photo2';
  static final photo3 = 'photo3';
  static final photo4 = 'photo4';
  static final photo5 = 'photo5';


  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance =
      new DatabaseHelper._privateConstructor();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $ownerGuid TEXT NOT NULL,
            $locationGuid TEXT NOT NULL,
            $requester TEXT NOT NULL,
            $categoryId TEXT NOT NULL,
            $categorySubId TEXT NOT NULL,
            $makeGuid TEXT NOT NULL,
            $modelNumber TEXT NOT NULL,
            $title TEXT NOT NULL,
            $assetDetail TEXT NOT NULL,
            $serialNumber TEXT NOT NULL,
            $selectedDate TEXT NOT NULL,
            $barcode TEXT NOT NULL,
            $purPujNo TEXT NOT NULL,
            $sellType TEXT NOT NULL,
            $classType TEXT NOT NULL,
            $lengthActual TEXT NOT NULL,
            $widthActual TEXT NOT NULL,
            $heightActual TEXT NOT NULL,
            $lengthShipping TEXT NOT NULL,
            $weightLbsActual TEXT NOT NULL,
            $weightLbsShipping TEXT NOT NULL,
            $photo1 TEXT NOT NULL,
            $photo2 TEXT NOT NULL,
            $photo3 TEXT NOT NULL,
            $photo4 TEXT NOT NULL,
            $photo5 TEXT NOT NULL
          )
          ''');
  }

  Future<int> insertData(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllData() async {
    Database db = await instance.database;
    var result = await db.query(table);
    return result.toList();
  }



  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  /*Future<int> updateLocalConveyance(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String CreateDate = row[createDate];
    String CreateTime = row[createTime];
    return await db.update(table, row,  where: "${createDate} = ? AND ${createTime} = ?",
        whereArgs: [CreateDate, CreateTime],
    );
  }*/
  Future<int> deletedata(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String OwnerGuid = row[ownerGuid];
    return await db.delete(table,   where: "${ownerGuid} = ?",
    whereArgs: [OwnerGuid],);
  }

}
