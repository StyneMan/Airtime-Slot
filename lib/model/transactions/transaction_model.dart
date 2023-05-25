class TransactionModel {
  int? id;
  String? email;
  String? description;
  String? type;
  int? transactionTypeId;
  String? status;
  int? isUser;
  // int? userId;
  String? agent;
  String? entryType;
  String? requestSource;
  dynamic amount;
  dynamic discountAmount;
  String? discountPercent;
  String? transactionRef;
  String? ipAddress;
  String? createdAt;
  String? discountText;

  TransactionModel({
    required this.id,
    required this.email,
    required this.description,
    required this.type,
    required this.transactionTypeId,
    required this.status,
    required this.isUser,
    // required this.userId,
    required this.agent,
    required this.entryType,
    required this.requestSource,
    required this.amount,
    required this.discountAmount,
    required this.discountPercent,
    required this.transactionRef,
    required this.ipAddress,
    required this.createdAt,
    required this.discountText,
  });

  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    description = json['description'];
    type = json['type'];
    transactionTypeId = json['transaction_type_id'];
    status = json['status'];
    isUser = json['is_user'];
    // userId = json['user_id'];
    agent = json['agent'];
    entryType = json['entry_type'];
    requestSource = json['request_source'];
    amount = json['amount'];
    discountAmount = json['discount_amount'];
    discountPercent = json['discount_percent'];
    transactionRef = json['transaction_ref'];
    ipAddress = json['ip_address'];
    createdAt = json['created_at'];
    discountText = json['discount_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['description'] = description;
    data['type'] = type;
    data['transaction_type_id'] = transactionTypeId;
    data['status'] = status;
    data['is_user'] = isUser;
    // data['user_id'] = userId;
    data['agent'] = agent;
    data['entry_type'] = entryType;
    data['request_source'] = requestSource;
    data['amount'] = amount;
    data['discount_amount'] = discountAmount;
    data['discount_percent'] = discountPercent;
    data['transaction_ref'] = transactionRef;
    data['ip_address'] = ipAddress;
    data['created_at'] = createdAt;
    data['discount_text'] = discountText;
    return data;
  }
}
