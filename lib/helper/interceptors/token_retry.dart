import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpiredTokenRetryPolicy extends RetryPolicy {
  @override
  int get maxRetryAttempts => 5;

  @override
  bool shouldAttemptRetryOnException(Exception reason) {
    debugPrint(reason.toString());

    return false;
  }

  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    if (response.statusCode == 401) {
      debugPrint("Retrying request example here!...");
      final cache = await SharedPreferences.getInstance();

      return false;
    }

    return false;
  }
}
