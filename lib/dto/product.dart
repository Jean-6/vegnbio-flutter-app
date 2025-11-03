

class Product {
  final String type;
  final String name;
  final String desc;
  final String category;
  final double quantity;
  final String unit;
  final double unitPrice;
  final String origin;
  final List<String> pictures;
  final DateTime availabilityDate;
  final DateTime expirationDate;
  final String supplierId;

  Product({
    required this.type,
    required this.name,
    required this.desc,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.pictures,
    required this.origin,
    required this.availabilityDate,
    required this.expirationDate,
    required this.supplierId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {

    String dateStr = json['date'] ?? '';
    String startTimeStr = json['startTime'] ?? '00:00';
    String endTimeStr = json['endTime'] ?? '00:00';

    // Combiner date + heure pour avoir un DateTime complet
    DateTime startTime = DateTime.parse("${dateStr}T${startTimeStr}:00");
    DateTime endTime = DateTime.parse("${dateStr}T${endTimeStr}:00");


    double _toDouble(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0;
      return 0;
    }

    return Product(
      type: json['type']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      desc: json['desc']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      quantity: _toDouble(json['quantity'] != null),

      unit: json['unit']?.toString() ?? '',
      unitPrice: _toDouble(json['unitPrice'] != null),
      origin: json['origin']?.toString() ?? '',
      pictures: (json['pictures'] !=null ) ? List<String>.from(json['pictures']) : [],
      availabilityDate: json['availabilityDate'] != null
          ? DateTime.parse(json['availabilityDate'].toString()).toLocal()
          : DateTime.now(),

      expirationDate: json['expirationDate'] != null
          ? DateTime.parse(json['expirationDate'].toString()).toLocal()
          : DateTime.now(),

      supplierId: json['supplierId']?.toString() ?? '',

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'nom': name,
      'desc': desc,
      'category': category,
      'quantity': quantity,
      'unit': unit,
      'unite_price': unitPrice,
      'pictures': pictures,
      'origin': origin,
      'availability_date': availabilityDate.toIso8601String(),
      'expiration_date': expirationDate.toIso8601String(),
      'supplier_id': supplierId,
    };
  }
}
