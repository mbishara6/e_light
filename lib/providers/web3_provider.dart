import 'package:flutter/foundation.dart';
import '../services/blockchain_services.dart';
import '../models/prediction_model.dart';
import '../config/network_config.dart';

class Web3Provider extends ChangeNotifier {
  final BlockchainService _blockchainService = BlockchainService();

  // State variables
  bool _isConnected = false;
  bool _isLoading = false;
  String? _userAddress;
  double? _balance;
  List<PredictionModel> _userPredictions = [];
  String? _errorMessage;

  // Getters
  bool get isConnected => _isConnected;
  bool get isLoading => _isLoading;
  String? get userAddress => _userAddress;
  double? get balance => _balance;
  List<PredictionModel> get userPredictions => _userPredictions;
  String? get errorMessage => _errorMessage;

  // Computed getters
  String get formattedBalance =>
  balance != null ? '${balance!.toStringAsFixed(4)} BDAG' : '0.0000 BDAG';

  List<PredictionModel> get activePredictions =>
      _userPredictions.where((p) => p.status == PredictionStatus.active).toList();

  List<PredictionModel> get resolvedPredictions =>
      _userPredictions.where((p) => p.isResolved).toList();

  int get totalPredictions => _userPredictions.length;
  int get wonPredictions => _userPredictions.where((p) => p.isCorrect).length;
  int get lostPredictions => _userPredictions.where((p) => p.isResolved && !p.isCorrect).length;

  double get winRate => totalPredictions > 0 ? (wonPredictions / totalPredictions) * 100 : 0.0;

  // Connect wallet
  Future<bool> connectWallet(String privateKey) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _blockchainService.connectWallet(privateKey);

      if (success) {
        _isConnected = true;
  _userAddress = _blockchainService.userAddress;
        await _loadUserData();
      } else {
        _setError('Failed to connect wallet');
      }

      return success;
    } catch (e) {
      _setError('Error connecting wallet: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Disconnect wallet
  void disconnect() {
    _blockchainService.disconnect();
    _isConnected = false;
    _userAddress = null;
    _balance = null;
    _userPredictions.clear();
    _clearError();
    notifyListeners();
  }

  // Create a new prediction
  Future<bool> createPrediction({
    required String tokenAddress,
    required double currentPrice,
    required double predictedPrice,
    required Duration duration,
    required double stakeAmount,
  }) async {
    if (!_isConnected) {
      _setError('Wallet not connected');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      // Convert prices to wei (assuming 18 decimals)
      final currentPriceWei = BigInt.from((currentPrice * 1e18).toInt());
      final predictedPriceWei = BigInt.from((predictedPrice * 1e18).toInt());
      final stakeAmountWei = BigInt.from((stakeAmount * 1e18).toInt());

      final request = CreatePredictionRequest(
  tokenAddress: tokenAddress,
  currentPrice: currentPriceWei,
  predictedPrice: predictedPriceWei,
  duration: duration,
  stakeAmount: stakeAmountWei,
      );

      final txHash = await _blockchainService.createPrediction(request);

      // Refresh user data after successful transaction
      await Future.delayed(const Duration(seconds: 3)); // Wait for transaction to be mined
      await _loadUserData();

      return true;
    } catch (e) {
      _setError('Failed to create prediction: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Refresh user data
  Future<void> refreshData() async {
    if (!_isConnected) return;

    _setLoading(true);
    _clearError();

    try {
      await _loadUserData();
    } catch (e) {
      _setError('Failed to refresh data: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load user balance and predictions
  Future<void> _loadUserData() async {
    if (!_isConnected || _blockchainService.userAddress == null) return;

    try {
    // Load balance
    final balanceBigInt = await _blockchainService.getUserBalance();
    _balance = balanceBigInt.toInt() / BigInt.from(10).pow(18).toInt();

      // Load predictions
      _userPredictions = await _blockchainService.getUserPredictions(
  _blockchainService.userAddress!,
      );

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load user data: $e');
    }
  }

  // Get specific prediction
  Future<PredictionModel?> getPrediction(int predictionId) async {
    try {
      return await _blockchainService.getPrediction(predictionId);
    } catch (e) {
      _setError('Failed to get prediction: $e');
      return null;
    }
  }

  // Resolve prediction (for admin/owner)
  Future<bool> resolvePrediction(int predictionId, double actualPrice) async {
    if (!_isConnected) {
      _setError('Wallet not connected');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      final actualPriceWei = BigInt.from((actualPrice * 1e18).toInt());
      await _blockchainService.resolvePrediction(predictionId, actualPriceWei);

      // Refresh data after resolution
      await Future.delayed(const Duration(seconds: 3));
      await _loadUserData();

      return true;
    } catch (e) {
      _setError('Failed to resolve prediction: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Utility methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Format methods
  String formatEther(BigInt wei) {
    final ether = wei.toInt() / BigInt.from(10).pow(18).toInt();
    return ether.toStringAsFixed(4);
  }

  String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  @override
  void dispose() {
    _blockchainService.dispose();
    super.dispose();
  }
}