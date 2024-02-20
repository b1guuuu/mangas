import 'package:mangas/src/daos/collection_volume_dao.dart';
import 'package:mangas/src/models/volume.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../database/utils_database.dart' as utils_database;

class VolumeDao {
  static const String tableName = 'Volume';

  Future bulkInsert(List<Volume> volumes) async {
    var db = await utils_database.openDatabase();
    Batch batch = db.batch();
    for (var volume in volumes) {
      batch.insert(tableName, volume.toMapWithoutId());
    }
    await batch.commit(noResult: true);
    await utils_database.closeDatabase(db);
  }

  Future insert(Volume volume) async {
    var db = await utils_database.openDatabase();
    await db.insert(tableName, volume.toMapWithoutId());
    await utils_database.closeDatabase(db);
  }

  Future<List<Volume>> getAllFromManga(num mangaId) async {
    var db = await utils_database.openDatabase();
    var result = await db.query(tableName,
        where: 'mangaId = ?', whereArgs: [mangaId], orderBy: 'volumeNumber');
    await utils_database.closeDatabase(db);
    List<Volume> volumes = [];
    for (var rawVolume in result) {
      volumes.add(Volume.fromMap(rawVolume));
    }
    return volumes;
  }

  Future<List<Map<String, dynamic>>> getFromCollection(num mangaId) async {
    var db = await utils_database.openDatabase();
    var query = '''
      SELECT V.*, C.addedDate FROM $tableName AS V
      LEFT JOIN ${CollectionVolumeDao.tableName} AS C
      ON V.id = C.volumeId
      WHERE V.mangaId = ?
      ORDER BY V.volumeNumber
    ''';
    var result = await db.rawQuery(query, [mangaId]);
    await utils_database.closeDatabase(db);
    return result;
  }
}
