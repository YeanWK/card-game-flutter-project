import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  //ดึงข้อมูลจากSQLiteเข้าflutter
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ionic_db.db");
    bool dbExists = await io.File(path).exists();

    if (!dbExists) {
      // Copy from asset
      ByteData data =
          await rootBundle.load(join("assets", "database", "ionic_db.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await io.File(path).writeAsBytes(bytes, flush: true);
    }

    var theDb = await openDatabase(path, version: 1);
    return theDb;
  }

  Future<List<Map<String, dynamic>>> getIonicbond() async {
    var dbClient = await db;
    List<Map<String, dynamic>> list =
        await dbClient!.rawQuery('SELECT * FROM IONICBOND');
    debugPrint("getIonicbond:$list");
    return list;
  }

  Future<List<Map<String, dynamic>>> getAtom() async {
    var dbClient = await db;
    List<Map<String, dynamic>> list =
        await dbClient!.rawQuery('SELECT * FROM ATOM');
    debugPrint("getAtom:$list");
    return list;
  }

  Future<List<Map<String, dynamic>>> getAtomIon() async {
    var dbClient = await db;
    List<Map<String, dynamic>> list =
        await dbClient!.rawQuery('SELECT * FROM ATOM_ION');
    debugPrint("getAtomIon:$list");
    return list;
  }

  Future<List<Map<String, dynamic>>> getContain() async {
    var dbClient = await db;
    List<Map<String, dynamic>> list =
        await dbClient!.rawQuery('SELECT * FROM CONTAIN');
    debugPrint("getContain:$list");
    return list;
  }
}
