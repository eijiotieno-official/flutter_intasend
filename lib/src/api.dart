import 'package:flutter_intasend/src/utils.dart';

// Import the Currency class
import 'currency.dart';

// Class for interacting with the Intasend API
class IntasendAPI {
  // Method to create a checkout
  static Future<Map<String, dynamic>> createCheckOut({
    required bool isTest,
    required String publicKey,
    required Currency currency,
    required double amount,
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    // Prepare payload for the checkout request
    final Map<String, dynamic> payload = {
      "public_key": publicKey,
      "currency": enumStringCurrency(currency: currency),
      "email": email,
      "amount": amount,
      "first_name": firstName,
      "last_name": lastName,
    };

    // Send a POST request to the checkout endpoint using the utility function
    return await sendPostRequest(
      endPoint: "checkout/",
      payload: payload,
      publicKey: publicKey,
      test: isTest,
    );
  }
}
