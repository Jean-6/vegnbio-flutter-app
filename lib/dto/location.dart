



class Location{
  final String address;
  final String city;
  final String postalCode;
  final String country;

  Location({
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country
  });

  factory Location.fromJson(Map<String, dynamic> json){
    return Location(
      address: json['address'],
      city:json['city'],
      postalCode:json['postalCode'],
      country: json['country']
    );
  }

  Map<String, dynamic> toJson() => {
    'address':address,
    'city':city,
    'postalCode':postalCode,
    'country':country,
  };

}