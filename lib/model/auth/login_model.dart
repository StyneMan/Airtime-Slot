import 'data_model.dart';
 
class LoginModel {
  String? message;
  bool? success;
  DataModel? data;

  LoginModel({
    required this.message,
    required this.success,
    required this.data,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    data = DataModel.fromJson(json['data']);
  }

  //  Map<String, dynamic> toJson() {
  //    final Map<String, dynamic> data = new Map<String, dynamic>();
  //     data['message'] =  this.message;
  //     data['success'] =  this.success;
  //     data['data'] = DataModel.toJson(this.data);
  //  }
  
}