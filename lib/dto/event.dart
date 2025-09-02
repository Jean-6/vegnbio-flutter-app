import 'package:intl/intl.dart';
import 'package:vegnbio/dto/location.dart';

class Event {
  final String canteenId;
  final String title;
  final String desc;
  final String type;
  final Location location;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> pictures;
  final List<String> participantsIds;

  Event({
    required this.canteenId,
    required this.title,
    required this.desc,
    required this.type,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.pictures,
    required this.participantsIds,
  });

  factory Event.fromJson(Map<String,dynamic> json){
    final dateFormat =  DateFormat("dd-MM-yyyy");
    return Event(
        canteenId: json['restaurantId']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        desc: json['desc']?.toString() ?? '',
        type: json['type']?.toString() ?? '',
        location: Location.fromJson(json['location'] ?? {}),
        startDate: json['startDate'] != null 
            ? dateFormat.parse(json['startDate'].toString())
            : DateTime.now(),
        endDate: json['endDate'] != null
            ? dateFormat.parse(json['endDate'].toString())
            : DateTime.now(),
        pictures: (json['pictures'] as List?)?.map((e) => e.toString()).toList() ?? [],
        participantsIds: (json['participantsIds'] as List?)?.map((e) => e.toString()).toList() ?? [],

    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return '''
    {
        "canteenId": "$canteenId",
        "title": "$title",
        "desc": "$desc",
        "type": "$type",
        "location": "$location",
        "startDate": "$startDate",
        "endDate": "$endDate",
        "pictures": "$pictures",
        "participantsIds": "$participantsIds",
    }
    ''';
  }
}
