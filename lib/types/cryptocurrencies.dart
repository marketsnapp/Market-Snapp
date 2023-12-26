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
  final int id;
  final String symbol;
  final String name;
  final String icon;
  final int decimal;
  final double circulatingSupply;
  final double totalSupply;
  final double maxSupply;
  final double price;

  CryptoRecord({
    required this.id,
    required this.symbol,
    required this.name,
    required this.icon,
    required this.decimal,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.maxSupply,
    required this.price,
  });

  factory CryptoRecord.fromJson(Map<String, dynamic> json) {
    return CryptoRecord(
      id: json['id'],
      symbol: json['symbol'],
      name: json['name'],
      icon: json['icon'],
      decimal: json['decimal'],
      circulatingSupply: json['circulating_supply'].toDouble(),
      totalSupply: json['total_supply'].toDouble(),
      maxSupply: json['max_supply'].toDouble(),
      price: json['price'].toDouble(),
    );
  }
}
