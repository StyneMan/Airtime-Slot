class UserTransaction {
  late int id;
  String? email;
  String? description;
  dynamic comment;
  String? type;
  int? transactionTypeId;
  dynamic productId;
  late String status;
  int? isUser;
  int? userId;
  String? agent;
  String? entryType;
  String? requestSource;
  String? amount;
  String? amountPaid;
  String? fees;
  String? discountAmount;
  String? discountPercent;
  int? isDiscounted;
  int? isPaid;
  String? paymentMethod;
  dynamic paymentRef;
  String? transactionRef;
  dynamic processedBy;
  dynamic cancelledBy;
  dynamic processedRef;
  late String ipAddress;
  dynamic errorMessage;
  dynamic infoMessage;
  late String? createdAt;
  dynamic paidAt;
  dynamic cancelledAt;
  dynamic refundAt;
  dynamic processedAt;
  String? discountText;
  dynamic walletLog;

  UserTransaction({
    required this.id,
    required this.email,
    required this.description,
    required this.comment,
    required this.type,
    required this.transactionTypeId,
    required this.productId,
    required this.status,
    required this.isUser,
    required this.userId,
    required this.agent,
    required this.entryType,
    required this.requestSource,
    required this.amount,
    required this.amountPaid,
    required this.fees,
    required this.discountAmount,
    required this.discountPercent,
    required this.isDiscounted,
    required this.isPaid,
    required this.paymentMethod,
    required this.paymentRef,
    required this.transactionRef,
    required this.processedBy,
    required this.cancelledBy,
    required this.processedRef,
    required this.ipAddress,
    required this.errorMessage,
    required this.infoMessage,
    required this.createdAt,
    required this.paidAt,
    required this.cancelledAt,
    required this.refundAt,
    required this.processedAt,
    required this.discountText,
    required this.walletLog,
  });

  UserTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    description = json['description'];
    comment = json['comment'];
    type = json['type'];
    transactionTypeId = json['transaction_type_id'];
    productId = json['product_id'];
    status = json['status'];
    isUser = json['is_user'];
    userId = json['user_id'];
    agent = json['agent'];
    entryType = json['entry_type'];
    requestSource = json['request_source'];
    amount = json['amount'];
    amountPaid = json['amount_paid'];
    fees = json['fees'];
    discountAmount = json['discount_amount'];
    discountPercent = json['discount_percent'];
    isDiscounted = json['is_discounted'];
    isPaid = json['is_paid'];
    paymentMethod = json['payment_method'];
    paymentRef = json['payment_ref'];
    transactionRef = json['transaction_ref'];
    processedBy = json['processed_by'];
    cancelledBy = json['cancelled_by'];
    processedRef = json['processed_ref'];
    ipAddress = json['ip_address'];
    errorMessage = json['error_message'];
    infoMessage = json['info_message'];
    createdAt = json['created_at'];
    paidAt = json['paid_at'];
    cancelledAt = json['cancelled_at'];
    refundAt = json['refund_at'];
    processedAt = json['processed_at'];
    discountText = json['discount_text'];
    walletLog = json['wallet_log'];
  }

  Map<String, dynamic> toJson(List<UserTransaction>? data) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['description'] = description;
    data['comment'] = comment;
    data['type'] = type;
    data['transaction_type_id'] = transactionTypeId;
    data['product_id'] = productId;
    data['status'] = status;
    data['is_user'] = isUser;
    data['user_id'] = userId;
    data['agent'] = agent;
    data['entry_type'] = entryType;
    data['request_source'] = requestSource;
    data['amount'] = amount;
    data['amount_paid'] = amountPaid;
    data['fees'] = fees;
    data['discount_amount'] = discountAmount;
    data['discount_percent'] = discountPercent;
    data['is_discounted'] = isDiscounted;
    data['is_paid'] = isPaid;
    data['payment_method'] = paymentMethod;
    data['payment_ref'] = paymentRef;
    data['transaction_ref'] = transactionRef;
    data['processed_by'] = processedBy;
    data['cancelled_by'] = cancelledBy;
    data['processed_ref'] = processedRef;
    data['ip_address'] = ipAddress;
    data['error_message'] = errorMessage;
    data['info_message'] = infoMessage;
    data['created_at'] = createdAt;
    data['paid_at'] = paidAt;
    data['cancelled_at'] = cancelledAt;
    data['refund_at'] = refundAt;
    data['processed_at'] = processedAt;
    data['discount_text'] = discountText;
    data['wallet_log'] = walletLog;
    return data;
  }
}
