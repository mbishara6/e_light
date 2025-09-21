import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/web3_provider.dart';
import '../widgets/prediction_card.dart';
import '../widgets/create_prediction_dialog.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Web3Provider>().refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Predictions'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<Web3Provider>().refreshData(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showDisconnectDialog(context),
          ),
        ],
      ),
      body: Consumer<Web3Provider>(
        builder: (context, web3Provider, child) {
          if (!web3Provider.isConnected) {
            return const Center(
              child: Text(
                'Please connect your wallet',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          if (web3Provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: web3Provider.refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWalletInfo(web3Provider),
                  const SizedBox(height: 24),
                  _buildStatsCards(web3Provider),
                  const SizedBox(height: 24),
                  _buildPredictionsSection(web3Provider),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Consumer<Web3Provider>(
        builder: (context, web3Provider, child) {
          if (!web3Provider.isConnected) return const SizedBox.shrink();

          return FloatingActionButton.extended(
            onPressed: () => _showCreatePredictionDialog(context),
            backgroundColor: Colors.deepPurple,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'New Prediction',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWalletInfo(Web3Provider web3Provider) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                 Icon(Icons.account_balance_wallet, color: Colors.deepPurple),
                 SizedBox(width: 8),
                 Text(
                  'Wallet Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Address: ${web3Provider.userAddress ?? 'Unknown'}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Balance: ${web3Provider.formattedBalance}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards(Web3Provider web3Provider) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Predictions',
            web3Provider.totalPredictions.toString(),
            Icons.bar_chart,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Win Rate',
            '${web3Provider.winRate.toStringAsFixed(1)}%',
            Icons.trending_up,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Active',
            web3Provider.activePredictions.length.toString(),
            Icons.access_time,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionsSection(Web3Provider web3Provider) {
    if (web3Provider.userPredictions.isEmpty) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Icon(
              Icons.psychology,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No predictions yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first prediction to get started',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Predictions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: web3Provider.userPredictions.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final prediction = web3Provider.userPredictions[index];
            return PredictionCard(prediction: prediction);
          },
        ),
      ],
    );
  }

  void _showCreatePredictionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreatePredictionDialog(),
    );
  }

  void _showDisconnectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disconnect Wallet'),
        content: const Text('Are you sure you want to disconnect your wallet?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<Web3Provider>().disconnect();
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/connect');
            },
            child: const Text('Disconnect'),
          ),
        ],
      ),
    );
  }
}