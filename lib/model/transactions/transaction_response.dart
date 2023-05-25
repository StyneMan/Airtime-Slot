import 'guest_transaction_model.dart';

class TransactionResponse {
  bool? success;
  String? message;
  late GuestTransactionModel data;

  TransactionResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  TransactionResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = GuestTransactionModel.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['data'] = data;
    return data;
  }
}
