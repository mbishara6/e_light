import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/prediction_model.dart';
import '../providers/prediction_provider.dart';
import '../models/crypto_models.dart';
import '../widgets/crypto_card.dart';
import '../widgets/prediction_card.dart';
import '../widgets/price_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Helper to convert PredictionResult to PredictionModel for display
  PredictionModel _convertToPredictionModel(PredictionResult result) {
    // Dummy conversion: fill with placeholder values for missing fields
    return PredictionModel(
      id: 0,
      user: '0x0000000000000000000000000000000000000000',
      token: '0x0000000000000000000000000000000000000000',
      currentPrice: BigInt.from(result.currentPrice),
      predictedPrice: BigInt.from(result.predictedPrice),
      timestamp: DateTime.now(),
      expiryTime: DateTime.now().add(const Duration(hours: 1)),
      stakeAmount: BigInt.from(0),
      isResolved: false,
      isCorrect: false,
    );
  }
  CryptoData? selectedCrypto;
  
  Duration selectedTimeframe = const Duration(hours: 24);
  
  final List<Duration> timeframes = [
    const Duration(hours: 1),
    const Duration(hours: 24),
    const Duration(days: 7),
  ];
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PredictionProvider>().loadCryptos();
    });
  }
  
  String _formatTimeframe(Duration duration) {
    if (duration.inHours < 24) {
      return '${duration.inHours}h';
    } else if (duration.inDays < 7) {
      return '${duration.inDays}d';
    } else {
      return '${duration.inDays}d';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Crypto Predictor'),
            Text(
              'AI-Powered Market Predictions',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PredictionProvider>().refreshData(),
          ),
        ],
      ),
      body: Consumer<PredictionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.cryptos.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading market data...'),
                ],
              ),
            );
          }
          
          if (provider.error.isNotEmpty && provider.cryptos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${provider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.refreshData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          return RefreshIndicator(
            onRefresh: () => provider.refreshData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Market Overview
                  _buildMarketOverview(provider),
                  const SizedBox(height: 24),
                  
                  // Crypto Selection
                  const Text(
                    'Select Cryptocurrency',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildCryptoList(provider),
                  
                  if (selectedCrypto != null) ...[ 
                    const SizedBox(height: 24),
                    
                    // Price Chart
                    const Text(
                      'Price History',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    PriceChart(crypto: selectedCrypto!),
                    const SizedBox(height: 24),
                    
                    // Prediction Controls
                    _buildPredictionControls(provider, theme),
                    const SizedBox(height: 24),
                    
                    // Prediction Result
                    if (provider.currentPrediction != null)
                      PredictionCard(prediction: _convertToPredictionModel(provider.currentPrediction!)),
                      
                    if (provider.isPredicting)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 2000),
                                tween: Tween(begin: 0, end: 1),
                                builder: (context, value, child) {
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: CircularProgressIndicator(
                                          value: value,
                                          strokeWidth: 6,
                                          backgroundColor: Colors.grey[300],
                                        ),
                                      ),
                                      Icon(
                                        Icons.psychology,
                                        size: 40,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                              TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 1000),
                                tween: Tween(begin: 0, end: 1),
                                builder: (context, value, child) {
                                  final messages = [
                                    'Analyzing market trends...',
                                    'Processing price data...',
                                    'Calculating confidence scores...',
                                    'Generating prediction...',
                                  ];
                                  final index = (value * (messages.length - 1)).floor();
                                  return AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 500),
                                    child: Text(
                                      messages[index],
                                      key: ValueKey(index),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildMarketOverview(PredictionProvider provider) {
    if (provider.cryptos.isEmpty) return const SizedBox.shrink();
    
    final totalMarketCap = provider.cryptos.fold(0.0, (sum, crypto) => sum + crypto.currentPrice);
    final positiveCount = provider.cryptos.where((c) => c.isPositiveChange).length;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Market Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Value', style: TextStyle(color: Colors.grey)),
                      Text(
                        '\$${NumberFormat('#,##0.00').format(totalMarketCap)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Positive', style: TextStyle(color: Colors.grey)),
                      Text(
                        '$positiveCount/${provider.cryptos.length}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: positiveCount > provider.cryptos.length / 2 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCryptoList(PredictionProvider provider) {
    return Column(
      children: provider.cryptos.asMap().entries.map((entry) {
        final index = entry.key;
        final crypto = entry.value;
        
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 100)),
          tween: Tween(begin: 0, end: 1),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: CryptoCard(
                  crypto: crypto,
                  isSelected: selectedCrypto?.symbol == crypto.symbol,
                  onTap: () {
                    setState(() {
                      selectedCrypto = crypto;
                    });
                    provider.clearPrediction();
                  },
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
  
  Widget _buildPredictionControls(PredictionProvider provider, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Generate Prediction',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            const Text('Select Timeframe:', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            
            Wrap(
              spacing: 8,
              children: timeframes.map((timeframe) {
                final isSelected = selectedTimeframe == timeframe;
                return ChoiceChip(
                  label: Text(_formatTimeframe(timeframe)),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        selectedTimeframe = timeframe;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            
            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: ElevatedButton.icon(
                  onPressed: provider.isPredicting ? null : () {
                    if (selectedCrypto != null) {
                      provider.generatePrediction(selectedCrypto!, selectedTimeframe);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: provider.isPredicting 
                        ? Colors.grey[400] 
                        : theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: provider.isPredicting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.psychology),
                  ),
                  label: Text(
                    provider.isPredicting ? 'Generating...' : 'Predict Price',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
