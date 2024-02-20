import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GridItem extends StatelessWidget {
  final String cover;
  final String title;
  final dynamic Function()? onTap;
  final dynamic Function()? onLongPress;

  const GridItem(
      {super.key,
      required this.cover,
      required this.title,
      this.onTap,
      this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap!(),
      onLongPress: () => onLongPress!(),
      child: Column(
        children: [
          SizedBox(
            height: 220,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
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
  }
}
