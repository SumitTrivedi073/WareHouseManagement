import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper {

  static final _databaseName = "WareHouseManagement.db";
  static final _databaseVersion = 1;

  static final table = 'productDetails';
  static final columnId = 'column_id';
  static final ownerGuid = 'ownerGuid';
  static final locationGuid = 'locationGuid';
  static final requester = 'requester';
  static final purPujNo = 'purPujNo';
  static final categoryId = 'categoryId';
  static final categorySubId = 'categorySubId';
  static final makeGuid = 'makeGuid';
  static final modelNumber = 'modelNumber';
  static final title = 'title';
  static final assetDetail = 'assetDetail';
  static final serialNumber = 'serialNumber';
  static final selectedDate = 'selectedDate';
  static final productStatus = 'productStatus';
  static final barcode = 'barcode';

  static final sellType = 'sellType';
  static final classType = 'classType';
  static final lengthActual = 'lengthActual';
  static final widthActual = 'widthActual';
  static final heightActual = 'heightActual';
  static final lengthShipping = 'lengthShipping';
  static final weightLbsActual = 'weightLbsActual';
  static final weightLbsShipping = 'weightLbsShipping';
  static final heightShipping = 'heightShipping';
  static final widthShipping = 'widthShipping';

  static final description = 'description';
  static final photo1 = 'photo1';
  static final photo2 = 'photo2';
  static final photo3 = 'photo3';
  static final photo4 = 'photo4';
  static final photo5 = 'photo5';

  static final locationId = 'locationId';
  static final locationName = "locationName";
  static final countryId = "countryId";
  static final stateId = "stateId";
  static final province = "province";
  static final address = "address";
  static final city = "city";
  static final zipCode = "zipCode";
  static final isSelected = "isSelected";


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
    db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $ownerGuid TEXT NOT NULL,
            $locationGuid TEXT NOT NULL,
            $requester TEXT NOT NULL,
            $purPujNo TEXT NOT NULL,
            $locationName TEXT NOT NULL,
            $countryId TEXT NOT NULL,
            $stateId TEXT NOT NULL,
            $province TEXT NOT NULL,
            $address TEXT NOT NULL,
            $city TEXT NOT NULL,
            $zipCode TEXT NOT NULL,
            $categoryId TEXT NOT NULL,
            $categorySubId TEXT NOT NULL,
            $makeGuid TEXT NOT NULL,
            $modelNumber TEXT NOT NULL,
            $title TEXT NOT NULL,
            $assetDetail TEXT NOT NULL,
            $serialNumber TEXT NOT NULL,
            $selectedDate TEXT NOT NULL,
            $productStatus TEXT NOT NULL,
            $barcode TEXT NOT NULL,      
            $sellType TEXT NOT NULL,
            $classType TEXT NOT NULL,
            $lengthActual TEXT NOT NULL,
            $widthActual TEXT NOT NULL,
            $heightActual TEXT NOT NULL,
            $lengthShipping TEXT NOT NULL,
            $weightLbsActual TEXT NOT NULL,
            $weightLbsShipping TEXT NOT NULL,
            $heightShipping TEXT NOT NULL,
            $widthShipping TEXT NOT NULL,
            $description TEXT NOT NULL,
            $photo1 TEXT NOT NULL,
            $photo2 TEXT NOT NULL,
            $photo3 TEXT NOT NULL,
            $photo4 TEXT NOT NULL,
            $photo5 TEXT NOT NULL,
            $isSelected TEXT NOT NULL 
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


  Future<int> updateData(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String OwnerGuid = row[ownerGuid];
    return await db.update(table, row,  where: "${ownerGuid} = ?",
        whereArgs: [OwnerGuid],
    );
  }
  Future<int> deletedata(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String OwnerGuid = row[ownerGuid];
    return await db.delete(table,   where: "${ownerGuid} = ?",
    whereArgs: [OwnerGuid],);
  }

  Future<int> deleteTable() async {
    Database db = await instance.database;
    return await db.delete(table);
  }



}
