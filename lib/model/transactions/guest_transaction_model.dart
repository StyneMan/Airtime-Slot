class GuestTransactionModel {
  int? id;
  String? email;
  String? description;
  String? type;
  // int? transactionTypeId;
  String? status;
  // String? requestSource;
  dynamic amount;
  String? amountPaid;
  String? paymentMethod;
  dynamic discountAmount;
  String? discountPercent;
  String? transactionRef;
  // String? ipAddress;
  String? createdAt;
  String? discountText;

  GuestTransactionModel({
    required this.id,
    required this.email,
    required this.description,
    required this.type,
    // required this.transactionTypeId,
    required this.status,
    // required this.requestSource,
    required this.amount,
    required this.discountAmount,
    required this.discountPercent,
    required this.transactionRef,
    // required this.ipAddress,
    required this.createdAt,
    required this.discountText,
    required this.amountPaid,
    required this.paymentMethod,
  });

  GuestTransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    description = json['description'];
    type = json['type'];
    // transactionTypeId = json['transaction_type_id'];
    status = json['status'];
    // requestSource = json['request_source'];
    amount = json['amount'];
    discountAmount = json['discount_amount'];
    discountPercent = json['discount_percent'];
    transactionRef = json['transaction_ref'];
    // ipAddress = json['ip_address'];
    createdAt = json['created_at'];
    discountText = json['discount_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['description'] = description;
    data['type'] = type;
    data['status'] = status;

    // data['request_source'] = requestSource;
    data['amount'] = amount;
    data['discount_amount'] = discountAmount;
    data['discount_percent'] = discountPercent;
    data['transaction_ref'] = transactionRef;
    // data['ip_address'] = ipAddress;
    data['created_at'] = createdAt;
    data['discount_text'] = discountText;
    return data;
  }

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'email': email,
      'status': status,
      'amount': amount,
      'created_at': createdAt,
      'description': description,
      'discount_text': discountText,
      'discount_amount': discountAmount,
      'discount_percent': discountPercent,
      'transaction_ref': transactionRef,
      'payment_method': paymentMethod,
      'amount_paid': amountPaid,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'GuestTransactionModel{id: $id, type: $type, email: $email, status: $status, amount: $amount, created_at: $createdAt, description: $description, discount_text: $discountText, discount_amount: $discountAmount, transaction_ref: $transactionRef, payment_method: $paymentMethod, amount_paid: $amountPaid, discount_percent: $discountPercent}';
  }
}
