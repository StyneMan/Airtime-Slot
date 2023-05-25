class MProduct {
  int? id;
  late String name;
  int? productTypeId;
  int? productNetworkId;
  int? amount;
  int? active;
  String? vtuautoCode;
  String? bwsubCode;
  dynamic smeplugCode;
  String? vtpassCode;
  String? routeTo;
  String? discountAmount;
  String? discountPercent;
  String? createdAt;
  String? updatedAt;

  MProduct({
    required this.id,
    required this.name,
    required this.productTypeId,
    required this.productNetworkId,
    required this.amount,
    required this.active,
    required this.vtuautoCode,
    required this.bwsubCode,
    required this.smeplugCode,
    required this.vtpassCode,
    required this.routeTo,
    required this.discountAmount,
    required this.discountPercent,
    required this.createdAt,
    required this.updatedAt,
  });

  MProduct.fromJson(Map<String?, dynamic> json) {
    id = json['id'];
    name = json['name'];
    productTypeId = json['product_type_id'];
    productNetworkId = json['product_network_id'];
    amount = json['amount'];
    active = json['active'];
    vtuautoCode = json['vtuauto_code'];
    bwsubCode = json['bwsub_code'];
    smeplugCode = json['smeplug_code'];
    vtpassCode = json['vtpass_code'];
    routeTo = json['route_to'];
    discountAmount = json['discount_amount'];
    discountPercent = json['discount_percent'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['product_type_id'] = productTypeId;
    data['product_network_id'] = productNetworkId;
    data['amount'] = amount;
    data['active'] = active;
    data['vtuauto_code'] = vtuautoCode;
    data['bwsub_code'] = bwsubCode;
    data['smeplug_code'] = smeplugCode;
    data['vtpass_code'] = vtpassCode;
    data['route_to'] = routeTo;
    data['discount_amount'] = discountAmount;
    data['discount_percent'] = discountPercent;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MProduct && id == other.id && name == other.name;

  @override
  int get hashCode => name.hashCode;
}
