

import 'location.dart';

class Booking {
  final String title;
  final String type;
  final String canteenName;
  final Location location;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime date;


  Booking({
    required this.title,
    required this.type,
    required this.canteenName,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.date,

  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    String dateStr = json['date'] ?? '';
    String startTimeStr = json['startTime'] ?? '00:00';
    String endTimeStr = json['endTime'] ?? '00:00';

    // Combiner date + heure pour avoir un DateTime complet
    DateTime startTime = DateTime.parse("${dateStr}T${startTimeStr}:00");
    DateTime endTime = DateTime.parse("${dateStr}T${endTimeStr}:00");

    return Booking(
      title: json['title']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      canteenName: json['canteenName']?.toString() ?? '',
      location: Location.fromJson(json['location'] ?? {}),
      startTime: startTime,
      endTime: endTime,
      date: json['date'] != null
          ? DateTime.parse(json['date'].toString()).toLocal()
          : DateTime.now(),
    );
  }

  @override
  String toString() {
    return '''
    {
        "type": "$type",
    }''';
  }
}


