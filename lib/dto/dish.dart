import 'diet.dart';
import 'type.dart';

class Dish {
  final String id;
  final String name;
  final String desc;
  final Type type;
  final List<String> allergens;
  final List<String> pictures;
  final Set<Diet> diet;

  Dish({
    required this.id,
    required this.name,
    required this.desc,
    required this.type,
    required this.allergens,
    required this.pictures,
    required this.diet
  });

  factory Dish.fromJson(Map<String, dynamic> json) {

    return Dish(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      desc: json['desc']?.toString() ?? '',
      type: Type.fromString(json['type'].toString() ?? 'Other'),
      allergens: (json['allergens'] != null) ? List<String>.from(json['allergens']) : [],
      pictures: (json['pictures'] !=null ) ? List<String>.from(json['pictures']) : [],
        diet: (json['diet'] != null)
            ? (json['diet'] as List<dynamic>)
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
      "type": "$type",
      "allergens": "$allergens",
      "pictures": "$pictures",
      "diet": "$diet"
    }
    ''';
  }
}
