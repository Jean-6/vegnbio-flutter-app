class Role {
  final String? id;
  final String role;

  Role({this.id, required this.role});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id']?.toString(),
      role: json['role']?.toString().toUpperCase() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'role': role,
  };

  @override
  String toString() => role;
}
