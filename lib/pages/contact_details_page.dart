import 'package:animations/animations.dart';
import 'package:contacts_app/model/contact.dart';
import 'package:contacts_app/utils/database_helper.dart';
import 'package:contacts_app/pages/form_page.dart';
import 'package:contacts_app/utils/constants.dart';
import 'package:contacts_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetailsPage extends StatefulWidget {
  const ContactDetailsPage({super.key, required this.contact});

  final Contact contact;

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  bool _hasCallSupport = false;
  Future<void>? _launched;
  String _phone = '';
  late Contact kontact;
  final ContainerTransitionType _transitionType =
      ContainerTransitionType.fadeThrough;

  @override
  void initState() {
    super.initState();
    kontact = widget.contact;
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
  }

  Widget getContactImageWidget() {
    if (kontact.photo.toString().isNotEmpty) {
      return Utils.imageFromBase64String(kontact.photo,
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
    await DatabaseHelper.deleteContact(id);

    if (context.mounted) Navigator.pop(context, kontact);
  }

  void fetchUpdatedData(int id) async {
    final Contact? updatedData = await DatabaseHelper.getSingleContact(id);

    setState(() {
      kontact = updatedData!;
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _sentSms(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _sendEmail(String emailAddress) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
    );
    await launchUrl(launchUri);
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
                contact: kontact,
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
                fetchUpdatedData(widget.contact.id!);
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
                content: Text(
                    '${widget.contact.name} será removido de seus contatos'),
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
                      _delete(widget.contact.id!);
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
                kontact.name,
                style: const TextStyle(fontSize: 28),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                constraints: const BoxConstraints(
                    minHeight: 100,
                    minWidth: 300,
                    maxWidth: 400,
                    maxHeight: double.infinity),
                decoration: kGreyContainerBoxDecoration,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Informações do Contato',
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87),
                            ),
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
                          Expanded(
                            child: Text(
                              kontact.phone.toString().trim().isNotEmpty
                                  ? kontact.phone
                                  : 'Não cadastrado',
                              style: kDetailsTextStyle,
                            ),
                          ),
                          if (kontact.phone.toString().trim().isNotEmpty)
                            IconButton(
                              onPressed: _hasCallSupport
                                  ? () => setState(() {
                                        _launched = _makePhoneCall(
                                            kontact.phone.toString().trim());
                                      })
                                  : null,
                              icon: const Icon(
                                Icons.phone_outlined,
                                color: Colors.blue,
                              ),
                            ),
                          if (kontact.phone.toString().trim().isNotEmpty)
                            IconButton(
                              onPressed: _hasCallSupport
                                  ? () => setState(() {
                                        _launched = _sentSms(
                                            kontact.phone.toString().trim());
                                      })
                                  : null,
                              icon: const Icon(
                                Icons.sms_outlined,
                                color: Colors.blue,
                              ),
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
                          Expanded(
                            child: Text(
                              kontact.email.toString().trim().isNotEmpty
                                  ? kontact.email
                                  : 'Não cadastrado',
                              style: kDetailsTextStyle,
                            ),
                          ),
                          if (kontact.email.toString().trim().isNotEmpty)
                            IconButton(
                              onPressed: () => setState(
                                () {
                                  _launched = _sendEmail(
                                      kontact.email.toString().trim());
                                },
                              ),
                              icon: const Icon(
                                Icons.email_outlined,
                                color: Colors.blue,
                              ),
                            )
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
                          Expanded(
                            child: Text(
                              kontact.business.toString().trim().isNotEmpty
                                  ? kontact.business
                                  : 'Não cadastrado',
                              style: kDetailsTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
