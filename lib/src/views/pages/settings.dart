import 'dart:convert';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mangas/src/daos/collection_dao.dart';
import 'package:mangas/src/daos/collection_volume_dao.dart';
import 'package:mangas/src/daos/manga_dao.dart';
import 'package:mangas/src/daos/volume_dao.dart';
import 'package:mangas/src/models/collection.dart';
import 'package:mangas/src/models/collection_volume.dart';
import 'package:mangas/src/models/manga.dart';
import 'package:mangas/src/models/volume.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = '/settings';
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  late double restoreDatabaseProgress = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                _restoreDatabase();
              },
              child: const Text('Iniciar banco de dados (db.json)'),
            ),
            MaterialButton(
              onPressed: () {
                _updateDatabase();
              },
              child: const Text('Atualizar banco de dados (update.json)'),
            ),
            MaterialButton(
              onPressed: () {
                _exportCollection();
              },
              child: const Text('Exportar coleção (collection.json)'),
            ),
            LinearProgressIndicator(
              value: restoreDatabaseProgress,
            )
          ],
        ),
      ),
    );
  }

  Future<String?> _pickFile() async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return '';
    return result.files.first.path;
  }

  void _restoreDatabase() async {
    final String? dbPath = await _pickFile();
    final File dbFile = File(dbPath!);
    final rawData = jsonDecode(dbFile.readAsStringSync());

    final MangaDao mangaDao = MangaDao();
    final VolumeDao volumeDao = VolumeDao();

    num index = 1;
    for (var rawManga in rawData) {
      Manga manga = Manga.base(
          title: rawManga['title'],
          status: rawManga['status'],
          publisher: rawManga['publisher'],
          firstVolumeCover: rawManga['volumes'][0]['cover'],
          totalVolumes: rawManga['volumes'].length);
      manga = await mangaDao.insert(manga);
      List<Volume> volumes = [];
      for (var volume in rawManga['volumes']) {
        if (volume['price'] == null) {
          volume['price'] = 0;
        }
        if (volume['price'].runtimeType.toString() == 'int') {
          volume['price'] = volume['price'].toDouble();
        }
        volumes.add(Volume.base(
            volumeNumber: volume['volumeNumber'],
            release: volume['release'],
            price: volume['price'],
            cover: volume['cover'],
            mangaId: manga.id));
      }
      await volumeDao.bulkInsert(volumes);
      setState(() {
        restoreDatabaseProgress = index / rawData.length;
      });
      index++;
    }
  }

  void _updateDatabase() async {
    final String? updatePath = await _pickFile();
    final File updateFile = File(updatePath!);
    final rawData = jsonDecode(updateFile.readAsStringSync());

    MangaDao mangaDao = MangaDao();
    VolumeDao volumeDao = VolumeDao();

    num index = 1;
    for (var rawManga in rawData['insert']) {
      Manga manga = Manga.base(
          title: rawManga['title'],
          status: rawManga['status'],
          publisher: rawManga['publisher'],
          firstVolumeCover: rawManga['volumes'][0]['cover'],
          totalVolumes: rawManga['volumes'].length);
      manga = await mangaDao.insert(manga);

      List<Volume> volumes = [];
      for (var volume in rawManga['volumes']) {
        if (volume['price'] == null) {
          volume['price'] = 0;
        }
        if (volume['price'].runtimeType.toString() == 'int') {
          volume['price'] = volume['price'].toDouble();
        }
        volumes.add(Volume.base(
            volumeNumber: volume['volumeNumber'],
            release: volume['release'],
            price: volume['price'],
            cover: volume['cover'],
            mangaId: manga.id));
      }
      await volumeDao.bulkInsert(volumes);
      setState(() {
        restoreDatabaseProgress =
            index / (rawData['insert'].length + rawData['update'].length);
      });
      index++;
    }

    for (var rawManga in rawData['update']) {
      Manga dbManga = await mangaDao.getByTitleAndPublisher(
          rawManga['title'], rawManga['publisher']);

      Manga updatedManga = Manga(
          id: dbManga.id,
          title: rawManga['title'],
          status: rawManga['status'],
          publisher: rawManga['publisher'],
          firstVolumeCover: rawManga['volumes'][0]['cover'],
          totalVolumes: rawManga['volumes'].length);
      if (dbManga.isDifferent(updatedManga)) {
        await mangaDao.update(updatedManga);
      }

      if (updatedManga.totalVolumes > dbManga.totalVolumes) {
        List<Volume> volumes = [];
        for (var volume in rawManga['volumes']) {
          if (volume['volumeNumber'] > dbManga.totalVolumes) {
            if (volume['price'] == null) {
              volume['price'] = 0;
            }
            if (volume['price'].runtimeType.toString() == 'int') {
              volume['price'] = volume['price'].toDouble();
            }
            volumes.add(Volume.base(
                volumeNumber: volume['volumeNumber'],
                release: volume['release'],
                price: volume['price'],
                cover: volume['cover'],
                mangaId: updatedManga.id));
          }
        }
        await volumeDao.bulkInsert(volumes);
      }
      setState(() {
        restoreDatabaseProgress =
            index / (rawData['insert'].length + rawData['update'].length);
      });
      index++;
    }
  }

  void _exportCollection() async {
    var collectionData = [];
    List<Collection> collections = await CollectionDao().getAll();
    setState(() {
      restoreDatabaseProgress = 1 / 5;
    });
    for (var collection in collections) {
      List<CollectionVolume> collectionVolumes =
          await CollectionVolumeDao().getInCollection(collection.id);
      collectionData.add({
        'collection': collection.toMap(),
        'collectionVolumes': collectionVolumes.map((e) => e.toMap()).toList()
      });
    }
    setState(() {
      restoreDatabaseProgress = 2 / 5;
    });

    var baseData = [];
    List<Manga> mangas = await MangaDao().getInCollection();
    setState(() {
      restoreDatabaseProgress = 3 / 5;
    });
    for (var manga in mangas) {
      List<Volume> volumes = await VolumeDao().getAllFromManga(manga.id);
      baseData.add({
        'manga': manga.toMap(),
        'volumes': volumes.map((e) => e.toMap()).toList()
      });
    }
    setState(() {
      restoreDatabaseProgress = 4 / 5;
    });

    var outputData = {'collectionData': collectionData, 'baseData': baseData};
    final downloadsDirectory = await getDownloadsDirectory();
    final outputFile = File('${downloadsDirectory?.path}/collection.json');
    await outputFile.writeAsString(jsonEncode(outputData), flush: true);
    setState(() {
      restoreDatabaseProgress = 5 / 5;
    });
    OpenFile.open(outputFile.path);
  }
}
