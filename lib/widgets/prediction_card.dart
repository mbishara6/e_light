import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/crypto_models.dart';
//import '../utils/app_colors.dart';

class PredictionCard extends StatelessWidget {
  final PredictionResult prediction;

  const PredictionCard({super.key, required this.prediction});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'AI Prediction for ${prediction.cryptoSymbol}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: prediction.trendColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    prediction.trend.toUpperCase(),
                    style: TextStyle(
                      color: prediction.trendColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Price Prediction
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Price',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      prediction.formattedCurrentPrice,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.grey[400],
                  size: 32,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Predicted Price',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      prediction.formattedPredictedPrice,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: prediction.trendColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Change Percentage
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: prediction.trendColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Expected Change',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    prediction.formattedChange,
                    style: TextStyle(
                      color: prediction.trendColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Confidence and Timeframe
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Confidence Level',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          prediction.confidenceLevel,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _getConfidenceColor(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${(prediction.confidence * 100).toStringAsFixed(0)}%)',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Timeframe',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTimeframe(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Analysis Factors
            const Text(
              'Analysis Factors',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...prediction.factors.entries.map((entry) {
              final value = entry.value as double;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatFactorName(entry.key),
                      style: const TextStyle(fontSize: 14),
                    ),
                    Container(
                      width: 100,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: value / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _getFactorColor(value),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    ).animate().scale(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
    ).fadeIn();
  }

  Color _getConfidenceColor() {
    if (prediction.confidence >= 0.8) return Colors.green;
    if (prediction.confidence >= 0.6) return Colors.orange;
    return Colors.red;
  }

  String _formatTimeframe() {
    final hours = prediction.timeframe.inHours;
    if (hours < 24) {
      return '${hours}h';
    } else {
      final days = prediction.timeframe.inDays;
      return '${days}d';
    }
  }

  String _formatFactorName(String key) {
    return key.split('_').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  Color _getFactorColor(double value) {
    if (value >= 70) return Colors.green;
    if (value >= 40) return Colors.orange;
    return Colors.red;
  }
}
