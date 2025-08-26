
class ResponseWrapper<T>{

  final bool success;
  final String message;
  final T data;
  final int status;
  final String path;



  ResponseWrapper({
    required this.success,
    required this.message,
    required this.data,
    required this.status,
    required this.path
  });


  factory ResponseWrapper.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic) fromJsonT,
      ) {
    return ResponseWrapper(
        success: json['success'] ?? '',
        message: json['message'] ?? '',
        data: fromJsonT(json['data']),//json['data'] != null ? fromJsonT(json['data']) : null,
        status: json['status'] ?? '',
        path: json['path'] ?? ''
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return '''
    {
        "success": "$success",
        "message": "$message",
        "data": "$data",
        "status": "$status",
        "path": "$path",
    }''';
  }

}