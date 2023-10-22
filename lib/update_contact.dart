import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class UpdateContact extends StatefulWidget {
  const UpdateContact({Key? key, required this.contactId}) : super(key: key);
  final int contactId;

  @override
  State<UpdateContact> createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateContact> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _photoController = TextEditingController();

  void fetchData() async {
    Map<String, dynamic>? data =
        await DatabaseHelper.getSingleData(widget.contactId);

    if (data != null) {
      _nameController.text = data['name'];
      _phoneController.text = data['phone'];
      _emailController.text = data['email'];
      _photoController.text = data['photo'];
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void _updateData(BuildContext context) async {
    Map<String, dynamic> data = {
      'name': _nameController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'photo': _photoController.text,
    };

    int id = await DatabaseHelper.updateData(widget.contactId, data);
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _photoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Contato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'nome'),
            ),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(hintText: 'Telefone'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(hintText: 'e-mail'),
            ),
            TextFormField(
              controller: _photoController,
              decoration: const InputDecoration(hintText: 'photo'),
            ),
            ElevatedButton(
                onPressed: () {
                  _updateData(context);
                },
                child: const Text('Atualizar Contato')),
          ],
        ),
      ),
    );
  }
}
