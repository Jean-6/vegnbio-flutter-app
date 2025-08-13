



enum DishType{
  APPETIZER,
  MEAL,
  DESSERT;


  static DishType fromString(String value)=>
      DishType.values.firstWhere(
            (e) => e.name.toLowerCase() == value.trim().toLowerCase(),
        orElse: () => throw ArgumentError('Unknown DishType: $value'),
      );
}