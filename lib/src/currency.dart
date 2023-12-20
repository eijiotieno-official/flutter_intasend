// Enumeration representing different currencies
enum Currency { kes, usd, eur, gbp }

// Function to convert a string to a Currency enum value
Currency enumCurrency({required String string}) => Currency.values
    .firstWhere((e) => e.toString().split('.').last == string.toLowerCase());

// Function to convert a Currency enum value to its string representation
String enumStringCurrency({required Currency currency}) => currency
    .toString()
    .substring(currency.toString().indexOf('.') + 1)
    .toUpperCase();
