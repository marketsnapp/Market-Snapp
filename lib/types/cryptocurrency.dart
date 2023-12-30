class CryptocurrencyData {
  final bool status;
  final String message;
  final List<CryptoRecord> data;

  CryptocurrencyData(
      {required this.status, required this.message, required this.data});

  factory CryptocurrencyData.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<CryptoRecord> dataList =
        list.map((i) => CryptoRecord.fromJson(i)).toList();
    return CryptocurrencyData(
      status: json['status'],
      message: json['message'],
      data: dataList,
    );
  }
}

class CryptoRecord {
  final String symbol;
  final String name;
  final String icon;
  final int decimal;
  final double circulatingSupply;
  final double totalSupply;
  final double maxSupply;
  final double price;
  final double marketCap;
  final double priceChange;
  final double priceChangePercent;
  final double openPrice;
  final double highPrice;
  final double lowPrice;
  final double volume;
  final bool? isLastPriceUp;

  CryptoRecord({
    required this.symbol,
    required this.name,
    required this.icon,
    required this.decimal,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.maxSupply,
    required this.price,
    required this.marketCap,
    required this.priceChange,
    required this.priceChangePercent,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.volume,
    this.isLastPriceUp,
  });

  factory CryptoRecord.fromJson(Map<String, dynamic> json) {
    return CryptoRecord(
      symbol: json['symbol'],
      name: json['name'],
      icon: json['icon'],
      decimal: json['decimal'],
      circulatingSupply: json['circulating_supply'].toDouble(),
      totalSupply: json['total_supply'].toDouble(),
      maxSupply: json['max_supply'].toDouble(),
      price: json['price'].toDouble(),
      marketCap: json["market_cap"].toDouble(),
      priceChange: json["price_change"].toDouble(),
      priceChangePercent: json["price_change_percent"].toDouble(),
      openPrice: json["open_price"].toDouble(),
      highPrice: json["high_price"].toDouble(),
      lowPrice: json["low_price"].toDouble(),
      volume: json["volume"].toDouble(),
      isLastPriceUp: json['is_last_price_up'],
    );
  }
}
