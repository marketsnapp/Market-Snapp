import 'package:intl/intl.dart';

String formatMoney(double amount, [bool isMoney = true]) {
  String format(double amt, String suffix) {
    return '${isMoney ? '\$' : ''}${amt.toStringAsFixed(2)}$suffix';
  }

  if (amount >= 1e12) {
    return format(amount / 1e12, 'T');
  } else if (amount >= 1e9) {
    return format(amount / 1e9, 'B');
  } else if (amount >= 1e6) {
    return format(amount / 1e6, 'M');
  } else if (amount >= 1e3) {
    return format(amount / 1e3, 'K');
  } else {
    return format(amount, '');
  }
}

String formatCurrency(double amount, int decimal) {
  final NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: decimal,
  );
  return currencyFormatter.format(amount);
}
