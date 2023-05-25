class OTPResend {
  bool? success;
  String? data;
  dynamic message;

  OTPResend({
    required this.success,
    required this.data,
    required this.message,
  });

  OTPResend.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    data = json['data'];
  }
}
