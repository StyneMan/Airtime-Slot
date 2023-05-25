class ErrorResponse {
  bool? success;
  String? message;

  ErrorResponse({
    required this.success,
    required this.message,
  });

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
  }
}
