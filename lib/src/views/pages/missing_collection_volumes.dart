import 'package:flutter/material.dart';
import 'package:mangas/src/daos/collection_volume_dao.dart';

class MissingCollectionVolumesPage extends StatefulWidget {
  static const routeName = '/collections/missing';
  const MissingCollectionVolumesPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MissingCollectionVolumesPageState();
  }
}

class MissingCollectionVolumesPageState
    extends State<MissingCollectionVolumesPage> {
  late var missingVolumes = [];

  @override
  void initState() {
    super.initState();
    _loadMissingVolumes();
  }

  void _loadMissingVolumes() async {
    var temp =
        await CollectionVolumeDao().getMissingVolumesFromAllCollections();
    setState(() {
      missingVolumes = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volumes pendentes'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: missingVolumes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(missingVolumes[index]['missingVolume']),
              );
            },
          )),
    );
  }
}
