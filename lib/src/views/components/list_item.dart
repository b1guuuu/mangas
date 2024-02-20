import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final String cover;
  final String title;
  final void Function()? onTap;

  const ListItem(
    {super.key, required this.cover, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl: cover,
          placeholder: (context, url) => const CircularProgressIndicator(),
          ),
        title: Text(title),
        ),
      );
  }
}
