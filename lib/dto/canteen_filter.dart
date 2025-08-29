


class CanteenFilter {
  final String? canteenName;
  final String? dishName;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? capacity;
  final bool? hasWifi;
  final bool? hasPrinter;
  final bool? hasConferenceRoom;

  CanteenFilter({
    this.canteenName,
    this.dishName,
    this.startDate,
    this.endDate,
    this.capacity,
    this.hasWifi,
    this.hasPrinter,
    this.hasConferenceRoom,
  });

  Map<String, String> toQueryParams() {
    final Map<String, String> params = {};
    if (canteenName != null) params['canteenName'] = canteenName!;
    if (dishName != null) params['dishName'] = dishName!;
    if (startDate != null) params['startDate'] = startDate!.toIso8601String();
    if (endDate != null) params['endDate'] = endDate!.toIso8601String();
    if (capacity != null) params['capacity'] = capacity.toString();
    if (hasWifi != null) params['hasWifi'] = hasWifi.toString();
    if (hasPrinter != null) params['hasPrinter'] = hasPrinter.toString();
    if (hasConferenceRoom != null) params['hasConferenceRoom'] = hasConferenceRoom.toString();
    return params;
  }
}
