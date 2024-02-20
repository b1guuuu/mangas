import 'package:flutter/material.dart';
import 'package:mangas/src/daos/collection_dao.dart';
import 'package:mangas/src/models/collection.dart';
import 'package:mangas/src/views/components/grid_item.dart';
import 'package:mangas/src/views/pages/collection_volumes.dart';

class CollectionsGrid extends StatelessWidget {
  final List<Collection> collections;
  final void Function() updateCollectionsList;

  const CollectionsGrid(
      {super.key,
      required this.collections,
      required this.updateCollectionsList});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: collections.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
          mainAxisExtent: 300,
          mainAxisSpacing: 5),
      itemBuilder: (context, index) {
        return GridItem(
          cover: collections[index].firstVolumeCover,
          title:
              '${collections[index].mangaTitle} (${collections[index].status})',
          onTap: () {
            Navigator.of(context).pushNamed(CollectionVolumesPage.routeName,
                arguments: collections[index]);
          },
          onLongPress: () => _dialogBuilder(context, collections[index])
              .then((value) => updateCollectionsList()),
        );
      },
    );
  }

  Future<void> _dialogBuilder(BuildContext context, Collection collection) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(collection.mangaTitle),
          content: const Text(
            'O que deseja fazer com esse título?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Excluir'),
              onPressed: () async {
                CollectionDao collectionDao = CollectionDao();
                await collectionDao.delete(collection);
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
