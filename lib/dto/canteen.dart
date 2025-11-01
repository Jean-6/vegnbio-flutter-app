
import 'contact.dart';
import 'location.dart';
import 'opening_hour.dart';

class Canteen {
  final String id;
  final String name;
  final String desc;
  final List<String> equipments;
  final int seats;
  final int meetingRooms;
  final Map<String, OpeningHours> openingHoursMap ;
  final Location location;
  final Contact contact;
  final List<String> tags;
  final List<String> menuIds;
  final List<String> pictures;

  Canteen({
    required this.id,
    required this.name,
    required this.desc,
    required this.equipments,
    required this.seats,
    required this.meetingRooms,
    required this.openingHoursMap ,
    required this.location,
    required this.contact,
    required this.tags,
    required this.menuIds,
    required this.pictures,

  });

  factory Canteen.fromJson(Map<String, dynamic> json) {
    return Canteen(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      desc: json['desc'] ?? '',
      equipments: List<String>.from(json['equipments'] ?? []),
      seats: json['seats'] ?? 0,
      meetingRooms: json['meetingRooms'] ?? 0,
      openingHoursMap : (json['openingHoursMap'] as Map<String, dynamic>? ?? {})
          .map(
            (key, value) => MapEntry(
              key.toString() ,
              OpeningHours .fromJson(value as Map<String, dynamic>),
        ),
      ),
      location: Location.fromJson(json['location'] ?? {}),
      contact: Contact.fromJson(json['contact'] ?? {}),
      tags: List<String>.from(json['tags'] ?? []),
      menuIds: List<String>.from(json['menuIds'] ?? []),
      pictures: List<String>.from(json['pictures'] ?? []),
    );
  }

  @override
  String toString() {
    return '''
    {
      "id": "$id",
      "name": "$name",
      "desc": "$desc",
      "equipments": "$equipments",
      "seats": "$seats",
      "meetingRooms": "$meetingRooms",
      "openingHourMap": "openingHoursMap",
      "location": "$location",
      "contact": "$contact",
      "tags": "$tags",
      "menuIds": "$menuIds",
      "pictures": "$pictures"
    }''';
  }
}

/**/

class CanteenInfo {
  final String canteenId;
  final String name;
  final Location? location;
  final Contact? contact;

  CanteenInfo({
    required this.canteenId,
    required this.name,
    this.location,
    this.contact,
  });

  factory CanteenInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CanteenInfo(canteenId: '', name: '');
    return CanteenInfo(
      canteenId: json['canteenId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      contact: json['contact'] != null ? Contact.fromJson(json['contact']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'canteenId': canteenId,
      'name': name,
      'location': location?.toJson(),
      'contact': contact?.toJson(),
    };
  }

  factory CanteenInfo.empty() => CanteenInfo(
    canteenId: '',
    name: '',
    location: Location.empty(),
    contact: Contact.empty(),
  );
}

// booking.dart
