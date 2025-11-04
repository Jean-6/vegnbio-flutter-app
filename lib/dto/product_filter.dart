class ProductFilter {
  final String? type;
  final String? name;
  final String? category;
  final String? origin;
  final double? minPrice;
  final double? maxPrice;

  ProductFilter({
    this.type,
    this.name,
    this.category,
    this.origin,
    this.minPrice,
    this.maxPrice,
  });

  /// Transforme le DTO en Map de query params
  Map<String, String> toQueryParams() {
    final Map<String, String> params = {};
    if (type != null && type!.isNotEmpty) params['type'] = type!;
    if (name != null && name!.isNotEmpty) params['name'] = name!;
    if (category != null && category!.isNotEmpty) params['category'] = category!;
    if (origin != null && origin!.isNotEmpty) params['origin'] = origin!;
    if (minPrice != null) params['minPrice'] = minPrice.toString();
    if (maxPrice != null) params['maxPrice'] = maxPrice.toString();
    return params;
  }
}
