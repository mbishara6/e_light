// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PredictionEngine is ReentrancyGuard, Ownable {
    struct Prediction {
        address user;
        address token;
        uint256 currentPrice;
        uint256 predictedPrice;
        uint256 timestamp;
        uint256 expiryTime;
        uint256 stakeAmount;
        bool isResolved;
        bool isCorrect;
    }

    uint256 public predictionCounter;
    mapping(uint256 => Prediction) public predictions;

    event PredictionCreated(
        uint256 indexed predictionId,
        address indexed user,
        address indexed token,
        uint256 currentPrice,
        uint256 predictedPrice,
        uint256 stakeAmount,
        uint256 expiryTime
    );

    event PredictionResolved(
        uint256 indexed predictionId,
        address indexed user,
        bool isCorrect,
        uint256 reward
    );

    constructor() Ownable() {}

    function createPrediction(
        address token,
        uint256 currentPrice,
        uint256 predictedPrice,
        uint256 duration
    ) external payable nonReentrant returns (uint256) {
        require(duration >= 1 hours && duration <= 30 days, "Invalid duration");

        uint256 predictionId = predictionCounter++;
        uint256 expiryTime = block.timestamp + duration;

        predictions[predictionId] = Prediction({
            user: msg.sender,
            token: token,
            currentPrice: currentPrice,
            predictedPrice: predictedPrice,
            timestamp: block.timestamp,
            expiryTime: expiryTime,
            stakeAmount: msg.value,
            isResolved: false,
            isCorrect: false
        });

        emit PredictionCreated(
            predictionId,
            msg.sender,
            token,
            currentPrice,
            predictedPrice,
            msg.value,
            expiryTime
        );

        return predictionId;
    }

    function resolvePrediction(
        uint256 predictionId,
        uint256 actualPrice
    ) external onlyOwner {
        Prediction storage prediction = predictions[predictionId];
        require(!prediction.isResolved, "Already resolved");
        require(block.timestamp >= prediction.expiryTime, "Not expired");

        uint256 tolerance = (prediction.currentPrice * 500) / 10000; // ±5%
        bool isCorrect =
            actualPrice >= prediction.predictedPrice - tolerance &&
            actualPrice <= prediction.predictedPrice + tolerance;

        prediction.isResolved = true;
        prediction.isCorrect = isCorrect;

        uint256 reward = 0;
        if (isCorrect) {
            reward = (prediction.stakeAmount * 180) / 100; // 1.8x return
            payable(prediction.user).transfer(reward);
        }

        emit PredictionResolved(predictionId, prediction.user, isCorrect, reward);
    }
}
