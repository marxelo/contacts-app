
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class CircleAvatarWidget extends StatelessWidget {
  final Map<String, dynamic> contact;

  const CircleAvatarWidget({
    Key? key,
    required this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: contact['photo'].toString().isNotEmpty
          ? (Utils.imageFromBase64String(contact['photo'])).image
          : null,
      backgroundColor: Utils.getBackgroundColor(contact['id']),
      child: Text(contact['photo'].toString().isEmpty
          ? Utils.getInitials(contact['name'])
          : ''),
    );
  }
}
