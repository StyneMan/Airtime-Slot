class UserModel {
  List<dynamic>? accounts;
  dynamic bannedAt;
  dynamic bvn;
  String? createdAt;
  String? currency;
  dynamic dob;
  late String email;
  dynamic emailVerifiedAt;
  late int errorPinCount;
  dynamic fcmDeviceKey;
  dynamic gender;
  dynamic getEmailAlert;
  late bool hasVirtualAccount;
  late int id;
  late bool isAccountVerified;
  late bool isAdmin;
  late int isValidEmail;
  late bool isWalletPin;
  dynamic kycCompletedAt;
  late int monthAmountSpent;
  late int monthTransactionCount;
  late String name;
  dynamic phone;
  String? ref;
  String? referralCode;
  dynamic suspendedAt;
  String? type;
  String? updatedAt;
  int? userGroupId;
  String? walletBalance;

  UserModel({
    required this.accounts,
    required this.bannedAt,
    required this.bvn,
    required this.createdAt,
    required this.currency,
    required this.dob,
    required this.email,
    required this.emailVerifiedAt,
    required this.errorPinCount,
    required this.fcmDeviceKey,
    required this.gender,
    required this.getEmailAlert,
    required this.hasVirtualAccount,
    required this.id,
    required this.isAccountVerified,
    required this.isAdmin,
    required this.isValidEmail,
    required this.isWalletPin,
    required this.kycCompletedAt,
    required this.monthAmountSpent,
    required this.monthTransactionCount,
    required this.name,
    required this.phone,
    required this.ref,
    required this.referralCode,
    required this.suspendedAt,
    required this.type,
    required this.updatedAt,
    required this.userGroupId,
    required this.walletBalance,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    // if (json['accounts'] != null) {
    //   accounts = [];
    //   json['accounts'].forEach((v) {
    //     accounts?.add(new Null.fromJson(v));
    //   });
    // }
    bannedAt = json['banned_at'];
    bvn = json['bvn'];
    createdAt = json['created_at'];
    currency = json['currency'];
    dob = json['dob'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    errorPinCount = json['error_pin_count'];
    fcmDeviceKey = json['fcm_device_key'];
    gender = json['gender'];
    getEmailAlert = json['get_email_alert'];
    hasVirtualAccount = json['has_virtual_account'];
    id = json['id'];
    isAccountVerified = json['is_account_verified'];
    isAdmin = json['is_admin'];
    isValidEmail = json['is_valid_email'];
    isWalletPin = json['is_wallet_pin'];
    kycCompletedAt = json['kyc_completed_at'];
    monthAmountSpent = json['month_amount_spent'];
    monthTransactionCount = json['month_transaction_count'];
    name = json['name'];
    phone = json['phone'];
    ref = json['ref'];
    referralCode = json['referral_code'];
    suspendedAt = json['suspended_at'];
    type = json['type'];
    updatedAt = json['updated_at'];
    userGroupId = json['user_group_id'];
    walletBalance = json['wallet_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // if (this.accounts != null) {
    //   data['accounts'] = this.accounts?.map((v) => v.toJson()).toList();
    // }
    data['banned_at'] = bannedAt;
    data['bvn'] = bvn;
    data['created_at'] = createdAt;
    data['currency'] = currency;
    data['dob'] = dob;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['error_pin_count'] = errorPinCount;
    data['fcm_device_key'] = fcmDeviceKey;
    data['gender'] = gender;
    data['get_email_alert'] = getEmailAlert;
    data['has_virtual_account'] = hasVirtualAccount;
    data['id'] = id;
    data['is_account_verified'] = isAccountVerified;
    data['is_admin'] = isAdmin;
    data['is_valid_email'] = isValidEmail;
    data['is_wallet_pin'] = isWalletPin;
    data['kyc_completed_at'] = kycCompletedAt;
    data['month_amount_spent'] = monthAmountSpent;
    data['month_transaction_count'] = monthTransactionCount;
    data['name'] = name;
    data['phone'] = phone;
    data['ref'] = ref;
    data['referral_code'] = referralCode;
    data['suspended_at'] = suspendedAt;
    data['type'] = type;
    data['updated_at'] = updatedAt;
    data['user_group_id'] = userGroupId;
    data['wallet_balance'] = walletBalance;
    return data;
  }
}
