import 'package:contacts_app/database_helper.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _photoController = TextEditingController();

  void _saveData() async {
    final name = _nameController.text;
    final phone = _phoneController.text;
    final email = _emailController.text;
    final photo = _photoController.text;

    int insertId =
        await DatabaseHelper.insertContact(name, phone, email, photo);
    print(insertId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _photoController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
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
                onPressed: _saveData, child: const Text('Salvar Contato')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
