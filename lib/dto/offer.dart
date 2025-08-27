

import 'dart:io';

class Offer{

  final String type;
  final String name;
  final String description;
  final String category;
  final double quantity;
  final String unit;
  final double unitPrice;
  final String origin;
  List<File> pictures;
  final DateTime availabilityDate;
  final DateTime expirationDate;
  final String supplierId;


  Offer({required this.type, required this.name, required this.description, required this.category, required this.quantity,
    required this.unit, required this.unitPrice,
    this.pictures = const[], required this.origin, required this.availabilityDate, required this.expirationDate, required this.supplierId
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'nom': name,
      'description': description,
      'category': category,
      'quantity': quantity,
      'unit': unit,
      'unite_price': unitPrice,
      'pictures':pictures,
      'origin': origin,
      'availability_date': availabilityDate.toIso8601String(),
      'expiration_date': expirationDate.toIso8601String(),
      'supplier_id': supplierId,
    };
  }

}