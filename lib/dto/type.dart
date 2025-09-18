



enum Type{
  APPETIZER,
  MEAL,
  DESSERT;


  static Type fromString(String value)=>
      Type.values.firstWhere(
            (e) => e.name.toLowerCase() == value.trim().toLowerCase(),
        orElse: () => throw ArgumentError('Unknown DishType: $value'),
      );
}