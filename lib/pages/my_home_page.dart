import 'package:contacts_app/utils/database_helper.dart';
import 'package:contacts_app/pages/form_page.dart';
import 'package:contacts_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:contacts_app/pages/contact_details_page.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:contacts_app/components/circle_avatar_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> dataList = [];
  late SwipeActionController controller;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    controller = SwipeActionController(selectedIndexPathsChangeCallback:
        (changedIndexPaths, selected, currentCount) {
      setState(() {});
    });
  }

  void _fetchContacts() async {
    final List<Map<String, dynamic>> contactList =
        await DatabaseHelper.getData();

    setState(() {
      dataList = contactList;
    });
  }

  void _delete(Map<String, dynamic> contact) async {
    await DatabaseHelper.deleteData(contact['id']);

    final List<Map<String, dynamic>> updatedData =
        await DatabaseHelper.getData();

    setState(() {
      dataList = updatedData;
    });
  }

  void _undoDelete(Map<String, dynamic> contact) async {
    final name = contact['name'];
    final phone = contact['phone'];
    final email = contact['email'];
    final business = contact['business'];
    final photo = contact['photo'];

    await DatabaseHelper.insertContact(name, phone, email, business, photo);

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

  Future<void> _showSnackBar(
      BuildContext context, Map<String, dynamic> deletedContact) async {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Contato removido!'),
          action: SnackBarAction(
            label: 'Desfazer',
            onPressed: () {
              _undoDelete(deletedContact);
            },
          ),
        ),
      );
  }

  Future<void> _navigateAndDisplayContactDetails(
      BuildContext context, Map<String, dynamic> contact) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactDetailsPage(
          contactParam: contact,
        ),
      ),
    ).then((result) {
      fetchData();
      _showSnackBar(context, contact);
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
                return _item(context, index);
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

  Widget _item(BuildContext context, int index) {
    return SwipeActionCell(
      controller: controller,
      fullSwipeFactor: kfullSwipeFactor,
      index: index,
      key: ValueKey(dataList[index]),
      leadingActions: [
        SwipeAction(
            content: const Row(children: [
              Icon(
                Icons.edit_outlined,
                color: Colors.white,
              ),
              Text(
                'Editar',
                style: TextStyle(color: Colors.white),
              ),
            ]),
            performsFirstActionWithFullSwipe: true,
            forceAlignmentToBoundary: true,
            color: const Color(0xFF7BC043),
            onTap: (handler) async {
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
            }),
      ],
      trailingActions: [
        SwipeAction(
          content: const Row(children: [
            SizedBox(
              width: 12,
            ),
            Icon(
              Icons.delete_outline,
              color: Colors.white,
            ),
            Text(
              'Excluir',
              style: TextStyle(color: Colors.white),
            ),
          ]),
          performsFirstActionWithFullSwipe: true,
          forceAlignmentToBoundary: true,
          color: const Color(0xFFFE4A49),
          onTap: (handler) async {
            var deletedContact = dataList[index];
            _delete(dataList[index]);
            setState(() {});
            _showSnackBar(context, deletedContact);
          },
        ),
      ],
      child: GestureDetector(
        onTap: () {
          _navigateAndDisplayContactDetails(context, dataList[index]);
        },
        child: ListTile(
          leading: CircleAvatarWidget(
            contact: dataList[index],
          ),
          title: Text(dataList[index]['name']),
          subtitle: Text(dataList[index]['phone']),
        ),
      ),
    );
  }
}
