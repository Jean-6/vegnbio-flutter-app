


import 'dart:convert';


abstract class MenuItem {
  final String? id;
  final String itemType;
  final String canteenId;
  final String itemName;
  final String desc;
  final double price;
  final List<String> pictures;
  final String userId;

  MenuItem({
    this.id,
    required this.itemType,
    required this.canteenId,
    required this.itemName,
    required this.desc,
    required this.price,
    List<String>? pictures,
    required this.userId,
  }) : pictures = pictures ?? [];

  // Méthode pour convertir en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemType': itemType,
      'canteenId': canteenId,
      'itemName': itemName,
      'desc': desc,
      'price': price,
      'pictures': pictures,
      'userId': userId,
    };
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    final type = (json['itemType'] as String).toUpperCase(); // Normaliser
    switch (type) {
      case 'FOOD':
        return FoodItem.fromJson(json);
      case 'DRINK':
        return DrinkItem.fromJson(json);
      default:
        throw Exception('Unknown MenuItem type: ${json['itemType']}');
    }
  }
}

class FoodItem extends MenuItem {
  final bool isVegetarian;

  FoodItem({
    super.id,
    required super.itemType,
    required super.canteenId,
    required super.itemName,
    required super.desc,
    required super.price,
    super.pictures,
    required super.userId,
    required this.isVegetarian,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] as String?,
      itemType: json['itemType'] as String,
      canteenId: json['canteenId'] as String,
      itemName: json['itemName'] as String,
      desc: json['desc'] as String,
      price: (json['price'] as num).toDouble(),
      pictures: (json['pictures'] as List<dynamic>?)?.cast<String>(),
      userId: json['userId'] as String,
      isVegetarian: json['isVegetarian'] as bool? ?? false,
    );
  }
}

class DrinkItem extends MenuItem {
  final bool isAlcoholic;

  DrinkItem({
    super.id,
    required super.itemType,
    required super.canteenId,
    required super.itemName,
    required super.desc,
    required super.price,
    super.pictures,
    required super.userId,
    required this.isAlcoholic,
  });

  factory DrinkItem.fromJson(Map<String, dynamic> json) {
    return DrinkItem(
      id: json['id'] as String?,
      itemType: json['itemType'] as String,
      canteenId: json['canteenId'] as String,
      itemName: json['itemName'] as String,
      desc: json['desc'] as String,
      price: (json['price'] as num).toDouble(),
      pictures: (json['pictures'] as List<dynamic>?)?.cast<String>(),
      userId: json['userId'] as String,
      isAlcoholic: json['isAlcoholic'] as bool? ?? false,
    );
  }
}


class ItemMenuFilter {
  final String? itemType;
  final String? canteenId;
  final String? canteenName;
  final String? itemName;
  final double? minPrice;
  final double? maxPrice;

  ItemMenuFilter({
    this.itemType,
    this.canteenId,
    this.canteenName,
    this.itemName,
    this.minPrice,
    this.maxPrice,
  });

  // fromJson
  factory ItemMenuFilter.fromJson(Map<String, dynamic> json) {
    return ItemMenuFilter(
      itemType: json['itemType'] as String?,
      canteenId: json['canteenId'] as String?,
      canteenName: json['canteenName'] as String?,
      itemName: json['itemName'] as String?,
      minPrice: json['minPrice'] != null ? (json['minPrice'] as num).toDouble() : null,
      maxPrice: json['maxPrice'] != null ? (json['maxPrice'] as num).toDouble() : null,
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      if (itemType != null) 'itemType': itemType,
      if (canteenId != null) 'canteenId': canteenId,
      if (canteenName != null) 'canteenName': canteenName,
      if (itemName != null) 'itemName': itemName,
      if (minPrice != null) 'minPrice': minPrice,
      if (maxPrice != null) 'maxPrice': maxPrice,
    };
  }

  // Optionnel : convertir en JSON string
  String toJsonString() => json.encode(toJson());

  Map<String, String> toQueryParams() {
    final Map<String, String> params = {};
    if (itemType != null && itemType!.isNotEmpty) params['itemType'] = itemType!;
    if (canteenId != null && canteenId!.isNotEmpty) params['canteenId'] = canteenId!;
    if (canteenName != null && canteenName!.isNotEmpty) params['canteenName'] = canteenName!;
    if (itemName != null && itemName!.isNotEmpty) params['itemName'] = itemName!;
    if (minPrice != null) params['minPrice'] = minPrice!.toString();
    if (maxPrice != null) params['maxPrice'] = maxPrice!.toString();
    return params;
  }
}


