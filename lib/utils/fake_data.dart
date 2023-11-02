import 'package:contacts_app/model/contact.dart';
import 'package:contacts_app/utils/database_helper.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class FakeData {
  static Future<bool> generateFakedata() async {
    List<Contact> fakeContactList = [
      Contact(
          name: 'Ana Silva',
          phone: '+55(11) 987654-3210',
          email: 'ana.silva@example.com',
          business: 'Acme S/A',
          photo: 'a01.png'),
      Contact(
          name: 'Antônio Souza',
          phone: '+55(21) 987654-3211',
          email: 'antonio.souza@example.com',
          business: 'XYZ S/A',
          photo: 'a02.png'),
      Contact(
          name: 'Beatriz Carvalho',
          phone: '+55(31) 987654-3212',
          email: 'beatriz.carvalho@example.com',
          business: 'ABC Ltda',
          photo: 'a03.png'),
      Contact(
          name: 'Bernardo Oliveira',
          phone: '+55(41) 987654-3213',
          email: 'bernardo.oliveira@example.com',
          business: 'DEF S/A',
          photo: 'a04.png'),
      Contact(
          name: 'Vanessa Rodrigues',
          phone: '+55(51) 987654-3214',
          email: 'vanessa.rodrigues@example.com',
          business: 'GHI S/A',
          photo: 'a05.png'),
      Contact(
          name: 'Carlos Santos',
          phone: '+55(61) 987654-3215',
          email: 'carlos.santos@example.com',
          business: 'JKL S/A',
          photo: 'a06.png'),
      Contact(
          name: 'Carolina Menezes',
          phone: '+55(71) 987654-3216',
          email: 'carolina.menezes@example.com',
          business: 'MNO Ltda',
          photo: 'a07.png'),
      Contact(
          name: 'Daniel Ferreira',
          phone: '+55(81) 987654-3217',
          email: 'daniel.ferreira@example.com',
          business: 'PQR S/A',
          photo: 'a08.png'),
      Contact(
          name: 'Eduardo Oliveira',
          phone: '+55(91) 987654-3218',
          email: 'eduardo.oliveira@example.com',
          business: 'STU Ltda',
          photo: 'a09.png'),
      Contact(
          name: 'Fernanda Gomes',
          phone: '+55(11) 987654-3219',
          email: 'fernanda.gomes@example.com',
          business: 'VWX S/A',
          photo: 'a10.png'),
      Contact(
          name: 'Otávio Pereira',
          phone: '+55(11) 987654-3220',
          email: 'otavio.pereira@example.com',
          business: 'YZ Ltda',
          photo: 'a18.png'),
      Contact(
          name: 'Gabriela Silva',
          phone: '+55(21) 987654-3221',
          email: 'gabriela.silva@example.com',
          business: 'Acme S/A',
          photo: 'a12.png'),
      Contact(
          name: 'Túlio de Souza',
          phone: '+55(21) 987654-3222',
          email: 'tulio.souza@example.com',
          business: 'XYZ S/A',
          photo: 'a13.png'),
      Contact(
          name: 'Neuza Carvalho',
          phone: '+55(31) 987654-3223',
          email: 'Neuza.carvalho@example.com',
          business: 'ABC S/A',
          photo: 'a14.png'),
      Contact(
          name: 'Guilherme Oliveira',
          phone: '+55(41) 987654-3224',
          email: 'guilherme.oliveira@example.com',
          business: 'DEF S/A',
          photo: 'a15.png'),
      Contact(
          name: 'Marcelo Rodrigues',
          phone: '+55(51) 987654-3225',
          email: 'marcelo.rodrigues@example.com',
          business: 'GHI Ltda',
          photo: 'a16.png'),
      Contact(
          name: 'Isabella Menezes',
          phone: '+55(71) 987654-3227',
          email: 'isabella.menezes@example.com',
          business: 'MNO S/A',
          photo: 'a17.png'),
      Contact(
          name: 'João Ferreira',
          phone: '+55(81) 987654-3228',
          email: 'joao.ferreira@example.com',
          business: 'PQR S/A',
          photo: 'a11.png'),
      Contact(
          name: 'Júlia Costa',
          phone: '+55(91) 987654-3229',
          email: 'julia.costa@example.com',
          business: 'STU Ltda',
          photo: 'a19.png'),
      Contact(
          name: 'Laura Gomes',
          phone: '+55(11) 987654-3230',
          email: 'laura.gomes@example.com',
          business: 'VWX S/A',
          photo: 'a20.png'),
      Contact(
          name: 'Ana Mendes',
          phone: '+55(11) 987654-3231',
          email: 'ana.mendes@example.com',
          business: 'VWX S/A',
          photo: ''), // aki
      Contact(
          name: 'Beto',
          phone: '+55(11) 987654-3232',
          email: 'beto.destruidor@example.com',
          business: 'VWX S/A',
          photo: ''), // aki
      Contact(
          name: '123 Milhos',
          phone: '+55(11) 987654-3233',
          email: '123milhos@123milhos.com',
          business: '123 milhos & Pamanhas',
          photo: 'a00.png'),
    ];

    for (Contact fakeData in fakeContactList) {
      String photo = '';

      if (fakeData.photo.isNotEmpty) {
        ByteData bytes =
            await rootBundle.load('assets/samples/${fakeData.photo}');

        var buffer = bytes.buffer;

        photo = base64.encode(Uint8List.view(buffer));
      }

      fakeData.photo = photo;

      await DatabaseHelper.insertContact(fakeData);
    }

    return true;
  }
}
