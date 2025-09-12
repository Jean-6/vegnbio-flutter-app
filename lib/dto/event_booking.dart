

class EventBooking {
  final String eventId;
  final String userId;


  EventBooking({
    required this.eventId,
    required this.userId,
  });

  factory EventBooking.fromJson(Map<String, dynamic> json) {
    return EventBooking(
      eventId: json['eventId'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  @override
  String toString() {
    return '''
    {
      "eventId": "$eventId",
      "userId": $userId,
    }
    ''';
  }

}


