import 'package:mangas/src/daos/collection_dao.dart';
import 'package:mangas/src/models/manga.dart';
import '../database/utils_database.dart' as utils_database;

class MangaDao {
  static const String tableName = 'Manga';

  Future<Manga> insert(Manga manga) async {
    var db = await utils_database.openDatabase();
    await db.insert(tableName, manga.toMapWithoutId());
    var result = await db.query(tableName,
        where: 'title = ? AND publisher = ?',
        whereArgs: [manga.title, manga.publisher],
        limit: 1,
        orderBy: 'title');
    await utils_database.closeDatabase(db);
    return Manga.fromMap(result[0]);
  }

  Future<List<Manga>> getAll() async {
    var db = await utils_database.openDatabase();
    var result = await db.query(tableName, orderBy: 'title');
    await utils_database.closeDatabase(db);
    List<Manga> mangas = [];
    for (var manga in result) {
      mangas.add(Manga.fromMap(manga));
    }
    return mangas;
  }

  Future<List<Manga>> getNotInCollection() async {
    var db = await utils_database.openDatabase();
    var query = '''
      SELECT * FROM $tableName AS M
      WHERE NOT EXISTS (
        SELECT mangaId FROM ${CollectionDao.tableName} AS C
        WHERE M.id = C.mangaId
      )
      ORDER BY title
    ''';
    var result = await db.rawQuery(query);
    await utils_database.closeDatabase(db);
    List<Manga> mangas = [];
    for (var manga in result) {
      mangas.add(Manga.fromMap(manga));
    }
    return mangas;
  }

  Future<List<Manga>> getInCollection() async {
    var db = await utils_database.openDatabase();
    var query = '''
      SELECT * FROM $tableName AS M
      INNER JOIN ${CollectionDao.tableName} AS C ON C.mangaId = M.id
      ORDER BY M.title
    ''';
    var result = await db.rawQuery(query);
    await utils_database.closeDatabase(db);
    List<Manga> mangas = [];
    for (var manga in result) {
      mangas.add(Manga.fromMap(manga));
    }
    return mangas;
  }

  Future<Manga> getByTitleAndPublisher(String title, String publisher) async {
    var db = await utils_database.openDatabase();
    var result = await db.query(tableName,
        where: 'title = ? AND publisher = ?', whereArgs: [title, publisher]);
    await utils_database.closeDatabase(db);
    return Manga.fromMap(result.first);
  }

  Future<void> update(Manga manga) async {
    var db = await utils_database.openDatabase();
    await db.update(tableName, manga.toMapWithoutId(),
        where: 'id = ?', whereArgs: [manga.id]);
    await utils_database.closeDatabase(db);
  }
}
