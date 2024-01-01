class CryptocurrencyData {
  final bool status;
  final String message;
  final List<CryptocurrencyRecord> data;

  CryptocurrencyData(
      {required this.status, required this.message, required this.data});

  factory CryptocurrencyData.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<CryptocurrencyRecord> dataList =
        list.map((i) => CryptocurrencyRecord.fromJson(i)).toList();
    return CryptocurrencyData(
      status: json['status'],
      message: json['message'],
      data: dataList,
    );
  }
}

class CryptocurrencyRecord {
  final int id;
  final String symbol;
  final String? name;
  final String? icon;
  final int? decimal;
  late double? circulatingSupply;
  late double? totalSupply;
  late double? maxSupply;
  late double price;
  late double marketCap;
  late PriceChangeData? priceChange1d;
  late PriceChangeData? priceChange1h;
  late PriceChangeData? priceChange7d;
  late bool? isLastPriceUp;

  CryptocurrencyRecord({
    required this.id,
    required this.symbol,
    this.name,
    this.icon,
    this.decimal,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    required this.price,
    required this.marketCap,
    this.priceChange1d,
    this.priceChange1h,
    this.priceChange7d,
    this.isLastPriceUp,
  });

  factory CryptocurrencyRecord.fromJson(Map<String, dynamic> json) {
    return CryptocurrencyRecord(
      id: json["id"],
      symbol: json['symbol'],
      name: json['name'],
      icon: json['icon'],
      decimal: json['decimal'],
      circulatingSupply: json['circulating_supply']?.toDouble(),
      totalSupply: json['total_supply']?.toDouble(),
      maxSupply: json['max_supply']?.toDouble(),
      price: json['price'].toDouble(),
      marketCap: json['market_cap'].toDouble(),
      priceChange1d:
          json['1d'] != null ? PriceChangeData.fromJson(json['1d']) : null,
      priceChange1h:
          json['1h'] != null ? PriceChangeData.fromJson(json['1h']) : null,
      priceChange7d:
          json['7d'] != null ? PriceChangeData.fromJson(json['7d']) : null,
      isLastPriceUp: json["is_last_price_up"],
    );
  }
}

class PriceChangeData {
  late double priceChange;
  late double priceChangePercent;
  late double? openPrice;
  late double? highPrice;
  late double? lowPrice;
  late double? volume;

  PriceChangeData({
    required this.priceChange,
    required this.priceChangePercent,
    this.openPrice,
    this.highPrice,
    this.lowPrice,
    this.volume,
  });

  factory PriceChangeData.fromJson(Map<String, dynamic> json) {
    return PriceChangeData(
      priceChange: json['price_change'].toDouble(),
      priceChangePercent: json['price_change_percent'].toDouble(),
      openPrice: json['open_price']?.toDouble(),
      highPrice: json['high_price']?.toDouble(),
      lowPrice: json['low_price']?.toDouble(),
      volume: json['volume']?.toDouble(),
    );
  }
}
