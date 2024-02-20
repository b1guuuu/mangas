import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import './utils_database.dart' as utils_database;

Future init() async {
  var db = await utils_database.openDatabase();
  Batch batch = db.batch();
  _createMangastable(batch);
  _createVolumestable(batch);
  _createCollectionstable(batch);
  _createCollectionVolumestable(batch);
  await batch.commit(noResult: true);
  await utils_database.closeDatabase(db);
}

void _createMangastable(Batch batch) async {
  const createTableCommand = '''
  CREATE TABLE IF NOT EXISTS Manga (
    id INTEGER PRIMARY KEY,
    title TEXT,
    status TEXT,
    publisher TEXT,
    firstVolumeCover TEXT,
    totalVolumes INTEGER
  )
  ''';
  batch.execute(createTableCommand);
}

void _createVolumestable(Batch batch) async {
  const createTableCommand = '''
  CREATE TABLE IF NOT EXISTS Volume (
    id INTEGER PRIMARY KEY,
    volumeNumber INTEGER,
    release TEXT,
    price REAL,
    cover TEXT,
    mangaId INTEGER,
    FOREIGN KEY(mangaId) REFERENCES Manga(id)
  )
  ''';
  batch.execute(createTableCommand);
}

void _createCollectionstable(Batch batch) async {
  const createTableCommand = '''
  CREATE TABLE IF NOT EXISTS Collection (
    id INTEGER PRIMARY KEY,
    status TEXT,
    mangaId INTEGER,
    mangaTitle TEXT,
    firstVolumeCover TEXT,
    FOREIGN KEY(mangaId) REFERENCES Manga(id)
  )
  ''';
  batch.execute(createTableCommand);
}

void _createCollectionVolumestable(Batch batch) async {
  const createTableCommand = '''
  CREATE TABLE IF NOT EXISTS CollectionVolume (
    collectionId INTEGER,
    volumeId INTEGER,
    addedDate TEXT,
    PRIMARY KEY(collectionId, volumeId),
    FOREIGN KEY(collectionId) REFERENCES Collection(id),
    FOREIGN KEY(volumeId) REFERENCES Volume(id)
  )
  ''';
  batch.execute(createTableCommand);
}
