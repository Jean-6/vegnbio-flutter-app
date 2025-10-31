


class CanteenFilter {
  final String? name;
  final bool? hasConferenceRoom;
  final bool? hasMeditation;
  final bool? hasAnimation;

  CanteenFilter({
    this.name,
    this.hasConferenceRoom,
    this.hasMeditation,
    this.hasAnimation,
  });

  Map<String, String> toQueryParams() {
    final Map<String, String> params = {};
    if (name != null) params['name'] = name!;
    if (hasMeditation!= null) params['hasMeditation'] = hasMeditation.toString();
    if (hasAnimation!= null) params['hasAnimation'] = hasAnimation.toString();
    if (hasConferenceRoom != null) params['hasConferenceRoom'] = hasConferenceRoom.toString();
    return params;
  }
}
