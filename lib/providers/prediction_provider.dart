import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/crypto_models.dart';

class PredictionProvider extends ChangeNotifier {
  List<CryptoData> _cryptos = [];
  PredictionResult? _currentPrediction;
  bool _isLoading = false;
  bool _isPredicting = false;
  String _error = '';

  List<CryptoData> get cryptos => _cryptos;
  PredictionResult? get currentPrediction => _currentPrediction;
  bool get isLoading => _isLoading;
  bool get isPredicting => _isPredicting;
  String get error => _error;

  Future<void> loadCryptos() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Sample crypto data with price history
      _cryptos = [
        CryptoData(
          symbol: 'BTC',
          name: 'Bitcoin',
          currentPrice: 45000.00,
          changePercent24h: 2.45,
          marketCap: 850000000000,
          volume24h: 25000000000,
          iconUrl: '',
          priceHistory: _generatePriceHistory(45000, 30),
        ),
        CryptoData(
          symbol: 'ETH',
          name: 'Ethereum',
          currentPrice: 3200.00,
          changePercent24h: -1.23,
          marketCap: 380000000000,
          volume24h: 15000000000,
          iconUrl: '',
          priceHistory: _generatePriceHistory(3200, 30),
        ),
        CryptoData(
          symbol: 'ADA',
          name: 'Cardano',
          currentPrice: 1.25,
          changePercent24h: 5.67,
          marketCap: 40000000000,
          volume24h: 2000000000,
          iconUrl: '',
          priceHistory: _generatePriceHistory(1.25, 30),
        ),
        CryptoData(
          symbol: 'SOL',
          name: 'Solana',
          currentPrice: 95.50,
          changePercent24h: -3.21,
          marketCap: 45000000000,
          volume24h: 3500000000,
          iconUrl: '',
          priceHistory: _generatePriceHistory(95.50, 30),
        ),
      ];
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load crypto data: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  List<double> _generatePriceHistory(double currentPrice, int days) {
    final random = math.Random();
    final history = <double>[];
    double price = currentPrice * 0.9; // Start 10% lower
    
    for (int i = 0; i < days; i++) {
      // Random walk with slight upward bias
      final change = (random.nextDouble() - 0.45) * 0.1; // -5% to 5.5% daily change
      price = price * (1 + change);
      history.add(price);
    }
    
    return history;
  }

  Future<void> generatePrediction(CryptoData crypto, Duration timeframe) async {
    _isPredicting = true;
    _currentPrediction = null;
    notifyListeners();

    try {
      // Simulate AI prediction processing
      await Future.delayed(const Duration(seconds: 3));
      
      final random = math.Random();
      final changePercent = (random.nextDouble() - 0.5) * 20; // -10% to +10%
      final predictedPrice = crypto.currentPrice * (1 + changePercent / 100);
      
      String trend;
      if (changePercent > 2) {
        trend = 'bullish';
      } else if (changePercent < -2) {
        trend = 'bearish';
      } else {
        trend = 'neutral';
      }
      
      _currentPrediction = PredictionResult(
        cryptoSymbol: crypto.symbol,
        currentPrice: crypto.currentPrice,
        predictedPrice: predictedPrice,
        confidence: 0.6 + (random.nextDouble() * 0.3), // 60-90% confidence
        timeframe: timeframe,
        timestamp: DateTime.now(),
        trend: trend,
        factors: {
          'technical_analysis': random.nextDouble() * 100,
          'market_sentiment': random.nextDouble() * 100,
          'volume_analysis': random.nextDouble() * 100,
          'social_signals': random.nextDouble() * 100,
        },
      );
      
      _isPredicting = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to generate prediction: $e';
      _isPredicting = false;
      notifyListeners();
    }
  }

  Future<void> refreshData() async {
    await loadCryptos();
  }

  void clearPrediction() {
    _currentPrediction = null;
    notifyListeners();
  }
}
