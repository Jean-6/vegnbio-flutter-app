



enum Diet{
  VEGAN,
  VEGETARIAN,
  GLUTEN_FREE;

  // Convert String to DietType
  static Diet fromString(String value)=>
      Diet.values.firstWhere(
              (e) => e.name.toLowerCase() == value.trim().toLowerCase(),
              orElse: () => throw ArgumentError('Unknown DietType: $value'),
      );

}