import 'package:contacts_app/database_helper.dart';
import 'package:contacts_app/form_page.dart';
import 'package:flutter/material.dart';
import 'package:contacts_app/contact_details.dart';

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
    await DatabaseHelper.deleteData(id);

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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 200.0,
            shadowColor: Colors.black38,
            surfaceTintColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 10),
              title: const Text(
                'Contatos',
                style: TextStyle(color: Colors.black87),
              ),
              expandedTitleScale: 2.0,
              background: AnimatedContainer(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.only(top: 28),
                width: 250,
                height: 250,
                duration: const Duration(milliseconds: 800),
                curve: Curves.ease,
                child: const Icon(
                  Icons.person,
                  size: 250,
                  color: Colors.black12,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 30,
              child: Center(
                child: Text(''),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return GestureDetector(
                  onDoubleTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactDetails(
                          contactParam: dataList[index],
                        ),
                      ),
                    ).then((result) {
                      fetchData();
                    });
                  },
                  child: ListTile(
                    title: Text(dataList[index]['name']),
                    subtitle: Text(dataList[index]['phone']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FormPage(
                                  contact: dataList[index],
                                  title: 'Editar Contato',
                                ),
                              ),
                            ).then((result) {
                              if (result == true) {
                                fetchData();
                              }
                            });
                          },
                          icon: const Icon(
                            Icons.mode_edit_outline_outlined,
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
                  ),
                );
              },
              childCount: dataList.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormPage(
                contact: null,
                title: 'Adicionar Contato',
              ),
            ),
          ).then((result) {
            if (result == true) {
              fetchData();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
