class Contact {
  late int? id;
  String name;
  String phone;
  String email;
  String business;
  String photo;

  Contact({
    this.id,
    required this.name,
    this.phone = '',
    this.email = '', // Make 'email' optional with a default value
    this.business = '',
    this.photo = '',
  });

  // Convert a Contact object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'business': business,
      'photo': photo,
    };
  }

  // Create a Contact object from a map
  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      business: map['business'],
      photo: map['photo'],
    );
  }
}
