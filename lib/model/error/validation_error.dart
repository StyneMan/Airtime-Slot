import 'errors.dart';

class ValidationError {
  bool? success;
  String? message;
  late int statusCode;
  Errors? errors;

  ValidationError({
    required this.errors,
    required this.success,
    required this.message,
    required this.statusCode,
  });

  ValidationError.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    statusCode = json["status_code"];
    errors = Errors.fromJson(json['data']);
  }
}
