class Holding {
  final BigInt id;
  final int portfolioId;
  final int cryptocurrencyId;
  final double amount;
  final double averagePurchasePrice;
  double profit;
  double currentValue;
  double totalBuyValue;

  Holding({
    required this.id,
    required this.portfolioId,
    required this.cryptocurrencyId,
    required this.amount,
    required this.averagePurchasePrice,
    this.profit = 0.0,
    this.currentValue = 0.0,
    this.totalBuyValue = 0.0,
  });

  void calculateValues(double price) {
    totalBuyValue = averagePurchasePrice * amount;
    currentValue = price * amount;
    profit = (price - averagePurchasePrice) * amount;
  }

  factory Holding.fromJson(Map<String, dynamic> json) {
    return Holding(
      id: BigInt.parse(json['id'].toString()),
      portfolioId: json['portfolio_id'],
      cryptocurrencyId: json['cryptocurrency_id'],
      amount: json['amount'].toDouble(),
      averagePurchasePrice: json['average_purchase_price'].toDouble(),
    );
  }
}

class Portfolio {
  List<Holding> holdings;

  Portfolio({required this.holdings});

  factory Portfolio.fromJson(List<dynamic> jsonList) {
    List<Holding> holdings =
        jsonList.map((json) => Holding.fromJson(json)).toList();

    return Portfolio(holdings: holdings);
  }
}
