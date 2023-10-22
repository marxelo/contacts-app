import 'package:contacts_app/database_helper.dart';
import 'package:contacts_app/form_page.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> dataList = [];

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
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
                                  builder: (context) => FormPage(
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormPage(contactId: null),
            ),
          ).then((result) {
            if (result == true) {
              fetchData();
            }
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }
}
