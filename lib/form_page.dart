import 'package:flutter/material.dart';
import 'database_helper.dart';

const double sizedBoxHeight = 20;
final _formKey = GlobalKey<FormState>();

class FormPage extends StatefulWidget {
  const FormPage({Key? key, this.contactId}) : super(key: key);
  final int? contactId;

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _photoController = TextEditingController();

  String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if (!isEmailValid) {
      return 'Informe um e-mail válido';
    }
    return null;
  }

  void fetchData() async {
    Map<String, dynamic>? data;

    if (widget.contactId != null) {
      data = await DatabaseHelper.getSingleData(widget.contactId!);
    }

    if (data != null) {
      _nameController.text = data['name'];
      _phoneController.text = data['phone'];
      _emailController.text = data['email'];
      _photoController.text = data['photo'];
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void _updateData(BuildContext context) async {
    Map<String, dynamic> data = {
      'name': _nameController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'photo': _photoController.text,
    };

    if (widget.contactId != null) {
      await DatabaseHelper.updateData(widget.contactId!, data);
      Navigator.pop(context, true);
    }
  }

  void _saveData() async {
    final name = _nameController.text;
    final phone = _phoneController.text;
    final email = _emailController.text;
    final photo = _photoController.text;

    await DatabaseHelper.insertContact(name, phone, email, photo);

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _photoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Contato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Nome',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person_rounded),
                    prefixIconColor: MaterialStateColor.resolveWith(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.focused)) {
                        return Colors.green;
                      }
                      if (states.contains(MaterialState.error)) {
                        return Colors.red;
                      }
                      return Colors.grey;
                    }),
                  ),
                  enableSuggestions: true,
                  keyboardType: TextInputType.name,
                  validator: (value) => (value != null && value.trim().isEmpty)
                      ? 'Nome deve ser preenchido'
                      : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: sizedBoxHeight),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: 'Telefone',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.phone_rounded),
                    prefixIconColor: MaterialStateColor.resolveWith(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.focused)) {
                        return Colors.green;
                      }
                      if (states.contains(MaterialState.error)) {
                        return Colors.red;
                      }
                      return Colors.grey;
                    }),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: sizedBoxHeight),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'E-mail',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email_rounded),
                    prefixIconColor: MaterialStateColor.resolveWith(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.focused)) {
                        return Colors.green;
                      }
                      if (states.contains(MaterialState.error)) {
                        return Colors.red;
                      }
                      return Colors.grey;
                    }),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmail,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: sizedBoxHeight),
                TextFormField(
                  controller: _photoController,
                  decoration: InputDecoration(
                    hintText: 'Photo',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.photo_rounded),
                    prefixIconColor: MaterialStateColor.resolveWith(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.focused)) {
                        return Colors.green;
                      }
                      if (states.contains(MaterialState.error)) {
                        return Colors.red;
                      }
                      return Colors.grey;
                    }),
                  ),
                ),
                const SizedBox(height: sizedBoxHeight),
                ElevatedButton(
                  onPressed: () {
                    if (widget.contactId != null) {
                      _updateData(context);
                    } else {
                      _saveData();
                    }
                  },
                  child: Text(widget.contactId == null
                      ? "Salvar Contato"
                      : "Atualizar Contato"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
