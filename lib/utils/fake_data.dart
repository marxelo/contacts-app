import 'package:contacts_app/utils/database_helper.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class FakeData {
  static Future<bool> generateFakedata() async {
    List<Contact> fakeDataList = [
      Contact('Ana Silva', '+55 (11) 987654-3210', 'ana.silva@example.com',
          'Acme S/A', 'a01.png'),
      Contact('Antônio Souza', '+55 (21) 987654-3211',
          'antonio.souza@example.com', 'XYZ S/A', 'a02.png'),
      Contact('Beatriz Carvalho', '+55 (31) 987654-3212',
          'beatriz.carvalho@example.com', 'ABC Ltda', 'a03.png'),
      Contact('Bernardo Oliveira', '+55 (41) 987654-3213',
          'bernardo.oliveira@example.com', 'DEF S/A', 'a04.png'),
      Contact('Vanessa Rodrigues', '+55 (51) 987654-3214',
          'vanessa.rodrigues@example.com', 'GHI S/A', 'a05.png'),
      Contact('Carlos Santos', '+55 (61) 987654-3215',
          'carlos.santos@example.com', 'JKL S/A', 'a06.png'),
      Contact('Carolina Menezes', '+55 (71) 987654-3216',
          'carolina.menezes@example.com', 'MNO Ltda', 'a07.png'),
      Contact('Daniel Ferreira', '+55 (81) 987654-3217',
          'daniel.ferreira@example.com', 'PQR S/A', 'a08.png'),
      Contact('Eduardo Oliveira', '+55 (91) 987654-3218',
          'eduardo.oliveira@example.com', 'STU Ltda', 'a09.png'),
      Contact('Fernanda Gomes', '+55 (11) 987654-3219',
          'fernanda.gomes@example.com', 'VWX S/A', 'a10.png'),
      Contact('Otávio Pereira', '+55 (11) 987654-3220',
          'otavio.pereira@example.com', 'YZ Ltda', 'a18.png'),
      Contact('Gabriela Silva', '+55 (21) 987654-3221',
          'gabriela.silva@example.com', 'Acme S/A', 'a12.png'),
      Contact('Túlio de Souza', '+55 (21) 987654-3222',
          'tulio.souza@example.com', 'XYZ S/A', 'a13.png'),
      Contact('Neuza Carvalho', '+55 (31) 987654-3223',
          'Neuza.carvalho@example.com', 'ABC S/A', 'a14.png'),
      Contact('Guilherme Oliveira', '+55 (41) 987654-3224',
          'guilherme.oliveira@example.com', 'DEF S/A', 'a15.png'),
      Contact('Marcelo Rodrigues', '+55 (51) 987654-3225',
          'marcelo.rodrigues@example.com', 'GHI Ltda', 'a16.png'),
      Contact('Isabella Menezes', '+55 (71) 987654-3227',
          'isabella.menezes@example.com', 'MNO S/A', 'a17.png'),
      Contact('João Ferreira', '+55 (81) 987654-3228',
          'joao.ferreira@example.com', 'PQR S/A', 'a11.png'),
      Contact('Júlia Costa', '+55 (91) 987654-3229', 'julia.costa@example.com',
          'STU Ltda', 'a19.png'),
      Contact('Laura Gomes', '+55 (11) 987654-3230', 'laura.gomes@example.com',
          'VWX S/A', 'a20.png'),
      Contact('Ana Mendes', '+55 (11) 987654-3231', 'ana.mendes@example.com',
          'VWX S/A', ''),
      Contact('Beto', '+55 (11) 987654-3232', 'beto.destruidor@example.com',
          'VWX S/A', ''),
      Contact('123 Milhos', '+55 (11) 987654-3233',
          '123milhos@123milhos.com', '123 milhos & Pamanhas', 'a00.png'),
    ];

    for (var fakeData in fakeDataList) {
      var name = fakeData.name;
      var phone = fakeData.phone;
      var email = fakeData.email;
      var business = fakeData.business;

      String photo = '';

      if (fakeData.photo.isNotEmpty) {
        ByteData bytes =
            await rootBundle.load('assets/samples/${fakeData.photo}');

        var buffer = bytes.buffer;

        photo = base64.encode(Uint8List.view(buffer));
      }

      await DatabaseHelper.insertContact(name, phone, email, business, photo);
    }

    return true;
  }
}

class Contact {
  String name;
  String phone;
  String email;
  String business;
  String photo;

  Contact(this.name, this.phone, this.email, this.business, this.photo);
}
