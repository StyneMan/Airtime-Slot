import 'package:airtimeslot_app/model/user/user_model.dart';

class DataModel {
  String? token;
  UserModel? user;

  DataModel({
    required this.token,
    required this.user,
  });

  DataModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = UserModel.fromJson(json['user']);
  }
}
