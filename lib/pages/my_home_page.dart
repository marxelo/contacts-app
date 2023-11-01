import 'package:animations/animations.dart';
import 'package:contacts_app/utils/database_helper.dart';
import 'package:contacts_app/pages/form_page.dart';
import 'package:contacts_app/utils/constants.dart';
import 'package:contacts_app/utils/fake_data.dart';
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
  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;
  List<Map<String, dynamic>> dataList = [];
  late SwipeActionController controller;
  late Map<String, dynamic> detailedContact;

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
                duration: const Duration(
                  milliseconds: kAnimationMillisecondsDuration,
                ),
                curve: Curves.ease,
                child: const Icon(
                  Icons.person,
                  size: 250,
                  color: Colors.black12,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: dataList.isNotEmpty ? 30 : 420,
              child: Center(
                child:
                    dataList.isNotEmpty ? const Text('') : _noContacts(context),
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
      floatingActionButton: OpenContainer(
        transitionType: _transitionType,
        transitionDuration: const Duration(
          milliseconds: kAnimationMillisecondsDuration,
        ),
        openBuilder: (BuildContext context, VoidCallback _) {
          return const FormPage(
            title: 'Adicionar Contato',
          );
        },
        closedElevation: 6.0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        onClosed: (result) {
          if (result == true) {
            fetchData();
          }
        },
        closedColor: Theme.of(context).colorScheme.primaryContainer,
        tappable: true,
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return SizedBox(
            height: kFabDimension,
            width: kFabDimension,
            child: Center(
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          );
        },
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
          content: const Row(
            children: [
              Icon(
                Icons.edit_outlined,
                color: Colors.white,
              ),
              Text(
                'Editar',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
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
            ).then(
              (result) {
                if (result == true) {
                  fetchData();
                }
              },
            );
          },
        ),
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
      child: OpenContainer<Map<String, dynamic>>(
        transitionType: _transitionType,
        transitionDuration: const Duration(
          milliseconds: kAnimationMillisecondsDuration,
        ),
        openBuilder: (BuildContext _, VoidCallback openContainer) {
          detailedContact = dataList[index];
          return ContactDetailsPage(
            contactParam: dataList[index],
          );
        },
        onClosed: (data) {
          fetchData();
          if (data != null) {
            detailedContact = data;
            _showSnackBar(context, detailedContact);
          }
        },
        closedBuilder: (BuildContext _, VoidCallback openContainer) {
          return ListTile(
            leading: CircleAvatarWidget(
              contact: dataList[index],
            ),
            title: Text(dataList[index]['name']),
            subtitle: Text(dataList[index]['phone']),
          );
        },
      ),
    );
  }

  Widget _noContacts(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sem contatos cadastrados',
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(height: 25),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Instruções',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                            text: '- Cadastrar: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: 'toque no botão + no canto inferior'),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                            text: '- Editar: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'deslize o contato da esquerda para direita'),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                            text: '- Excluir: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'deslize o contato da direita para esquerda'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Container(
              height: 120,
              width: 360,
              decoration: const BoxDecoration(
                color: Color.fromARGB(76, 199, 198, 198),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Conheça o potencial do app rapidamente'),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await FakeData.generateFakedata();
                        // print('after $res');
                        fetchData();
                      },
                      icon: const Icon(Icons.people),
                      label: const Text('Cadastrar Contactos Fictícios'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
