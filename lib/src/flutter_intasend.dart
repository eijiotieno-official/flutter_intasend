import 'package:flutter/material.dart';
import 'package:flutter_intasend/src/api.dart';
import 'package:flutter_intasend/src/currency.dart';

import 'intasend_webview.dart';

class FlutterIntasend {
  static Future initCheckOut({
    required BuildContext context,
    required bool isTest,
    required String publicKey,
    required Currency currency,
    required double amount,
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    
    await IntasendAPI.createCheckOut(
      isTest: isTest,
      publicKey: publicKey,
      currency: currency,
      amount: amount,
      firstName: firstName,
      lastName: lastName,
      email: email,
    ).then(
      (result) {
        debugPrint("RESULT $result");
        if (result.isNotEmpty) {
          String url = result['url'];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IntasendWebView(url: url),
            ),
          );
        }
      },
    );
  }
}
