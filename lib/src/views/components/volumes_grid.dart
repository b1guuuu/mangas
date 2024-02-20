import 'package:flutter/material.dart';
import 'package:mangas/src/models/volume.dart';
import 'package:mangas/src/views/components/grid_item.dart';

class VolumesGrid extends StatelessWidget {
  final List<Volume> volumes;

  const VolumesGrid({super.key, required this.volumes});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: volumes.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
            mainAxisExtent: 300,
            mainAxisSpacing: 5),
        itemBuilder: (context, index) {
          return GridItem(
            cover: volumes[index].cover,
            title: '${volumes[index].volumeNumber} (${volumes[index].release})',
          );
        });
  }
}
