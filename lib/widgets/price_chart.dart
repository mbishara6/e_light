import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/crypto_models.dart';

class PriceChart extends StatefulWidget {
  final CryptoData crypto;
  
  const PriceChart({super.key, required this.crypto});

  @override
  State<PriceChart> createState() => _PriceChartState();
}

class _PriceChartState extends State<PriceChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * _animation.value),
          child: Opacity(
            opacity: _animation.value,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Hero(
                          tag: 'chart_title_${widget.crypto.symbol}',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              '${widget.crypto.name} (${widget.crypto.symbol})',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.crypto.isPositiveChange ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '30 Days',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 1500),
                        tween: Tween(begin: 0, end: 1),
                        curve: Curves.easeInOut,
                        builder: (context, animationValue, child) {
                          return LineChart(
                            LineChartData(
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: _calculateInterval(),
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    interval: 5,
                                    getTitlesWidget: (value, meta) {
                                      const style = TextStyle(fontSize: 10, color: Colors.grey);
                                      if (value.toInt() % 10 == 0) {
                                        return SideTitleWidget(
                                           meta: meta,
                                          child: Text('${30 - value.toInt()}d', style: style),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 45,
                                    interval: _calculateInterval(),
                                    getTitlesWidget: (value, meta) {
                                      const style = TextStyle(fontSize: 10, color: Colors.grey);
                                      return SideTitleWidget(
                                          meta: meta,
                                        child: Text(_formatPrice(value), style: style),
                                    
                                      );
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border.all(
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: _generateSpotsAnimated(animationValue),
                                  isCurved: true,
                                  color: theme.colorScheme.primary,
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: const FlDotData(show: false),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        theme.colorScheme.primary.withValues(alpha: 0.3),
                                        theme.colorScheme.primary.withValues(alpha: 0.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              minX: 0,
                              maxX: widget.crypto.priceHistory.length.toDouble() - 1,
                              minY: _getMinPrice() * 0.98,
                              maxY: _getMaxPrice() * 1.02,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 800),
                      tween: Tween(begin: 0, end: 1),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem('Min', _getMinPrice(), Colors.red),
                              _buildStatItem('Max', _getMaxPrice(), Colors.green),
                              _buildStatItem('Avg', _getAvgPrice(), Colors.blue),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  List<FlSpot> _generateSpotsAnimated(double animationValue) {
    final totalSpots = widget.crypto.priceHistory.length;
    final visibleSpots = (totalSpots * animationValue).round();
    
    return widget.crypto.priceHistory
        .asMap()
        .entries
        .take(visibleSpots)
        .map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();
  }
  
  double _getMinPrice() {
    return widget.crypto.priceHistory.reduce((a, b) => a < b ? a : b);
  }
  
  double _getMaxPrice() {
    return widget.crypto.priceHistory.reduce((a, b) => a > b ? a : b);
  }
  
  double _getAvgPrice() {
    return widget.crypto.priceHistory.reduce((a, b) => a + b) / widget.crypto.priceHistory.length;
  }
  
  double _calculateInterval() {
    final range = _getMaxPrice() - _getMinPrice();
    return range / 5; // 5 horizontal lines
  }
  
  String _formatPrice(double price) {
    if (price >= 1000) {
      return '\$${(price / 1000).toStringAsFixed(1)}k';
    } else if (price >= 1) {
      return '\$${price.toStringAsFixed(0)}';
    } else {
      return '\$${price.toStringAsFixed(3)}';
    }
  }
  
  Widget _buildStatItem(String label, double value, Color color) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0, end: value),
      builder: (context, animatedValue, child) {
        return Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatPrice(animatedValue),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        );
      },
    );
  }
}
