import 'package:contacts_app/database_helper.dart';
import 'package:contacts_app/form_page.dart';
import 'package:contacts_app/utils/constants.dart';
import 'package:contacts_app/utils/utils.dart';
import 'package:flutter/material.dart';

class ContactDetails extends StatefulWidget {
  const ContactDetails({super.key, required this.contactParam});

  final Map<String, dynamic> contactParam;

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  Map<String, dynamic> contact = {};

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
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.black87,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FormPage(
                    contact: contact,
                    title: 'Editar Contato',
                  ),
                ),
              ).then((result) {
                if (result == true) {
                  fetchUpdatedData();
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline_outlined,
              color: Colors.black87,
            ),
            onPressed: () {
              _delete(contact['id']);
            },
          )
        ],
        title: const Text('Detalhes'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          ClipRRect(
            // aki
            borderRadius: BorderRadius.circular(10000),
            child: getContactImageWidget(),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            contact['name'],
            style: const TextStyle(fontSize: 28),
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
                      // const Text('Empresa: '),
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
            height: 10,
          ),
          const SizedBox(
            height: 50,
          ),
        ]),
      ),
    );
  }
}
