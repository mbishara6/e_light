import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/web3_provider.dart';
import '../config/network_config.dart';

class CreatePredictionScreen extends StatefulWidget {
  const CreatePredictionScreen({super.key});

  @override
  State<CreatePredictionScreen> createState() => _CreatePredictionScreenState();
}

class _CreatePredictionScreenState extends State<CreatePredictionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tokenAddressController = TextEditingController();
  final _currentPriceController = TextEditingController();
  final _predictedPriceController = TextEditingController();
  final _stakeAmountController = TextEditingController();

  int _selectedDurationIndex = 0;
  final List<Duration> _durations = [
    const Duration(hours: 1),
    const Duration(hours: 6),
    const Duration(hours: 12),
    const Duration(days: 1),
    const Duration(days: 3),
    const Duration(days: 7),
    const Duration(days: 30),
  ];

  final List<String> _durationLabels = [
    '1 Hour',
    '6 Hours',
    '12 Hours',
    '1 Day',
    '3 Days',
    '1 Week',
    '1 Month',
  ];

  @override
  void initState() {
    super.initState();
    // Set default token address to ETH (zero address for native token)
    _tokenAddressController.text = '0x0000000000000000000000000000000000000000';
  }

  @override
  void dispose() {
    _tokenAddressController.dispose();
    _currentPriceController.dispose();
    _predictedPriceController.dispose();
    _stakeAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Prediction'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTokenAddressField(),
                const SizedBox(height: 16),
                _buildPriceFields(),
                const SizedBox(height: 16),
                _buildDurationSelector(),
                const SizedBox(height: 16),
                _buildStakeAmountField(),
                const SizedBox(height: 16),
                _buildPredictionSummary(),
                const SizedBox(height: 24),
                _buildCreateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTokenAddressField() {
    return TextFormField(
      controller: _tokenAddressController,
      decoration: const InputDecoration(
        labelText: 'Token Address',
        hintText: '0x... (Use 0x000...000 for ETH)',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.token),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter token address';
        }
        if (!value.startsWith('0x') || value.length != 42) {
          return 'Invalid address format';
        }
        return null;
      },
    );
  }

  Widget _buildPriceFields() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _currentPriceController,
            decoration: const InputDecoration(
              labelText: 'Current Price',
              hintText: '0.00',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              if (double.tryParse(value) == null || double.parse(value) <= 0) {
                return 'Invalid price';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: _predictedPriceController,
            decoration: const InputDecoration(
              labelText: 'Predicted Price',
              hintText: '0.00',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.trending_up),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              if (double.tryParse(value) == null || double.parse(value) <= 0) {
                return 'Invalid price';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Duration',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _durationLabels.asMap().entries.map((entry) {
            final index = entry.key;
            final label = entry.value;
            final isSelected = _selectedDurationIndex == index;
            
            return ChoiceChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedDurationIndex = index;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStakeAmountField() {
    return TextFormField(
      controller: _stakeAmountController,
      decoration: const InputDecoration(
        labelText: 'Stake Amount (BDAG)',
        hintText: '0.00',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.account_balance_wallet),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter stake amount';
        }
        if (double.tryParse(value) == null || double.parse(value) <= 0) {
          return 'Invalid stake amount';
        }
        return null;
      },
    );
  }

  Widget _buildPredictionSummary() {
    final currentPrice = double.tryParse(_currentPriceController.text) ?? 0;
    final predictedPrice = double.tryParse(_predictedPriceController.text) ?? 0;
    final stakeAmount = double.tryParse(_stakeAmountController.text) ?? 0;
    final potentialReward = stakeAmount * rewardMultiplier;
    
    if (currentPrice == 0 || predictedPrice == 0 || stakeAmount == 0) {
      return const SizedBox.shrink();
    }

    final priceChangePercent = ((predictedPrice - currentPrice) / currentPrice) * 100;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Prediction Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildSummaryRow('Duration:', _durationLabels[_selectedDurationIndex]),
            _buildSummaryRow('Price Change:', '${priceChangePercent >= 0 ? '+' : ''}${priceChangePercent.toStringAsFixed(2)}%'),
            _buildSummaryRow('Stake Amount:', '${stakeAmount.toStringAsFixed(4)} BDAG'),
            _buildSummaryRow('Potential Reward:', '${potentialReward.toStringAsFixed(4)} BDAG'),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCreateButton() {
    return Consumer<Web3Provider>(
      builder: (context, web3Provider, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: web3Provider.isLoading ? null : _createPrediction,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: web3Provider.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'Create Prediction',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        );
      },
    );
  }

  Future<void> _createPrediction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final web3Provider = context.read<Web3Provider>();
    
    final success = await web3Provider.createPrediction(
      tokenAddress: _tokenAddressController.text,
      currentPrice: double.parse(_currentPriceController.text),
      predictedPrice: double.parse(_predictedPriceController.text),
      duration: _durations[_selectedDurationIndex],
      stakeAmount: double.parse(_stakeAmountController.text),
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Prediction created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // Clear form
      _tokenAddressController.clear();
      _currentPriceController.clear();
      _predictedPriceController.clear();
      _stakeAmountController.clear();
      setState(() {
        _selectedDurationIndex = 0;
      });
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(web3Provider.errorMessage ?? 'Failed to create prediction'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}