import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mangas/src/daos/collection_volume_dao.dart';
import 'package:mangas/src/models/collection.dart';
import 'package:mangas/src/models/collection_volume.dart';

class CollectionVolumesGrid extends StatelessWidget {
  final Collection collection;
  final List<Map<String, dynamic>> volumes;
  final Function() update;

  const CollectionVolumesGrid(
      {super.key,
      required this.collection,
      required this.volumes,
      required this.update});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: volumes.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
          mainAxisExtent: 300,
          mainAxisSpacing: 5),
      itemBuilder: (context, index) {
        var title;
        var onTap;
        if (volumes[index]['addedDate'] == null) {
          title = 'Pendente';
          onTap = _addVolume;
        } else {
          title = 'Adicionado em ${volumes[index]['addedDate']}';
          onTap = _deleteVolume;
        }
        return GestureDetector(
          onTap: () => onTap(volumes[index]),
          child: Column(
            children: [
              SizedBox(
                height: 220,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: volumes[index]['cover'],
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  void _addVolume(Map<String, dynamic> mapVolume) async {
    CollectionVolumeDao collectionVolumeDao = CollectionVolumeDao();
    CollectionVolume collectionVolume = CollectionVolume(
        collectionId: collection.id,
        volumeId: mapVolume['id'],
        addedDate: DateTime.now().toString().substring(0, 10));
    await collectionVolumeDao.insert(collectionVolume);
    update();
  }

  void _deleteVolume(Map<String, dynamic> mapVolume) async {
    CollectionVolumeDao collectionVolumeDao = CollectionVolumeDao();
    CollectionVolume collectionVolume = CollectionVolume(
        collectionId: collection.id,
        volumeId: mapVolume['id'],
        addedDate: mapVolume['addedDate']);
    await collectionVolumeDao.delete(collectionVolume);
    update();
  }
}
