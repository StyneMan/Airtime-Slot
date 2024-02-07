import 'package:airtimeslot_app/model/networks/network_product.dart';

class ProductModel {
  int? id;
  String? name;
  String? description;
  String? createdAt;
  String? updatedAt;
  List<NetworkProducts>? networks;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.networks,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['networks'] != null) {
      networks = [];
      json['networks'].forEach((v) {
        networks?.add(NetworkProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> ProductModel = <String, dynamic>{};
    ProductModel['id'] = id;
    ProductModel['name'] = name;
    ProductModel['description'] = description;
    ProductModel['created_at'] = createdAt;
    ProductModel['updated_at'] = updatedAt;
    if (networks != null) {
      ProductModel['networks'] = networks?.map((v) => v.toJson()).toList();
    }
    return ProductModel;
  }
}
