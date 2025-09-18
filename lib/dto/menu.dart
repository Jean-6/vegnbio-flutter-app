


import 'dish.dart';

class Menu{

  final String id;
  final String canteenId;
  final String name;
  final String desc;
  final List<Dish> dishes;
  final double price;

  Menu({
    required this.id,
    required this.canteenId,
    required this.name,
    required this.desc,
    required this.dishes,
    required this.price,
  });

  factory Menu.fromJson(Map<String,dynamic> json){
    double _toDouble(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0;
      return 0;
    }
    return Menu(
        id: json['id'],
        canteenId: json['canteenId'],
        name: json['name'],
        desc: json['desc'],
        dishes: (json['dishes'] as List<dynamic>? )
            ?.map((dishJson)=> Dish.fromJson(dishJson))
            .toList() ?? [],
        price: _toDouble(json['price']!= null)
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'canteenId': canteenId,
      'name': name,
      'desc': desc,
      'dishes': dishes.map((dish) => dish.toJson()).toList(),
      'price': price
    };
  }

}