

class CanteenOption {
  final String id;
  final String name;

  CanteenOption({
    required this.id,
    required this.name,
  });

  factory CanteenOption.fromJson(Map<String, dynamic> json) {
    return CanteenOption(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  @override
  String toString() {
    return '''
    {
      "id": "$id",
      "name": "$name",
    }
    ''';
  }

}


