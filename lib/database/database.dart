  // import 'dart:io';
  //
  // import 'package:path_provider/path_provider.dart';
  // import 'package:sqflite/sqflite.dart';
  // import 'package:path_provider/path_provider.dart';
  // import 'package:path/path.dart';
  //
  // class MyDatabase{
  //   static Database? _database;
  //
  //   Future<Database> initDatabase() async{
  //     if(_database != null){
  //       return _database!;
  //     }
  //
  //     Directory directory = await getApplicationCacheDirectory();
  //     String path = join(directory.path , 'Lens');
  //
  //     _database = await openDatabase(
  //       path,
  //       version: 1,
  //       onCreate: (db, version) async{
  //         await db.execute('''
  //           CREATE TABLE LENS(
  //             id INTEGER PRIMARY KEY AUTOINCREMENT,
  //             brand TEXT,
  //             purchased_date TEXT NOT NULL,
  //             expiry_date TEXT NOT NULL
  //           )''');
  //
  //         await db.execute('''
  //            CREATE TABLE WEAR_LOG(
  //             id INTEGER PRIMARY KEY AUTOINCREMENT,
  //             lens_id INTEGER,
  //             date TEXT NOT NULL,
  //             hours_worn TEXT NOT NULL,
  //             notes TEXT,
  //             FOREIGN KEY (lens_id) REFERENCES LENS(id)
  //            )
  //         ''');
  //       },
  //     );
  //       return _database!;
  //   }
  //
  //   Future<void> insertLens(Map<String, dynamic> lens) async {
  //     Database db = await initDatabase();
  //     await db.insert("LENS", lens);
  //   }
  //
  //   Future<void> insertWearLog(Map<String , dynamic> wearLog) async{
  //     Database db = await initDatabase();
  //     await db.insert("WEAR_LOG", wearLog);
  //   }
  //
  //   Future<List<Map<String, dynamic>>> selectAllLens() async {
  //     Database db = await initDatabase();
  //     return await db.rawQuery("SELECT * FROM LENS");
  //   }
  // }