import 'network_product.dart';

class Networks {
  int? id;
  String? name;
  int? productTypeId;
  String? discountAmount;
  String? discountPercent;
  String? smeplugCode;
  String? vtpassCode;
  String? vtuautoCode;
  String? bwsubCode;
  String? routeTo;
  String? description;
  int? active;
  String? icon;
  String? createdAt;
  String? updatedAt;
  List<NetworkProducts>? products;

  Networks({
    required id,
    required name,
    required productTypeId,
    required discountAmount,
    required discountPercent,
    required smeplugCode,
    required vtpassCode,
    required vtuautoCode,
    required bwsubCode,
    required routeTo,
    required description,
    required active,
    required icon,
    required createdAt,
    required updatedAt,
    required products,
  });

  Networks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    productTypeId = json['product_type_id'];
    discountAmount = json['discount_amount'];
    discountPercent = json['discount_percent'];
    smeplugCode = json['smeplug_code'];
    vtpassCode = json['vtpass_code'];
    vtuautoCode = json['vtuauto_code'];
    bwsubCode = json['bwsub_code'];
    routeTo = json['route_to'];
    description = json['description'];
    active = json['active'];
    icon = json['icon'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(NetworkProducts?.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['product_type_id'] = productTypeId;
    data['discount_amount'] = discountAmount;
    data['discount_percent'] = discountPercent;
    data['smeplug_code'] = smeplugCode;
    data['vtpass_code'] = vtpassCode;
    data['vtuauto_code'] = vtuautoCode;
    data['bwsub_code'] = bwsubCode;
    data['route_to'] = routeTo;
    data['description'] = description;
    data['active'] = active;
    data['icon'] = icon;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (products != null) {
      data['products'] = products?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
