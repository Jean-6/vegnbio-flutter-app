class BookingFilter {
  final String? type;
  final String? userId;
  final DateTime? startDate;
  final DateTime? endDate;

  BookingFilter({
    this.type,
    this.userId,
    this.startDate,
    this.endDate
  });

  /// Transforme le DTO en Map de query params
  Map<String, String> toQueryParams() {
    final Map<String, String> params = {};
    if (type != null && type!.isNotEmpty) params['type'] = type!;
    if (startDate != null) params['startDate'] = startDate! as String;
    if (endDate != null ) params['endDate'] = endDate! as String;
    if (userId != null && userId!.isNotEmpty) params['userId'] = userId!;
    return params;
  }
}
