import 'package:marketsnapp/types/cryptocurrency.dart';

PriceChangeData? getPriceChangeData(
    CryptocurrencyRecord cryptocurrency, String windowSize) {
  switch (windowSize) {
    case "1 Hour":
      return cryptocurrency.priceChange1h;
    case "24 Hours":
      return cryptocurrency.priceChange1d;
    case "7 Days":
      return cryptocurrency.priceChange7d;
    default:
      return cryptocurrency.priceChange1d;
  }
}
