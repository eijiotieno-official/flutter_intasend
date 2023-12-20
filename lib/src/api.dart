import 'package:flutter_intasend/src/utils.dart';

import 'currency.dart';

class IntasendAPI {
  static Future<Map<String, dynamic>> createCheckOut({
    required bool isTest,
    required String publicKey,
    required Currency currency,
    required double amount,
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    final Map<String, dynamic> payload = {
      "public_key": publicKey,
      "currency": enumStringCurrency(currency: currency),
      "email": email,
      "amount": amount,
      "first_name": firstName,
      "last_name": lastName,
    };

    return await sendPostRequest(
      endPoint: "checkout/",
      payload: payload,
      publicKey: publicKey,
      test: isTest,
    );
  }

  // static Future<Map<String, dynamic>> sendSTKPush({
  //   required bool isTest,
  //   required String publicKey,
  //   required String phoneNumber,
  //   required double amount,
  //   required String narrative,
  // }) async {
  //   final Map<String, dynamic> payload = {
  //     'amount': amount,
  //     'phone_number': phoneNumber,
  //     'narrative': narrative
  //   };

  //   Map<String, dynamic> result = {};

  //   sendPostRequest(
  //     endPoint: "send-mpesa-stk-push/",
  //     payload: payload,
  //     publicKey: publicKey,
  //     test: isTest,
  //   ).then((value) => result = value);

  //   return result;
  // }
}
