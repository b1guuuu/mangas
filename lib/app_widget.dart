import 'package:flutter/material.dart';
import 'package:mangas/src/controllers/global_state_controller.dart';
import 'package:mangas/src/models/collection.dart';
import 'package:mangas/src/models/manga.dart';
import 'package:mangas/src/views/pages/collection.dart';
import 'package:mangas/src/views/pages/collection_volumes.dart';
import 'package:mangas/src/views/pages/edit_collection.dart';
import 'package:mangas/src/views/pages/edit_manga.dart';
import 'package:mangas/src/views/pages/mangas.dart';
import 'package:mangas/src/views/pages/missing_collection_volumes.dart';
import 'package:mangas/src/views/pages/settings.dart';
import 'package:mangas/src/views/pages/volumes.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: GlobalStateController.instace,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark(),
            initialRoute: CollectionPage.routeName,
            onGenerateRoute: (settings) {
              if (settings.name == VolumesPage.routeName) {
                final manga = settings.arguments as Manga;

                return MaterialPageRoute(builder: (context) {
                  return VolumesPage(manga: manga);
                });
              }

              if (settings.name == MangasPage.routeName) {
                return MaterialPageRoute(builder: (context) {
                  return const MangasPage();
                });
              }

              if (settings.name == SettingsPage.routeName) {
                return MaterialPageRoute(builder: (context) {
                  return const SettingsPage();
                });
              }

              if (settings.name == CollectionPage.routeName) {
                return MaterialPageRoute(builder: (context) {
                  return const CollectionPage();
                });
              }

              if (settings.name == CollectionVolumesPage.routeName) {
                final collection = settings.arguments as Collection;
                return MaterialPageRoute(builder: (context) {
                  return CollectionVolumesPage(collection: collection);
                });
              }

              if (settings.name == MissingCollectionVolumesPage.routeName) {
                return MaterialPageRoute(builder: (context) {
                  return const MissingCollectionVolumesPage();
                });
              }

              if (settings.name == EditMangaPage.routeName) {
                final manga = settings.arguments as Manga;

                return MaterialPageRoute(builder: (context) {
                  return EditMangaPage(manga: manga);
                });
              }

              if (settings.name == EditCollectionPage.routeName) {
                final collection = settings.arguments as Collection;

                return MaterialPageRoute(builder: (context) {
                  return EditCollectionPage(collection: collection);
                });
              }

              assert(false, 'Need to implement ${settings.name}');
              return null;
            },
          );
        });
  }
}
