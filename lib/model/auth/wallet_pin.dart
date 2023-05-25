
import 'package:airtimeslot_app/model/user/user_model.dart';

class WalletPINResponse {
  String? message;
  bool? success;
  UserModel? data;

  WalletPINResponse({
    required this.message,
    required this.success,
    required this.data,
  });

  WalletPINResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    data = UserModel.fromJson(json['data']);
  }

  //  Map<String, dynamic> toJson() {
  //    final Map<String, dynamic> data = new Map<String, dynamic>();
  //     data['message'] =  this.message;
  //     data['success'] =  this.success;
  //     data['data'] = DataModel.toJson(this.data);
  //  }

}
