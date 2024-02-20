import 'package:flutter/material.dart';
import 'package:mangas/src/daos/collection_dao.dart';
import 'package:mangas/src/models/collection.dart';

class EditCollectionPage extends StatefulWidget {
  static const routeName = '/collection/edit';
  final Collection collection;

  const EditCollectionPage({super.key, required this.collection});
  @override
  State<EditCollectionPage> createState() {
    return EditCollectionPageState();
  }
}

class EditCollectionPageState extends State<EditCollectionPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _statusTxtController = TextEditingController();
  TextEditingController _coverTxtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _statusTxtController.dispose();
    _statusTxtController = TextEditingController.fromValue(
        TextEditingValue(text: widget.collection.status));

    _coverTxtController.dispose();
    _coverTxtController = TextEditingController.fromValue(
        TextEditingValue(text: widget.collection.firstVolumeCover));
  }

  @override
  void dispose() {
    _statusTxtController.dispose();
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
      widget.collection.status = _statusTxtController.text;
      widget.collection.firstVolumeCover = _coverTxtController.text;
      await CollectionDao().update(widget.collection);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar coleção'),
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
                initialValue: widget.collection.mangaTitle,
                readOnly: true,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Status'),
                controller: _statusTxtController,
                validator: _validator,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Capa'),
                controller: _coverTxtController,
                validator: _validator,
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
