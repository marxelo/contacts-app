import 'package:animations/animations.dart';
import 'package:contacts_app/utils/database_helper.dart';
import 'package:contacts_app/pages/form_page.dart';
import 'package:contacts_app/utils/constants.dart';
import 'package:contacts_app/utils/utils.dart';
import 'package:flutter/material.dart';

class ContactDetailsPage extends StatefulWidget {
  const ContactDetailsPage({super.key, required this.contactParam});

  final Map<String, dynamic> contactParam;

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  Map<String, dynamic> contact = {};
  final ContainerTransitionType _transitionType =
      ContainerTransitionType.fadeThrough;

  @override
  void initState() {
    super.initState();
    contact = widget.contactParam;
    // fetchData();
  }

  Widget getContactImageWidget() {
    if (contact['photo'].toString().isNotEmpty) {
      return Utils.imageFromBase64String(contact['photo'],
          width: kDetailsImageSize, height: kDetailsImageSize);
    }
    return Container(
      height: kDetailsImageSize,
      width: kDetailsImageSize,
      color: Colors.grey[100],
      child: const Icon(
        Icons.person,
        size: kDetailsImageSize,
        color: Colors.grey,
      ),
    );
  }

  void _delete(int id) async {
    await DatabaseHelper.deleteData(id);

    if (context.mounted) Navigator.pop(context, true);
  }

  void fetchUpdatedData() async {
    final Map<String, dynamic>? updatedData =
        await DatabaseHelper.getSingleData(contact['id']);

    setState(() {
      contact = updatedData!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          OpenContainer(
            transitionType: _transitionType,
            transitionDuration: const Duration(
              milliseconds: kAnimationMillisecondsDuration,
            ),
            openBuilder: (BuildContext context, VoidCallback _) {
              return FormPage(
                contact: contact,
                title: 'Editar Contato',
              );
            },
            closedElevation: 0.0,
            closedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(56 / 2),
              ),
            ),
            onClosed: (result) {
              if (result == true) {
                fetchUpdatedData();
              }
            },
            closedColor: Colors.transparent,
            closedBuilder: (BuildContext context, VoidCallback openContainer) {
              return const Icon(
                Icons.edit_outlined,
                color: Colors.black87,
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline_outlined,
              color: Colors.black87,
            ),
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text(
                  'Apagar contato?',
                  style: TextStyle(
                    fontSize: kDeleteDialogFontSize + 2,
                  ),
                ),
                contentTextStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: kDeleteDialogFontSize - 2.0,
                ),
                content:
                    Text('${contact["name"]} será removido de seus contatos'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text(
                      'Não',
                      style: TextStyle(
                        fontSize: kDeleteDialogFontSize,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _delete(contact['id']);
                      Navigator.pop(context, 'OK');
                    },
                    child: const Text(
                      'Sim',
                      style: TextStyle(
                        fontSize: kDeleteDialogFontSize,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        title: const Text('Detalhes'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            ClipRRect(
              // aki
              borderRadius: BorderRadius.circular(10000),
              child: getContactImageWidget(),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                contact['name'],
                style: const TextStyle(fontSize: 28),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              height: 240,
              width: 360,
              decoration: const BoxDecoration(
                color: Color.fromARGB(76, 199, 198, 198),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Informações do Contato',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone_rounded,
                          color: kDetailsIconColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          contact['phone'].toString().trim().isNotEmpty
                              ? contact['phone']
                              : 'Não cadastrado',
                          style: kDetailsTextStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        // const Text('E-mail: '),
                        const Icon(
                          Icons.email_rounded,
                          color: kDetailsIconColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          contact['email'].toString().trim().isNotEmpty
                              ? contact['email']
                              : 'Não cadastrado',
                          style: kDetailsTextStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        const Icon(
                          Icons.business_center_rounded,
                          color: kDetailsIconColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          contact['business'].toString().trim().isNotEmpty
                              ? contact['business']
                              : 'Não cadastrado',
                          style: kDetailsTextStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ]),
        ),
      ),
    );
  }
}
