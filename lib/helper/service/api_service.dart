import 'dart:convert';

import 'package:airtimeslot_app/helper/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';
// import 'package:package_info_plus/package_info_plus.dart';

import "../interceptors/api_interceptor.dart";
import "../interceptors/token_retry.dart";
import '../state/state_controller.dart';

class APIService {
  final _controller = Get.find<StateController>();
  http.Client client = InterceptedClient.build(
    interceptors: [
      MyApiInterceptor(),
    ],
    retryPolicy: ExpiredTokenRetryPolicy(),
  );

  // PackageInfo? packageInfo;
  // String packageInfo = _controller.appVersion.value;÷

  init() async {
    // packageInfo = await PackageInfo.fromPlatform();
  }

  APIService() {
    init();
  }

  Future<http.Response> signup(Map body) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}backend/auth/register'),
      headers: {
        "Content-type": "application/json",
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> login(Map body) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}backend/auth/login'),
      headers: {
        "Content-type": "application/json",
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> forgotPass(Map body) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}backend/password/email'),
      headers: {
        "Content-type": "application/json",
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> verify(Map body, var accessToken) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}backend/verification/verify'),
      headers: {
        "Content-type": "application/json",
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
        "Authorization": "Bearer " + accessToken,
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> resendOTP(var accessToken) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}backend/verification/resend'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
    );
  }

  Future<http.Response> setWalletPIN(Map body, var accessToken) async {
    return await http.put(
      Uri.parse('${Constants.baseURL}backend/user/wallet/pin'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> withdrawWallet(Map body, var accessToken) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}backend/withdraw'),
      headers: {
        "Content-type": "application/json",
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
        "Authorization": "Bearer " + accessToken,
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> changeWalletPIN(Map body, var accessToken) async {
    return await client.put(
      Uri.parse('${Constants.baseURL}backend/user/wallet/change_pin'),
      headers: {
        "Content-type": "application/json",
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
        "Authorization": "Bearer " + accessToken,
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> resetWalletPIN(var accessToken) async {
    return await client.put(
      Uri.parse('${Constants.baseURL}backend/user/wallet/reset'),
      headers: {
        "Content-type": "application/json",
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
        "Authorization": "Bearer " + accessToken,
      },
    );
  }

  Future<http.Response> confirmResetWalletPIN(Map body, var accessToken) async {
    return await client.put(
      Uri.parse('${Constants.baseURL}backend/user/wallet/confirm_reset'),
      headers: {
        "Content-type": "application/json",
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
        "Authorization": "Bearer " + accessToken,
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> getProfile(String accessToken) async {
    return await client.get(
      Uri.parse('${Constants.baseURL}backend/user/profile'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
    );
  }

  Future<http.Response> logout(String accessToken) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}backend/auth/logout'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
    );
  }

  Future getProducts() async {
    return await http.get(
      Uri.parse('${Constants.baseURL}backend/products'),
      headers: {
        "Content-type": "application/json",
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
    );
  }

  Future<http.Response> getTransactions(String accessToken) async {
    return await client.get(
      Uri.parse('${Constants.baseURL}backend/user/transactions'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
    );
  }

  Future<http.Response> getTransactionsPaginated(
      String accessToken, int currentPage) async {
    return await client.get(
      Uri.parse(
          '${Constants.baseURL}backend/user/transactions?page=$currentPage'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
    );
  }

  fetchTransactions(String accessToken) async {

    final response = await client.get(
      Uri.parse('${Constants.baseURL}backend/user/transactions'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
    );

    debugPrint("RESPONSE -> TRANSACTION :: ${response.body}");

    if (response.statusCode == 200) {
      Map<String, dynamic> tmap = jsonDecode(response.body);

      var arr = tmap['data']['data']?.map((v) => v).toList();

      _controller.setTransactions(arr);
      // _controller.setRecentTransactions(arr);
      _controller.setHasMoreTransactions(
          tmap['data']['next_page_url'] == null ? false : true);
    } else {
      throw Exception("Failed to get transactions");
    }
  }

  fetchNextTransactions(String accessToken, int currentPage) async {
    final response = await client.get(
      Uri.parse(
          '${Constants.baseURL}backend/user/transactions?page=$currentPage'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
    );

    debugPrint("RESPONSE -> TRANSACTION :: ${response.body}");

    _controller.setSpinning(false);

    if (response.statusCode == 200) {
      Map<String, dynamic> tmap = jsonDecode(response.body);

      var arr = tmap['data']['data']?.map((v) => v).toList();
      _controller.setHasMoreTransactions(
          tmap['data']['next_page_url'] == null ||
                  tmap['data']['next_page_url']?.isEmpty
              ? false
              : true);

      _controller.setTransactions(arr);
    } else {
      throw Exception("Failed to get transactions");
    }
  }

  Future<http.Response> startTransaction(Map body, String accessToken) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}backend/user/transaction'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> transactionWallet(Map body, String accessToken) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}backend/user/transaction'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
      body: jsonEncode(body),
    );
  }

  Future cancelTransaction(String accessToken, transRef) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}backend/transaction/$transRef/cancel'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
    );
  }

  Future<http.Response> guestBuy(Map body) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}backend/anonymous/buy'),
      headers: {
        "Content-type": "application/json",
        // "Authorization": "Bearer " + accessToken,
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> guestTransaction(Map body) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}backend/anonymous/transaction'),
      headers: {
        "Content-type": "application/json",
        // "Authorization": "Bearer " + accessToken,
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> guestPayment(Map body) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}backend/anonymous/transaction/payment'),
      headers: {
        "Content-type": "application/json",
        // "Authorization": "Bearer " + accessToken,
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> payment(Map body, String accessToken) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}backend/user/transaction/payment'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> updateProfile(Map body, String accessToken) async {
    return await client.put(
      Uri.parse('${Constants.baseURL}backend/user/profile'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> kyc(Map body, String accessToken) async {
    return await client.put(
      Uri.parse('${Constants.baseURL}backend/user/kyc'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> updatePassword(Map body, String accessToken) async {
    return await client.put(
      Uri.parse('${Constants.baseURL}backend/user/password'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> fundWalletRequest(Map body, String accessToken) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}backend/user/fund_wallet_request'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.MultipartRequest> fundWalletRequest2(
      {required accessToken}) async {
    var req = http.MultipartRequest(
      "POST",
      Uri.parse('${Constants.baseURL}backend/user/fund_wallet_request'),
    );

    req.headers['Content-type'] = "application/json";
    req.headers['Authorization'] = "Bearer " + accessToken;
    req.headers['HTTP-REQUEST-SOURCE'] = "mobile:${_controller.appVersion.value}";

    return req;
  }

  Future<http.Response> airtimeCash(String accessToken) async {
    return await client.get(
      Uri.parse('${Constants.baseURL}backend/init?section=airtime_to_cash'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
    );
  }

  Future<http.Response> airtimeCashRequest(Map body, String accessToken) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}backend/transaction/airtime-to-cash'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> generateVirtualAccount(String accessToken) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}backend/user/virtual_account'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
        "HTTP-REQUEST-SOURCE": "mobile:${_controller.appVersion.value}",
      },
    );
  }
}
