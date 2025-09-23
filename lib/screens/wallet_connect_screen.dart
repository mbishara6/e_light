import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/web3_provider.dart';

class WalletConnectScreen extends StatefulWidget {
  const WalletConnectScreen({super.key});

  @override
  State<WalletConnectScreen> createState() => _WalletConnectScreenState();
}

class _WalletConnectScreenState extends State<WalletConnectScreen> {
  final _privateKeyController = TextEditingController();
  bool _isPrivateKeyVisible = false;

  @override
  void dispose() {
    _privateKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withValues(alpha:  0.1),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  size: 60,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 32),

              // Title
              const Text(
                'Connect to BlockDAG',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              const Text(
                'Enter your private key to connect to the BlockDAG Testnet and start making crypto predictions',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),

              // Network info card
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildNetworkInfoRow('Network', 'BlockDAG Testnet'),
                      const SizedBox(height: 8),
                      _buildNetworkInfoRow('Chain ID', '1043'),
                      const SizedBox(height: 8),
                      _buildNetworkInfoRow('Currency', 'BDAG'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Private key input
              TextField(
                controller: _privateKeyController,
                obscureText: !_isPrivateKeyVisible,
                decoration: InputDecoration(
                  labelText: 'Private Key',
                  hintText: 'Enter your wallet private key',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPrivateKeyVisible ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPrivateKeyVisible = !_isPrivateKeyVisible;
                      });
                    },
                  ),
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 24),

              // Connect button
              Consumer<Web3Provider>(
                builder: (context, web3Provider, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: web3Provider.isLoading ? null : _connectWallet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: web3Provider.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'Connect Wallet',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Error message
              Consumer<Web3Provider>(
                builder: (context, web3Provider, child) {
                  if (web3Provider.errorMessage != null) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha:  0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        web3Provider.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 24),

              // Security warning
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Never share your private key. This app stores it locally and securely.',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNetworkInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Future<void> _connectWallet() async {
    final privateKey = _privateKeyController.text.trim();

    if (privateKey.isEmpty) {
      _showErrorSnackBar('Please enter your private key');
      return;
    }

    if (privateKey.length != 64 && !privateKey.startsWith('0x')) {
      _showErrorSnackBar('Private key must be 64 characters long');
      return;
    }

    final web3Provider = context.read<Web3Provider>();
    final success = await web3Provider.connectWallet(privateKey);

    if (success) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/navigation');
      }
    } else {
      _showErrorSnackBar('Failed to connect wallet. Please check your private key.');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}