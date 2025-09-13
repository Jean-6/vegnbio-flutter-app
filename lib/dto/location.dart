



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
      address: json['address']?.toString() ?? '',
      city:json['city']?.toString() ?? '',
      postalCode:json['postalCode']?.toString() ?? '',
      country: json['country']?.toString() ?? ''
    );
  }

  Map<String, dynamic> toJson() => {
    'address':address,
    'city':city,
    'postalCode':postalCode,
    'country':country,
  };

}