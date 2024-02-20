import 'package:flutter/material.dart';
import 'package:mangas/src/daos/collection_dao.dart';
import 'package:mangas/src/models/collection.dart';
import 'package:mangas/src/views/components/collections_grid.dart';
import 'package:mangas/src/views/pages/mangas.dart';
import 'package:mangas/src/views/pages/missing_collection_volumes.dart';
import 'package:mangas/src/views/pages/settings.dart';
import '../../database//init_database.dart' as init_database;

class CollectionPage extends StatefulWidget {
  static const routeName = '/';
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() {
    return CollectionPageState();
  }
}

class CollectionPageState extends State<CollectionPage> {
  List<Collection> _collections = [];
  List<Collection> _displayCollections = [];
  Widget titleWidget = const Text('Coleção');
  List<Widget> appBarActions = [];
  @override
  void initState() {
    super.initState();
    _loadCollections();
  }

  void _loadCollections() async {
    _resetAppBar();
    await init_database.init();
    CollectionDao collectionDao = CollectionDao();
    var temp = await collectionDao.getAll();
    setState(() {
      _collections = temp;
      _displayCollections = temp;
    });
  }

  void _filterCollections(String filter) {
    setState(() {
      _displayCollections = _collections
          .where((collection) => collection.mangaTitle
              .toUpperCase()
              .contains(filter.toUpperCase()))
          .toList();
    });
  }

  void _resetAppBar() {
    setState(() {
      _displayCollections = _collections;
      titleWidget = const Text('Coleção');
      appBarActions = [
        IconButton(onPressed: _enableSearchBar, icon: const Icon(Icons.search)),
        IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(MissingCollectionVolumesPage.routeName);
            },
            icon: const Icon(Icons.radar)),
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(SettingsPage.routeName);
          },
          icon: const Icon(Icons.settings),
        ),
      ];
    });
  }

  void _enableSearchBar() {
    setState(() {
      titleWidget = ListTile(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Digite o título...',
            border: InputBorder.none,
          ),
          onChanged: (value) => _filterCollections(value),
          onSubmitted: (value) => _filterCollections(value),
        ),
      );
      appBarActions = [
        IconButton(onPressed: _resetAppBar, icon: const Icon(Icons.cancel))
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleWidget,
        actions: appBarActions,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: CollectionsGrid(
            collections: _displayCollections,
            updateCollectionsList: _loadCollections),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .pushNamed(MangasPage.routeName)
            .then((value) => _loadCollections()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
