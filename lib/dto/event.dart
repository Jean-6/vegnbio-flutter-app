class Event {
  final String restaurantId;
  final String title;
  final String desc;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> pictures;
  final List<String> participantsIds;

  Event({
    required this.restaurantId,
    required this.title,
    required this.desc,
    required this.startDate,
    required this.endDate,
    required this.pictures,
    required this.participantsIds,
  });

  factory Event.fromJson(Map<String,dynamic> json){
    return Event(
        restaurantId: json['restaurantId']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        desc: json['desc']?.toString() ?? '',
        startDate: json['startDate'] != null ? DateTime.parse(json['startDate'].toString()) : DateTime.now(),
        endDate: json['endDate'] != null ? DateTime.parse(json['endDate'].toString()) : DateTime.now(),
        pictures: (json['pictures'] as List?)?.map((e) => e.toString()).toList() ?? [],
        participantsIds: (json['participantsIds'] as List?)?.map((e) => e.toString()).toList() ?? [],

    );
  }


  @override
  String toString() {
    // TODO: implement toString
    return '''
    {
        "restaurantId": "$restaurantId",
        "title": "$title",
        "desc": "$desc",
        "startDate": "$startDate",
        "endDate": "$endDate",
        "pictures": "$pictures",
        "participantsIds": "$participantsIds",
    }''';
  }
}
