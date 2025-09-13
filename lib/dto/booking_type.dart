



enum BookingType{
  EVENT,
  TABLE,
  ROOM;


  static BookingType fromString(String value)=>
      BookingType.values.firstWhere(
            (e) => e.name.toLowerCase() == value.trim().toLowerCase(),
        orElse: () => throw ArgumentError('Unknown booking type: $value'),
      );
}