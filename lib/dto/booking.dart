

import 'canteen.dart';


class Location {
  final String address;
  final String city;
  final String postalCode;
  final String country; // required

  Location({
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  factory Location.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Location(
        address: '',
        city: '',
        postalCode: '',
        country: '',
      );
    }
    return Location(
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      postalCode: json['postalCode']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
    );
  }
}


class Booking {
  final String type;
  final CanteenInfo canteenInfo;
  final Location location;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime date;


  Booking({
    required this.type,
    required this.canteenInfo,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.date,

  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    String dateStr = json['date'] ?? '';
    String startTimeStr = json['startTime'] ?? '00:00';
    String? endTimeStr = json['endTime'];

    DateTime parseDateTime(String date, String? time) {
      final t = (time == null || time.isEmpty) ? "00:00" : time;
      final timeWithSeconds = t.length == 5 ? "$t:00" : t; // HH:mm → HH:mm:ss
      try {
        return DateTime.parse("${date}T$timeWithSeconds");
      } catch (_) {
        return DateTime.now();
      }
    }

    final canteenInfo = CanteenInfo.fromJson(json['canteenInfo']);
    return Booking(
      type: json['type'] ?? '',
      canteenInfo: CanteenInfo.fromJson(json['canteenInfo']),
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : json['canteenInfo']?['location'] != null
          ? Location.fromJson(json['canteenInfo']['location'])
          : Location(address: '', city: '', postalCode: '', country: ''),
      startTime: parseDateTime(dateStr, startTimeStr),
      endTime: parseDateTime(dateStr, endTimeStr),
      date: DateTime.tryParse(dateStr) ?? DateTime.now(),
      //people: json['people'] ?? 0,
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

/*TABLE*/


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


/*ROOM*/



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




