import 'package:mangas/src/daos/collection_dao.dart';
import 'package:mangas/src/daos/volume_dao.dart';
import 'package:mangas/src/models/collection_volume.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../database/utils_database.dart' as utils_database;

class CollectionVolumeDao {
  static const String tableName = 'CollectionVolume';

  Future insert(CollectionVolume collectionVolume) async {
    var db = await utils_database.openDatabase();
    await db.insert(tableName, collectionVolume.toMap());
    await utils_database.closeDatabase(db);
  }

  Future delete(CollectionVolume collectionVolume) async {
    var db = await utils_database.openDatabase();
    await db.delete(tableName,
        where: 'collectionId = ? AND volumeId = ?',
        whereArgs: [collectionVolume.collectionId, collectionVolume.volumeId]);
    await utils_database.closeDatabase(db);
  }

  Future bulkInsert(List<CollectionVolume> collectionVolumes) async {
    var db = await utils_database.openDatabase();
    Batch batch = db.batch();
    for (var collectionVolume in collectionVolumes) {
      batch.insert(tableName, collectionVolume.toMap());
    }
    await batch.commit(noResult: true);
    await utils_database.closeDatabase(db);
  }

  Future<List<CollectionVolume>> getInCollection(num collectionId) async {
    var db = await utils_database.openDatabase();
    var result = await db
        .query(tableName, where: 'collectionId = ?', whereArgs: [collectionId]);
    await utils_database.closeDatabase(db);
    List<CollectionVolume> collectionVolumes = [];
    for (var rawVolume in result) {
      collectionVolumes.add(CollectionVolume.fromMap(rawVolume));
    }
    return collectionVolumes;
  }

  Future<List<Map<String, dynamic>>>
      getMissingVolumesFromAllCollections() async {
    var db = await utils_database.openDatabase();
    var query = '''
      SELECT  C.mangaTitle || ' Vol. ' || V.volumeNumber AS missingVolume
      FROM ${VolumeDao.tableName} AS V
      INNER JOIN ${CollectionDao.tableName} AS C ON V.mangaId = C.mangaId
      WHERE NOT EXISTS (
        SELECT * FROM $tableName AS CV
        WHERE CV.volumeId = V.id
      )
      ORDER BY C.mangaTitle
    ''';
    var result = await db.rawQuery(query);
    await utils_database.closeDatabase(db);
    return result;
  }
}
