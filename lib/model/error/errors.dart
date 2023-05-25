class Errors {
  late List<String> email;

  Errors({
    required this.email,
  });

  Errors.fromJson(Map<String, dynamic> json) {
    if (json['email'] != null) {
      email = [];
      json['email'].forEach((v) {
        email.add(v);
      });
    }
  }
}
