import 'package:flutter/material.dart';
import 'package:flutter_intasend/src/api.dart';
import 'package:flutter_intasend/src/currency.dart';

// Import the IntasendWebView class
import 'intasend_webview.dart';

// Class for handling Intasend functionalities in Flutter
class FlutterIntasend {
  // Static method to initialize the checkout process
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
    // Call the IntasendAPI to create a checkout
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
        // If the result is not empty, extract the URL and navigate to IntasendWebView
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
