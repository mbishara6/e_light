import 'package:flutter/material.dart';

class CryptoData {
  final String symbol;
  final String name;
  final double currentPrice;
  final double changePercent24h;
  final double marketCap;
  final double volume24h;
  final String iconUrl;
  final List<double> priceHistory; // Changed to List<double> for chart compatibility

  CryptoData({
    required this.symbol,
    required this.name,
    required this.currentPrice,
    required this.changePercent24h,
    required this.marketCap,
    required this.volume24h,
    required this.iconUrl,
    required this.priceHistory,
  });

  bool get isPositiveChange => changePercent24h >= 0;

  String get formattedPrice => '\$${currentPrice.toStringAsFixed(2)}';
  
  String get formattedChange => '${changePercent24h >= 0 ? '+' : ''}${changePercent24h.toStringAsFixed(2)}%';
  
  String get formattedMarketCap {
    if (marketCap >= 1e9) {
      return '\$${(marketCap / 1e9).toStringAsFixed(2)}B';
    } else if (marketCap >= 1e6) {
      return '\$${(marketCap / 1e6).toStringAsFixed(2)}M';
    } else {
      return '\$${marketCap.toStringAsFixed(2)}';
    }
  }
}

class PricePoint {
  final DateTime timestamp;
  final double price;

  PricePoint({
    required this.timestamp,
    required this.price,
  });
}

class PredictionResult {
  final String cryptoSymbol;
  final double currentPrice;
  final double predictedPrice;
  final double confidence;
  final Duration timeframe;
  final DateTime timestamp;
  final String trend; // 'bullish', 'bearish', 'neutral'
  final Map<String, dynamic> factors;

  PredictionResult({
    required this.cryptoSymbol,
    required this.currentPrice,
    required this.predictedPrice,
    required this.confidence,
    required this.timeframe,
    required this.timestamp,
    required this.trend,
    required this.factors,
  });

  double get changePercent {
    return ((predictedPrice - currentPrice) / currentPrice) * 100;
  }

  String get formattedChange {
    return '${changePercent >= 0 ? '+' : ''}${changePercent.toStringAsFixed(2)}%';
  }

  String get formattedPredictedPrice => '\$${predictedPrice.toStringAsFixed(2)}';
  
  String get formattedCurrentPrice => '\$${currentPrice.toStringAsFixed(2)}';
  
  String get confidenceLevel {
    if (confidence >= 0.8) return 'High';
    if (confidence >= 0.6) return 'Medium';
    return 'Low';
  }
  
  Color get trendColor {
    switch (trend) {
      case 'bullish':
        return const Color(0xFF00B894);
      case 'bearish':
        return const Color(0xFFFF6B6B);
      default:
        return const Color(0xFF8B949E);
    }
  }
}
