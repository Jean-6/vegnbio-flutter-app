import 'package:intl/intl.dart';

import 'canteen.dart';

class Event {
  final String id;
  final CanteenInfo canteenInfo;
  final String title;
  final String desc;
  final String type;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime date;
  final List<String> pictures;
  final DateTime createdAt;

  Event({
    required this.id,
    required this.canteenInfo,
    required this.title,
    required this.desc,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.pictures,
    required this.createdAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(String? dateStr, {String format = 'dd-MM-yyyy'}) {
      try {
        if (dateStr == null || dateStr.isEmpty) return DateTime.now();
        return DateFormat(format).parse(dateStr);
      } catch (_) {
        return DateTime.now();
      }
    }

    DateTime parseTime(String? timeStr) {
      try {
        if (timeStr == null || timeStr.isEmpty) {
          return DateTime.now();
        }
        final now = DateTime.now();
        final time = DateFormat('HH:mm').parse(timeStr);
        return DateTime(now.year, now.month, now.day, time.hour, time.minute);
      } catch (_) {
        return DateTime.now();
      }
    }

    return Event(
      id: json['id'] ?? '',
      canteenInfo: json['canteenInfo'] != null
          ? CanteenInfo.fromJson(json['canteenInfo'])
          : CanteenInfo.empty(),
      title: json['title'] ?? '',
      desc: json['desc'] ?? '',
      type: json['type'] ?? '',
      startTime: parseTime(json['startTime']),
      endTime: parseTime(json['endTime']),
      date: parseDate(json['date']),
      pictures: json['pictures'] != null
          ? List<String>.from(json['pictures'])
          : <String>[],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'canteenInfo': canteenInfo.toJson(),
      'title': title,
      'desc': desc,
      'type': type,
      'startTime': DateFormat('HH:mm').format(startTime),
      'endTime': DateFormat('HH:mm').format(endTime),
      'date': DateFormat('dd-MM-yyyy').format(date),
      'pictures': pictures,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

