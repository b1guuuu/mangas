import 'dart:io' as io;
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';

Future<Database> openDatabase() async {
  var databaseFactory = databaseFactoryFfi;
  final io.Directory appDocumentsDir = await getApplicationDocumentsDirectory();

  //Create path for database
  String dbPath =
      p.join(appDocumentsDir.path, "databases", "mangas-collection.db");
  var db = await databaseFactory.openDatabase(
    dbPath,
  );
  return db;
}

Future<void> closeDatabase(Database db) async {
  await db.close();
}
