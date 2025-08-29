import 'dart:io';

import 'package:intl/intl.dart';

class Offer {
  final String type;
  final String name;
  final String desc;
  final String category;
  final double quantity;
  final String unit;
  final double unitPrice;
  final String origin;
  List<File> pictures;
  final DateTime availabilityDate;
  final DateTime expirationDate;
  final String supplierId;

  Offer({
    required this.type,
    required this.name,
    required this.desc,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    this.pictures = const [],
    required this.origin,
    required this.availabilityDate,
    required this.expirationDate,
    required this.supplierId,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    final dateFormat = DateFormat('dd-MM-yyyy');

    double _toDouble(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0;
      return 0;
    }


    return Offer(
      type: json['type'] as String? ??"",
      name: json['name'] as String? ?? "",
      desc: json['desc'] as String? ?? "",
      category: json['category'] as String? ?? "",

      quantity: _toDouble(json['quantity']),
      //(json['quantity'] as num).toDouble(),


      unit: json['unit'] as String? ?? "",


      unitPrice: _toDouble(json['unitPrice']),
      /*(json['unitPrice'] != null)
          ? (json['unitPrice'] is String
      ? double.tryParse(json['unitPrice']) ?? 0 : (json['unitPrice'] as num).toDouble()) : 0,*/

      origin: json['origin'] as String? ?? "",

      pictures: (json['pictures'] != null && json['pictures'] is List)
          ? (json['pictures'] as List)
                .map<File>((e) => File(e.toString()))
                .toList()
          : [],

      availabilityDate: (json['availabilityDate'] != null)
          ? dateFormat.parse(json['availabilityDate'])
          : DateTime.now(),
      expirationDate: (json['expirationDate'] != null)
          ? dateFormat.parse(json['expirationDate'])
          : DateTime.now(),
      supplierId: json['supplierId'] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'nom': name,
      'description': desc,
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
