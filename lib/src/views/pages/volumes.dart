import 'package:flutter/material.dart';
import 'package:mangas/src/daos/volume_dao.dart';
import 'package:mangas/src/models/manga.dart';
import 'package:mangas/src/models/volume.dart';
import 'package:mangas/src/views/components/volumes_grid.dart';

class VolumesPage extends StatefulWidget {
  static const routeName = '/volumes';
  final Manga manga;

  const VolumesPage({super.key, required this.manga});

  @override
  State<VolumesPage> createState() {
    return VolumesPageState();
  }
}

class VolumesPageState extends State<VolumesPage> {
  List<Volume> _volumes = [];

  @override
  void initState() {
    super.initState();
    _loadVolumes();
  }

  void _loadVolumes() async {
    VolumeDao volumeDao = VolumeDao();
    var result = await volumeDao.getAllFromManga(widget.manga.id);
    setState(() {
      _volumes = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Volumes ${widget.manga.title}'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: VolumesGrid(volumes: _volumes),
        ));
  }
}
