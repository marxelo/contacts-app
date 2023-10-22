import 'package:contacts_app/database_helper.dart';
import 'package:contacts_app/update_contact.dart';
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

  List<Map<String, dynamic>> dataList = [];

  void _saveData() async {
    final name = _nameController.text;
    final phone = _phoneController.text;
    final email = _emailController.text;
    final photo = _photoController.text;

    int insertId =
        await DatabaseHelper.insertContact(name, phone, email, photo);

    final List<Map<String, dynamic>> updatedData =
        await DatabaseHelper.getData();

    setState(() {
      dataList = updatedData;
    });

    _nameController.text = '';
    _phoneController.text = '';
    _emailController.text = '';
    _photoController.text = '';
  }

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  void _fetchContacts() async {
    final List<Map<String, dynamic>> contactList =
        await DatabaseHelper.getData();

    setState(() {
      dataList = contactList;
    });
  }

  void _delete(int id) async {
    int dId = await DatabaseHelper.deleteData(id);

    final List<Map<String, dynamic>> updatedData =
        await DatabaseHelper.getData();

    setState(() {
      dataList = updatedData;
    });
  }

  void fetchData() async {
    final List<Map<String, dynamic>> updatedData =
        await DatabaseHelper.getData();

    setState(() {
      dataList = updatedData;
    });
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
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
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
                      onPressed: _saveData,
                      child: const Text('Salvar Contato')),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(dataList[index]['name']),
                      subtitle: Text(dataList[index]['phone'] +
                          '\n' +
                          dataList[index]['email']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateContact(
                                      contactId: dataList[index]['id']),
                                ),
                              ).then((result) {
                                if (result == true) {
                                  fetchData();
                                }
                              });
                            },
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Colors.green,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _delete(dataList[index]['id']);
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
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
