

class TableBooking {
  final String canteenId;
  final String name;
  final String startTime;
  final String date;
  final int people;
  final String userId;

  TableBooking({
    required this.canteenId,
    required this.name,
    required this.startTime,
    required this.date,
    required this.people,
    required this.userId
  });

  factory TableBooking.fromJson(Map<String, dynamic> json) {
    return TableBooking(
      canteenId: json['canteenId'] ?? '',
      name: json['name'] ?? '',
      startTime: json['startTime'] ?? '',
      date: json['date'] ?? '',
      people: json['people'] is int
          ? json['people'] as int
          : int.tryParse(json['people']?.toString() ?? '0') ?? 0,
      userId: json['userId'] ?? '',
    );
  }

  @override
  String toString() {
    return '''
    {
      "canteenId": "$canteenId",
      "name": $name,
      "startTime": "$startTime",
      "date": "$date",
      "people": "$people",
      "userId": "$userId",
    }
    ''';
  }

}


