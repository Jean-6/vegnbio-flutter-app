import 'package:vegnbio/dto/location.dart';

class Event {
  final String id;
  final String canteenId;
  final String title;
  final String desc;
  final String type;
  final Location location;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime date;
  final List<String> pictures;
  final List<String> participantsIds;

  Event({
    required this.id,
    required this.canteenId,
    required this.title,
    required this.desc,
    required this.type,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.pictures,
    required this.participantsIds,
  });

  factory Event.fromJson(Map<String,dynamic> json){
    String dateStr = json['date'] ?? '';
    String startTimeStr = json['startTime'] ?? '00:00';
    String endTimeStr = json['endTime'] ?? '00:00';

    // Combiner date + heure pour avoir un DateTime complet
    DateTime startTime = DateTime.parse("${dateStr}T${startTimeStr}:00");
    DateTime endTime = DateTime.parse("${dateStr}T${endTimeStr}:00");

    return Event(
        id: json['id']?.toString() ?? '',
        canteenId: json['canteenId']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        desc: json['desc']?.toString() ?? '',
        type: json['type']?.toString() ?? '',
        location: Location.fromJson(json['location'] ?? {}),
        startTime: startTime,
        endTime: endTime,
        date: json['date'] != null
          ? DateTime.parse(json['date'].toString()).toLocal()
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
        "startTime": "$startTime",
        "endTime": "$endTime",
        "date": "$date",
        "pictures": "$pictures",
        "participantsIds": "$participantsIds",
    }
    ''';
  }
}
