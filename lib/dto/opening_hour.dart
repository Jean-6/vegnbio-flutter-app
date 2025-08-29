

class OpeningHour{
  final String? openingTime;
  final String? closeTime;

  OpeningHour({
    required this.openingTime,
    required this.closeTime,
  });

  factory OpeningHour.fromJson(Map<String, dynamic> json) {
    return OpeningHour(
      openingTime: json['openingTime'],
      closeTime: json['closeTime'],
    );
  }

  Map<String, dynamic> toJson() => {
    'openingTime': openingTime,
    'closeTime': closeTime,
  };

}
