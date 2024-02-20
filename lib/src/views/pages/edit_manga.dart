import 'package:flutter/material.dart';
import 'package:mangas/src/daos/manga_dao.dart';
import 'package:mangas/src/models/manga.dart';

class EditMangaPage extends StatefulWidget {
  static const routeName = '/manga/edit';
  final Manga manga;

  const EditMangaPage({super.key, required this.manga});
  @override
  State<EditMangaPage> createState() {
    return EditMangaPageState();
  }
}

class EditMangaPageState extends State<EditMangaPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleTxtController = TextEditingController();
  TextEditingController _coverTxtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleTxtController.dispose();
    _titleTxtController = TextEditingController.fromValue(
        TextEditingValue(text: widget.manga.title));
    _coverTxtController.dispose();
    _coverTxtController = TextEditingController.fromValue(
        TextEditingValue(text: widget.manga.firstVolumeCover));
  }

  @override
  void dispose() {
    _titleTxtController.dispose();
    _coverTxtController.dispose();
    super.dispose();
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      widget.manga.title = _titleTxtController.text;
      widget.manga.firstVolumeCover = _coverTxtController.text;
      await MangaDao().update(widget.manga);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar mangá'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Título'),
                controller: _titleTxtController,
                validator: _validator,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Status'),
                initialValue: widget.manga.status,
                readOnly: true,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Editora'),
                initialValue: widget.manga.publisher,
                readOnly: true,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Capa primeiro volume'),
                controller: _coverTxtController,
                validator: _validator,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Número de volumes'),
                initialValue: widget.manga.totalVolumes.toString(),
                readOnly: true,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                    onPressed: () => _saveChanges(),
                    child: const Text('Salvar')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
