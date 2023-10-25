import 'dart:io';

import 'package:contacts_app/enums/profile_pic_action.dart';
import 'package:contacts_app/utils/constants.dart';
import 'package:contacts_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:contacts_app/database_helper.dart';

final _formKey = GlobalKey<FormState>();

class FormPage extends StatefulWidget {
  const FormPage({Key? key, this.contact, required this.title})
      : super(key: key);
  final Map<String, dynamic>? contact;
  final String title;

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _businessController = TextEditingController();

  late Future<File> imageFile;
  late Image image;
  // late DBHelper dbHelper;
  // late List<Photo> images;
  File? imagePicked;
  bool hasProfilePic = false;
  XFile? imageTSave;
  late String imageString = '';
  Map<String, dynamic>? data2;
  bool contactPhotoChanged = false;

  String? validateEmail(String? email) {
    if (email!.isEmpty) {
      return null;
    }

    RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
    final isEmailValid = emailRegex.hasMatch(email);
    if (!isEmailValid) {
      return 'Informe um e-mail válido';
    }
    return null;
  }

  void fillPageElements() async {
    if (widget.contact != null) {
      _nameController.text = widget.contact!['name'];
      _phoneController.text = widget.contact!['phone'];
      _emailController.text = widget.contact!['email'];
      // _photoController.text = widget.contact!['photo'];
      _businessController.text = widget.contact!['business'];
      imageString = widget.contact!['photo'];
      if (imageString.isNotEmpty) {
        hasProfilePic = true;
      }
    }
  }

  _pickImage(ImageSource source) {
    ImagePicker()
        .pickImage(
            source: source, maxHeight: 512, maxWidth: 512, imageQuality: 75)
        .then((imgFile) async {
      String imgString = Utils.base64String(await imgFile!.readAsBytes());

      imagePicked = File(imgFile.path);
      imageString = imgString;
      hasProfilePic = true;
      // refreshImages();
      setState(() {});
    });
  }

  _clearImage() {
    hasProfilePic = false;
    imageString = '';
    imagePicked = null;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fillPageElements();
  }

  void _updateData(BuildContext context) async {
    Map<String, dynamic> data = {
      'name': _nameController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'business': _businessController.text,
      'photo': imageString,
    };

    if (widget.contact != null) {
      await DatabaseHelper.updateData(widget.contact!['id'], data);
      if (context.mounted) Navigator.pop(context, true);
    }
  }

  void _saveData() async {
    final name = _nameController.text;
    final phone = _phoneController.text;
    final email = _emailController.text;
    final business = _businessController.text;
    final photo = imageString;

    await DatabaseHelper.insertContact(name, phone, email, business, photo);

    if (context.mounted) Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _businessController.dispose();
    super.dispose();
  }

  Future<void> _pickSource() async {
    switch (await showDialog<ProfilePicAction>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('O que você quer fazer?'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, ProfilePicAction.pickFromCamera);
                },
                child: const Row(
                  children: [
                    Icon(Icons.camera_alt_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Tirar uma foto'),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, ProfilePicAction.pickFromGallery);
                },
                child: const Row(
                  children: [
                    Icon(Icons.photo_library_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Usar foto da galeria'),
                  ],
                ),
              ),
              hasProfilePic
                  ? SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context, ProfilePicAction.deletePicture);
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.delete_outline_outlined),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Remover foto'),
                        ],
                      ),
                    )
                  : const SimpleDialogOption(),
            ],
          );
        })) {
      case ProfilePicAction.pickFromCamera:
        _pickImage(ImageSource.camera);

        break;
      case ProfilePicAction.pickFromGallery:
        _pickImage(ImageSource.gallery);
        break;
      case ProfilePicAction.deletePicture:
        _clearImage();
        break;
      case null:
        // dialog dismissed
        break;
    }
  }

  Widget getWidget() {
    if (imagePicked != null) {
      return Image.file(
        imagePicked!,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    } else if (widget.contact != null &&
        // !contactPhotoChanged &&
        imageString.trim().isNotEmpty) {
      return Utils.imageFromBase64String(widget.contact!['photo'] ?? "");
    } else {
      return Container(
        height: 150,
        width: 150,
        color: Colors.grey[100],
        child: const Icon(
          Icons.person,
          size: 150,
          color: Colors.grey,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () => _pickSource(),
                  child: ClipRRect(
                    // aki
                    borderRadius: BorderRadius.circular(10000),
                    child: getWidget(),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                const SizedBox(
                  height: kFormBoxSizedHeight,
                ),
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
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: kFormBoxSizedHeight),
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
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: kFormBoxSizedHeight),
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
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: kFormBoxSizedHeight),
                TextFormField(
                  controller: _businessController,
                  decoration: InputDecoration(
                    hintText: 'Empresa',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.business_center_rounded),
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
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: kFormBoxSizedHeight),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.contact != null) {
                        _updateData(context);
                      } else {
                        _saveData();
                      }
                    }
                  },
                  child: Text(widget.contact == null
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
