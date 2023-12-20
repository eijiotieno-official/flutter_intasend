enum Currency { kes, usd, eur, gbp }

Currency enumCurrency({required String string}) => Currency.values
    .firstWhere((e) => e.toString().split('.').last == string.toLowerCase());

String enumStringCurrency({required Currency currency}) => currency
    .toString()
    .substring(currency.toString().indexOf('.') + 1)
    .toUpperCase();
