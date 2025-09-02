import 'diet.dart';
import 'Type.dart';

class Dish {
  final String id;
  final String name;
  final String desc;
  final double price;
  final Type type;
  final List<String> allergens;
  final List<String> pictures;
  final Set<Diet> diet;

  Dish({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.type,
    required this.allergens,
    required this.pictures,
    required this.diet
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0;
      return 0;
    }
    return Dish(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      desc: json['desc']?.toString() ?? '',
      price: _toDouble(json['price']!= null) ,
      type: Type.fromString(json['type'].toString() ?? 'Other'),
      allergens: (json['allergens'] != null) ? List<String>.from(json['allergens']) : [],
      pictures: (json['pictures'] !=null ) ? List<String>.from(json['pictures']) : [],
        diet: (json['dietType'] != null)
            ? (json['dietType'] as List<dynamic>)
            .where((e) => e != null)
            .map((e) => Diet.fromString(e.toString()))
            .toSet()
            : <Diet>{},//Convert each string to DietType
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'id' : id,
      'name': name,
      'desc': desc,
      'price' : price
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return '''
    {
      "id": "$id",
      "name": "$name",
      "desc": "$desc",
      "price": "$price",
      "type": "$type",
      "allergens": "$allergens",
      "pictures": "$pictures",
      "diet": "$diet"
    }
    ''';
  }
}
