import 'dart:io';

import 'package:intl/intl.dart';


enum Status {
  APPROVED,
  PENDING,
  REJECTED,
}

Status statusFromString(String? status) {
  switch (status?.toUpperCase()) {
    case 'APPROVED':
      return Status.APPROVED;
    case 'PENDING':
      return Status.PENDING;
    case 'REJECTED':
      return Status.REJECTED;
    default:
      return Status.PENDING; // valeur par défaut
  }
}

class Approval {
  final Status status;
  final String? reasons;
  final DateTime? date;

  Approval({required this.status, this.reasons, this.date});

  factory Approval.fromJson(Map<String, dynamic> json) {
    return Approval(
      status: statusFromString(json['status'] as String?),
      reasons: json['reasons'] as String?,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      'reasons': reasons,
      'date': date?.toIso8601String(),
    };
  }
}

class Product {
  final String type;
  final String name;
  final String desc;
  final String category;
  final double quantity;
  final String unit;
  final double unitPrice;
  final String origin;
  List<String> pictures;
  final DateTime availabilityDate;
  final DateTime expirationDate;
  final String supplierId;
  final Approval? approval;

  Product({
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
    this.approval,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final dateFormat = DateFormat('dd-MM-yyyy');

    double _toDouble(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0;
      return 0;
    }


    return Product(
      type: json['type'] as String? ??"",
      name: json['name'] as String? ?? "",
      desc: json['desc'] as String? ?? "",
      category: json['category'] as String? ?? "",

      quantity: _toDouble(json['quantity']),
      //(json['quantity'] as num).toDouble(),
      unit: json['unit'] as String? ?? "",
      unitPrice: _toDouble(json['unitPrice']),
      origin: json['origin'] as String? ?? "",
      pictures: List<String>.from(json['pictures'] ?? []),
      availabilityDate: (json['availabilityDate'] != null)
          ? dateFormat.parse(json['availabilityDate'])
          : DateTime.now(),
      expirationDate: (json['expirationDate'] != null)
          ? dateFormat.parse(json['expirationDate'])
          : DateTime.now(),
      supplierId: json['supplierId'] as String? ?? "",
      approval: json['approval'] != null
          ? Approval.fromJson(json['approval'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final dateFormat = DateFormat('dd-MM-yyyy');

    return {
      'type': type,
      'name': name,
      'desc': desc,
      'category': category,
      'quantity': quantity,
      'unit': unit,
      'unitPrice': unitPrice,
      'pictures': pictures,
      'origin': origin,
      'availabilityDate': dateFormat.format(availabilityDate),
      'expirationDate': dateFormat.format(expirationDate),
      'supplierId': supplierId,
      'approval': approval?.toJson(),
    };
  }

}
