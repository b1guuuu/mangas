import 'package:mangas/src/daos/collection_volume_dao.dart';
import 'package:mangas/src/models/collection.dart';

import '../database/utils_database.dart' as utils_database;

class CollectionDao {
  static const String tableName = 'Collection';

  Future<Collection> insert(Collection collection) async {
    var db = await utils_database.openDatabase();
    await db.insert(tableName, collection.toMapWithoutId());
    var result = await db.query(tableName,
        where: 'mangaId = ?', whereArgs: [collection.mangaId], limit: 1);
    await utils_database.closeDatabase(db);
    return Collection.fromMap(result.first);
  }

  Future delete(Collection collection) async {
    var db = await utils_database.openDatabase();
    await db.delete(CollectionVolumeDao.tableName,
        where: 'collectionId = ?', whereArgs: [collection.id]);
    await db.delete(tableName, where: 'id = ?', whereArgs: [collection.id]);
    await utils_database.closeDatabase(db);
  }

  Future<List<Collection>> getAll() async {
    var db = await utils_database.openDatabase();
    var result = await db.query(tableName, orderBy: 'mangaTitle');
    await utils_database.closeDatabase(db);
    List<Collection> collections = [];
    for (var collection in result) {
      collections.add(Collection.fromMap(collection));
    }
    return collections;
  }

  Future<void> update(Collection collection) async {
    var db = await utils_database.openDatabase();
    await db.update(tableName, collection.toMapWithoutId(),
        where: 'id = ?', whereArgs: [collection.id]);
    await utils_database.closeDatabase(db);
  }
}
