import 'dietType.dart';
import 'dishType.dart';

class Dish {
  final String id;
  final String name;
  final String desc;
  final double price;
  final DishType dishType;
  final List<String> allergens;
  final List<String> pictures;
  final Set<DietType> dietType;

  Dish({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.dishType,
    required this.allergens,
    required this.pictures,
    required this.dietType
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      price: json['price'],
      dishType: DishType.fromString(json['dishType']),
      allergens: List<String>.from(json['allergens']),
      pictures: List<String>.from(json['pictures']),
      dietType: (json['dietType'] as List<dynamic>)
          .map((e) => DietType.fromString(e.toString()))
          .toSet(),//Convert each string to DietType
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
      "dishType": "$dishType",
      "allergens": "$allergens",
      "pictures": "$pictures",
      "dietType": "$dietType"
    }
    ''';
  }
}
