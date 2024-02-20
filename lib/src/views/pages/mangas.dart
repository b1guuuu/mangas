import 'package:flutter/material.dart';
import 'package:mangas/src/daos/manga_dao.dart';
import 'package:mangas/src/models/manga.dart';
import 'package:mangas/src/views/components/mangas_grid.dart';

class MangasPage extends StatefulWidget {
  static const routeName = '/mangas';
  const MangasPage({super.key});

  @override
  State<MangasPage> createState() {
    return MangasPageState();
  }
}

class MangasPageState extends State<MangasPage> {
  List<Manga> _mangas = [];
  List<Manga> _displayMangas = [];
  Widget titleWidget = const Text('Mangás');
  IconButton actionButton =
      IconButton(onPressed: () => {}, icon: const Icon(Icons.search));

  @override
  void initState() {
    super.initState();
    _loadMangas();
    _resetAppBar();
  }

  void _loadMangas() async {
    MangaDao mangaDao = MangaDao();
    var temp = await mangaDao.getNotInCollection();
    setState(() {
      _mangas = temp;
      _displayMangas = temp;
    });
  }

  void _filterMangas(String filter) {
    setState(() {
      _displayMangas = _mangas
          .where((manga) =>
              manga.title.toUpperCase().contains(filter.toUpperCase()))
          .toList();
    });
  }

  void _resetAppBar() {
    setState(() {
      _displayMangas = _mangas;
      titleWidget = const Text('Mangás');
      actionButton = IconButton(
          onPressed: _enableSearchBar, icon: const Icon(Icons.search));
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
          onChanged: (value) => _filterMangas(value),
          onSubmitted: (value) => _filterMangas(value),
        ),
      );
      actionButton =
          IconButton(onPressed: _resetAppBar, icon: const Icon(Icons.cancel));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleWidget,
        actions: [actionButton],
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: MangasGrid(
            mangas: _displayMangas,
            updateMangasList: _loadMangas,
          )),
    );
  }
}
