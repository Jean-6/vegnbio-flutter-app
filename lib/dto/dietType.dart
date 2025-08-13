



enum DietType{
  VEGAN,
  VEGETARIAN,
  GLUTEN_FREE;

  // Convert String to DietType
  static DietType fromString(String value)=>
      DietType.values.firstWhere(
              (e) => e.name.toLowerCase() == value.trim().toLowerCase(),
              orElse: () => throw ArgumentError('Unknown DietType: $value'),
      );

}