import 'package:intl/intl.dart';

class EventFilter {
  final String? canteenId;
  final String? type;
  final DateTime? startDate;
  final DateTime? endDate;

  EventFilter({
    required this.canteenId,
    required this.type,
    required this.startDate,
    required this.endDate,
  });

  /// Transform DTO to Map of query params
  Map<String, String> toQueryParams() {
    final Map<String, String> params = {};
    final dateFormat = DateFormat('dd-MM-yyyy');
    if (canteenId!=null && canteenId!.isNotEmpty) params['canteenId'] = canteenId!;
    if (type!=null && type!.isNotEmpty) params['type'] = type!;
    if(startDate!=null )params['startDate'] = dateFormat.format(startDate!);
    if(endDate!=null )params['endDate'] = dateFormat.format(endDate!);
    return params;
  }
}
