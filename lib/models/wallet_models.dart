class WalletCard {
  final String id;
  final String name;
  final String number;
  final String expiryDate;
  final String cvv;
  final double balance;
  final String currency;
  final String type; // 'visa', 'mastercard', 'amex'
  final List<int> gradientColors;

  WalletCard({
    required this.id,
    required this.name,
    required this.number,
    required this.expiryDate,
    required this.cvv,
    required this.balance,
    required this.currency,
    required this.type,
    required this.gradientColors,
  });

  String get maskedNumber {
    return '**** **** **** ${number.substring(number.length - 4)}';
  }

  String get formattedBalance {
    return '$currency ${balance.toStringAsFixed(2)}';
  }
}

class Transaction {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final String type; // 'income', 'expense', 'transfer'
  final String category;
  final String icon;

  Transaction({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
    required this.icon,
  });

  String get formattedAmount {
    final prefix = type == 'income' ? '+' : '-';
    return '$prefix\$${amount.toStringAsFixed(2)}';
  }
}

class CryptoAsset {
  final String id;
  final String name;
  final String symbol;
  final double amount;
  final double price;
  final double changePercent;
  final String icon;

  CryptoAsset({
    required this.id,
    required this.name,
    required this.symbol,
    required this.amount,
    required this.price,
    required this.changePercent,
    required this.icon,
  });

  double get totalValue => amount * price;
  
  String get formattedValue => '\$${totalValue.toStringAsFixed(2)}';
  
  String get formattedChange => '${changePercent >= 0 ? '+' : ''}${changePercent.toStringAsFixed(2)}%';
}
