class MenuFilter {
  final String? canteenId;
  final String? dishName;
  final String? dishType;
  final String? diet;

  MenuFilter({
    this.canteenId,
    this.dishName,
    this.dishType,
    this.diet
  });

  /// Transforme le DTO en Map de query params
  /// Transform DTO to Map of query params
  Map<String, String> toQueryParams() {
    final Map<String, String> params = {};
    if (canteenId!=null && canteenId!.isNotEmpty) params['canteenId'] = canteenId!;
    if (dishName!=null && dishName!.isNotEmpty) params['dishName'] = dishName!;
    if(dishType!=null && dishType!.isNotEmpty )params['dishType'] = dishType!;
    if(diet!=null && diet!.isNotEmpty)params['diet'] = diet!;
    return params;
  }
}
