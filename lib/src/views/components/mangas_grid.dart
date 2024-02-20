import 'package:flutter/material.dart';
import 'package:mangas/src/daos/collection_dao.dart';
import 'package:mangas/src/daos/collection_volume_dao.dart';
import 'package:mangas/src/daos/volume_dao.dart';
import 'package:mangas/src/models/collection.dart';
import 'package:mangas/src/models/collection_volume.dart';
import 'package:mangas/src/models/manga.dart';
import 'package:mangas/src/models/volume.dart';
import 'package:mangas/src/views/components/grid_item.dart';
import 'package:mangas/src/views/pages/volumes.dart';

class MangasGrid extends StatelessWidget {
  final List<Manga> mangas;
  final void Function() updateMangasList;

  const MangasGrid(
      {super.key, required this.mangas, required this.updateMangasList});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: mangas.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
          mainAxisExtent: 300,
          mainAxisSpacing: 5),
      itemBuilder: (context, index) {
        return GridItem(
          cover: mangas[index].firstVolumeCover,
          title: mangas[index].title,
          onTap: () {
            Navigator.of(context)
                .pushNamed(VolumesPage.routeName, arguments: mangas[index]);
          },
          onLongPress: () => _dialogBuilder(context, mangas[index])
              .then((value) => updateMangasList()),
        );
      },
    );
  }

  Future<void> _dialogBuilder(BuildContext context, Manga manga) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(manga.title),
          content: const Text(
            'O que deseja fazer com esse título?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Adicionar todos os volumes'),
              onPressed: () async {
                CollectionDao collectionDao = CollectionDao();
                Collection collection = Collection.base(
                    status: 'Completa',
                    mangaId: manga.id,
                    mangaTitle: manga.title,
                    firstVolumeCover: manga.firstVolumeCover);
                collection = await collectionDao.insert(collection);

                VolumeDao volumeDao = VolumeDao();
                List<Volume> volumes =
                    await volumeDao.getAllFromManga(collection.mangaId);

                List<CollectionVolume> collectionVolumes = [];
                for (var volume in volumes) {
                  collectionVolumes.add(CollectionVolume(
                      collectionId: collection.id,
                      volumeId: volume.id,
                      addedDate: DateTime.now().toString().substring(0, 10)));
                }

                CollectionVolumeDao collectionVolumeDao = CollectionVolumeDao();
                await collectionVolumeDao.bulkInsert(collectionVolumes);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Adicionar sem volumes'),
              onPressed: () async {
                CollectionDao collectionDao = CollectionDao();
                Collection collection = Collection.base(
                    status: 'Interesse',
                    mangaId: manga.id,
                    mangaTitle: manga.title,
                    firstVolumeCover: manga.firstVolumeCover);
                collection = await collectionDao.insert(collection);

                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge),
              child: const Text('Voltar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
