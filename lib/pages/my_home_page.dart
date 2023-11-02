import 'package:animations/animations.dart';
import 'package:contacts_app/model/contact.dart';
import 'package:contacts_app/utils/database_helper.dart';
import 'package:contacts_app/pages/form_page.dart';
import 'package:contacts_app/utils/constants.dart';
import 'package:contacts_app/utils/fake_data.dart';
import 'package:flutter/material.dart';
import 'package:contacts_app/pages/contact_details_page.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:contacts_app/components/circle_avatar_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;
  List<Contact> contacts = [];

  late SwipeActionController controller;
  late Contact detailedContact;
  bool isLoading = false;

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
    isLoading = true;

    final List<Contact> kontactList = await DatabaseHelper.getContacts();
    isLoading = false;
    setState(() {
      contacts = kontactList;
    });
  }

  void _delete(Contact contact) async {
    await DatabaseHelper.deleteContact(contact.id!);

    final List<Contact> updatedData = await DatabaseHelper.getContacts();

    setState(() {
      contacts = updatedData;
    });
  }

  void _undoDelete(Contact contact) async {
    final name = contact.name;
    final phone = contact.phone;
    final email = contact.email;
    final business = contact.business;
    final photo = contact.photo;

    await DatabaseHelper.insertContact(Contact(
        name: name,
        phone: phone,
        email: email,
        business: business,
        photo: photo));

    final List<Contact> updatedData = await DatabaseHelper.getContacts();

    setState(() {
      contacts = updatedData;
    });
  }

  void fetchData() async {
    final List<Contact> updatedData = await DatabaseHelper.getContacts();

    setState(() {
      contacts = updatedData;
    });
  }

  Future<void> _showSnackBar(
      BuildContext context, Contact deletedContact) async {
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
              // centerTitle: true,
              titlePadding: const EdgeInsets.only(left: 10),
              title: const Text(
                'Contatos',
                style: TextStyle(
                  color: Colors.black87,
                ),
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
              height: contacts.isNotEmpty ? 30 : 800,
              child: Center(
                child:
                    contacts.isNotEmpty ? const Text('') : _noContacts(context),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return _item(context, index);
              },
              childCount: contacts.length,
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
                Icons.person_add_alt_outlined,
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
      key: ValueKey(contacts[index]),
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
                  contact: contacts[index],
                  title: 'Editar',
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
            var deletedContact = contacts[index];
            _delete(contacts[index]);
            setState(() {});
            _showSnackBar(context, deletedContact);
          },
        ),
      ],
      child: OpenContainer<Contact>(
        transitionType: _transitionType,
        transitionDuration: const Duration(
          milliseconds: kAnimationMillisecondsDuration,
        ),
        openBuilder: (BuildContext _, VoidCallback openContainer) {
          detailedContact = contacts[index];
          return ContactDetailsPage(
            contact: contacts[index],
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
              contact: contacts[index],
            ),
            title: Text(contacts[index].name),
            subtitle: Text(contacts[index].phone),
          );
        },
      ),
    );
  }

  Widget _noContacts(BuildContext context) {
    return isLoading
        ? Center(
            child: LoadingAnimationWidget.horizontalRotatingDots(
            color: Theme.of(context).colorScheme.primaryContainer,
            size: 50,
          ))
        : SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Sem contatos cadastrados',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25),
                  ),
                  // const SizedBox(height: 25),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Instruções',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16),
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: 'toque no botão '),
                              WidgetSpan(
                                child: Icon(Icons.person_add_alt_outlined,
                                    size: 18),
                              ),
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      'deslize o contato da esquerda para direita'),
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      'deslize o contato da direita para esquerda'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    constraints: const BoxConstraints(
                        minHeight: 150,
                        minWidth: 300,
                        maxWidth: 400,
                        maxHeight: double.infinity),
                    decoration: kGreyContainerBoxDecoration,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Clique no botão abaixo e tenha a experiência completa do app rapidamente',
                            textAlign: TextAlign.center,
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await FakeData.generateFakedata();
                              // print('after $res');
                              fetchData();
                            },
                            icon: const Icon(Icons.people),
                            label: const Text('Cadastrar Contactos fictícios'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          );
  }
}
