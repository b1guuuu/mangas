import 'package:flutter/material.dart';
import 'package:mangas/src/daos/volume_dao.dart';
import 'package:mangas/src/models/collection.dart';
import 'package:mangas/src/views/components/collection_volumes_grid.dart';

class CollectionVolumesPage extends StatefulWidget {
  static const routeName = '/collection/volumes';
  final Collection collection;

  const CollectionVolumesPage({super.key, required this.collection});

  @override
  State<CollectionVolumesPage> createState() {
    return CollectionVolumesPageState();
  }
}

class CollectionVolumesPageState extends State<CollectionVolumesPage> {
  List<Map<String, dynamic>> _displayDataList = [];

  @override
  void initState() {
    super.initState();
    _loadAllVolumes();
  }

  void _loadAllVolumes() async {
    VolumeDao volumeDao = VolumeDao();
    var result = await volumeDao.getFromCollection(widget.collection.mangaId);
    setState(() {
      _displayDataList = result.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Volumes ${widget.collection.mangaTitle}'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: CollectionVolumesGrid(
              collection: widget.collection,
              volumes: _displayDataList,
              update: _loadAllVolumes),
        ));
  }
}
