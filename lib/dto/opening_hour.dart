import 'package:flutter/material.dart';

class OpeningHours {
  final TimeOfDay open;
  final TimeOfDay close;

  OpeningHours({
    required this.open,
    required this.close,
  });

  factory OpeningHours.fromJson(Map<String, dynamic> json) {
    // Parse "HH:mm:ss" directly
    final openParts = (json['open'] as String).split(':');
    final closeParts = (json['close'] as String).split(':');

    return OpeningHours(
      open: TimeOfDay(
        hour: int.parse(openParts[0]),
        minute: int.parse(openParts[1]),
      ),
      close: TimeOfDay(
        hour: int.parse(closeParts[0]),
        minute: int.parse(closeParts[1]),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'open': '${open.hour.toString().padLeft(2,'0')}:${open.minute.toString().padLeft(2,'0')}',
    'close': '${close.hour.toString().padLeft(2,'0')}:${close.minute.toString().padLeft(2,'0')}',
  };
}
