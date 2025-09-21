import 'dart:convert';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import '../config/network_config.dart';
import '../models/prediction_model.dart';

class Web3HttpClient extends http.BaseClient {
  final http.Client _httpClient = http.Client();

  // Standard BaseClient override for compatibility with Web3Client
  // ...existing code...
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _httpClient.send(request);
  }

  // Custom RPC sender (if needed elsewhere)
  Future<String> sendRpc(String method, [List<dynamic>? parameters]) async {
    final body = jsonEncode({
      'jsonrpc': '2.0',
      'method': method,
      'params': parameters ?? [],
      'id': DateTime.now().millisecondsSinceEpoch,
    });

    final response = await _httpClient.post(
      Uri.parse(NetworkConfig.blockdagRpcUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] != null) {
        throw Exception('RPC Error: ${jsonResponse['error']['message']}');
      }
      return jsonEncode(jsonResponse['result']);
    } else {
      throw Exception('HTTP Error: ${response.statusCode} - ${response.body}');
    }
  }

  @override
  void close() {
    _httpClient.close();
  }
}

class BlockchainService {
  late Web3Client _web3client;

    String? _userAddress;
  String? _credentials;

  // Events removed; contract logic is mocked.
    // Blockchain logic is mocked; contract fields removed.

  BlockchainService() {
    _initializeWeb3();
  }

  void _initializeWeb3() {
    _web3client = Web3Client(
      NetworkConfig.blockdagRpcUrl,
      Web3HttpClient(),
    );

    // Contract ABI and contract logic removed for mock implementation.
  }

  // Connect wallet with private key
  Future<bool> connectWallet(String privateKey) async {
    try {
      // Remove 0x prefix if present
      String cleanPrivateKey = privateKey.startsWith('0x')
          ? privateKey.substring(2)
          : privateKey;

      _credentials = cleanPrivateKey;
      _userAddress = cleanPrivateKey; // Just store as string
      return true;
    } catch (e) {
      // Error handling: consider using a logging framework in production
      return false;
    }
  }

  // Get user address
  String? get userAddress => _userAddress;

  // Check if wallet is connected
  bool get isConnected => _credentials != null && _userAddress != null;

  // Get user balance
  Future<BigInt> getUserBalance() async {
    if (!isConnected) throw Exception('Wallet not connected');
    // Replace with actual RPC call or mock
    return BigInt.zero;
  }

  // Create a new prediction
  Future<String> createPrediction(CreatePredictionRequest request) async {
    if (!isConnected) throw Exception('Wallet not connected');

    try {
      // Transaction logic removed for mock implementation

    // final result = await _web3client.sendTransaction(
    //   _credentials!,
    //   transaction,
    //   chainId: NetworkConfig.blockdagChainId,
    // );
    // return result;
    return 'mock_tx_hash';
    } catch (e) {
      throw Exception('Failed to create prediction: $e');
    }
  }

  // Get prediction by ID
  Future<PredictionModel> getPrediction(int predictionId) async {
  // Mocked logic: return dummy prediction
  return mockPredictionModel(predictionId);
  }

  // Get total number of predictions
  Future<int> getPredictionCount() async {
    // Mocked logic: return dummy count
    return 0;
  }

  // Get all predictions for a user
  Future<List<PredictionModel>> getUserPredictions(String userAddress) async {
    // Mocked logic: return empty list
    return [];
  }

  // Resolve prediction (owner only)
  Future<String> resolvePrediction(int predictionId, BigInt actualPrice) async {
    if (!isConnected) throw Exception('Wallet not connected');

    try {
      // Transaction logic removed for mock implementation

    // final result = await _web3client.sendTransaction(
    //   _credentials!,
    //   transaction,
    //   chainId: NetworkConfig.blockdagChainId,
    // );
    // return result;
    return 'mock_tx_hash';
    } catch (e) {
      throw Exception('Failed to resolve prediction: $e');
    }
  }

  // Listen to prediction created events
  Stream<PredictionCreatedEvent> listenToPredictionCreated() {
    // Mocked logic: return empty stream
    return const Stream.empty();
  }

  // Listen to prediction resolved events
  Stream<PredictionResolvedEvent> listenToPredictionResolved() {
    // Mocked logic: return empty stream
    return const Stream.empty();
  }

  // Disconnect wallet
  void disconnect() {
    _credentials = null;
    _userAddress = null;
  }

  // Cleanup
  void dispose() {
    _web3client.dispose();
  }
}

// Event models
class PredictionCreatedEvent {
  final int predictionId;
    final String user;
    final String token;
  final BigInt currentPrice;
  final BigInt predictedPrice;
  final BigInt stakeAmount;
  final DateTime expiryTime;

  PredictionCreatedEvent({
    required this.predictionId,
    required this.user,
    required this.token,
    required this.currentPrice,
    required this.predictedPrice,
    required this.stakeAmount,
    required this.expiryTime,
  });

  factory PredictionCreatedEvent.fromEvent(FilterEvent event) {
    final data = event.topics!;
    return PredictionCreatedEvent(
      predictionId: (data[1] as BigInt).toInt(),
      user: data[2].toString(),
      token: data[3].toString(),
      currentPrice: event.data![0] as BigInt,
      predictedPrice: event.data![1] as BigInt,
      stakeAmount: event.data![2] as BigInt,
      expiryTime: DateTime.fromMillisecondsSinceEpoch(
        (event.data![3] as BigInt).toInt() * 1000,
      ),
    );
  }
}

class PredictionResolvedEvent {
  final int predictionId;
    final String user;
  final bool isCorrect;
  final BigInt reward;

  PredictionResolvedEvent({
    required this.predictionId,
    required this.user,
    required this.isCorrect,
    required this.reward,
  });

  factory PredictionResolvedEvent.fromEvent(FilterEvent event) {
    final data = event.topics!;
    return PredictionResolvedEvent(
      predictionId: (data[1] as BigInt).toInt(),
      user: data[2].toString(),
      isCorrect: event.data![0] as bool,
      reward: event.data![1] as BigInt,
    );
  }
}