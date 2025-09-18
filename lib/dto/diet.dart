



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

  String get label {
    switch (this) {
      case Diet.VEGAN:
        return "Vegan";
      case Diet.VEGETARIAN:
        return "Végétarien";
      case Diet.GLUTEN_FREE:
        return "Sans gluten";
    }
  }

}