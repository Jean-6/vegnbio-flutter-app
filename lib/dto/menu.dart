


import 'dish.dart';

class Menu{

  final String id;
  final String canteenId;
  final String name;
  final String desc;
  final List<Dish> dishes;

  Menu({
    required this.id,
    required this.canteenId,
    required this.name,
    required this.desc,
    required this.dishes
  });

  factory Menu.fromJson(Map<String,dynamic> json){
    return Menu(
        id: json['id'],
        canteenId: json['canteenId'],
        name: json['name'],
        desc: json['desc'],
        dishes: (json['dishes'] as List<dynamic>? )
            ?.map((dishJson)=> Dish.fromJson(dishJson))
            .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'canteenId': canteenId,
      'name': name,
      'desc': desc,
      'dishes': dishes.map((dish) => dish.toJson()).toList(),
    };
  }

}