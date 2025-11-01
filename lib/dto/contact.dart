class Contact {
  final String phone;
  final String email;

  Contact({
    required this.phone,
    required this.email
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      phone: json['phone'],
      email: json['email']
    );
  }

  Map<String, dynamic> toJson() => {
    'phone': phone,
    'email': email,
  };

  factory Contact.empty() => Contact(
    phone: '',
    email: '',
  );
}
