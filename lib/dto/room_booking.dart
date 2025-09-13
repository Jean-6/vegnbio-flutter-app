

class RoomBooking {
  final String canteenId;
  final String startTime;
  final String endTime;
  final String date;
  final int people;
  final String userId;

  RoomBooking({
    required this.canteenId,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.people,
    required this.userId
  });

  factory RoomBooking.fromJson(Map<String, dynamic> json) {
    return RoomBooking(
        canteenId: json['canteenId'] ?? '',
        startTime: json['startTime'] ?? '',
        endTime: json['endTime'] ?? '',
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
      "startTime": "$startTime",
      "endTime": "$endTime",
      "date": "$date",
      "people": "$people",
      "userId": "$userId",
    }
    ''';
  }

}


