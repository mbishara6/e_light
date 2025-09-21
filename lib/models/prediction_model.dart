  // Mock factory for testing and placeholder logic

  // Top-level mock factory for PredictionModel
  PredictionModel mockPredictionModel(int id) {
    return PredictionModel(
      id: id,
      user: 'mock_user',
      token: 'mock_token',
      currentPrice: BigInt.from(1000),
      predictedPrice: BigInt.from(1100),
      timestamp: DateTime.now(),
      expiryTime: DateTime.now().add(const Duration(hours: 1)),
      stakeAmount: BigInt.from(100),
      isResolved: false,
      isCorrect: false,
    );
  }

class PredictionModel {
  final int id;
  final String user;
  final String token;
  final BigInt currentPrice;
  final BigInt predictedPrice;
  final DateTime timestamp;
  final DateTime expiryTime;
  final BigInt stakeAmount;
  final bool isResolved;
  final bool isCorrect;

  PredictionModel({
    required this.id,
    required this.user,
    required this.token,
    required this.currentPrice,
    required this.predictedPrice,
    required this.timestamp,
    required this.expiryTime,
    required this.stakeAmount,
    required this.isResolved,
    required this.isCorrect,
  });

  factory PredictionModel.fromContract(int id, List<dynamic> data) {
    return PredictionModel(
      id: id,
      user: data[0].toString(),
      token: data[1].toString(),
      currentPrice: data[2] as BigInt,
      predictedPrice: data[3] as BigInt,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        (data[4] as BigInt).toInt() * 1000,
      ),
      expiryTime: DateTime.fromMillisecondsSinceEpoch(
        (data[5] as BigInt).toInt() * 1000,
      ),
      stakeAmount: data[6] as BigInt,
      isResolved: data[7] as bool,
      isCorrect: data[8] as bool,
    );
  }

  // Utility getters
  bool get isExpired => DateTime.now().isAfter(expiryTime);
  bool get isPending => !isResolved && !isExpired;
  bool get canResolve => !isResolved && isExpired;

  Duration get timeLeft => isExpired
      ? Duration.zero
      : expiryTime.difference(DateTime.now());

  double get currentPriceInEther =>
      currentPrice.toInt() / BigInt.from(10).pow(18).toInt();

  double get predictedPriceInEther =>
      predictedPrice.toInt() / BigInt.from(10).pow(18).toInt();

  double get stakeAmountInEther =>
      stakeAmount.toInt() / BigInt.from(10).pow(18).toInt();

  double get potentialReward => stakeAmountInEther * 1.8;

  PredictionStatus get status {
    if (isResolved) {
      return isCorrect ? PredictionStatus.won : PredictionStatus.lost;
    } else if (isExpired) {
      return PredictionStatus.expired;
    } else {
      return PredictionStatus.active;
    }
  }

  @override
  String toString() {
    return 'PredictionModel(id: $id, status: $status, stake: $stakeAmountInEther)';
  }
}

enum PredictionStatus {
  active,
  expired,
  won,
  lost,
}

class CreatePredictionRequest {
  final String tokenAddress;
  final BigInt currentPrice;
  final BigInt predictedPrice;
  final Duration duration;
  final BigInt stakeAmount;

  CreatePredictionRequest({
  required this.tokenAddress,
    required this.currentPrice,
    required this.predictedPrice,
    required this.duration,
    required this.stakeAmount,
  });

  BigInt get durationInSeconds => BigInt.from(duration.inSeconds);
}