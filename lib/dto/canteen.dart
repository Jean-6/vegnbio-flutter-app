
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
  final List<String> tags; // ex: ["vegan", "bio", "local"]
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


