# e_light

A cross-platform Flutter app and smart contract system for crypto wallet management and prediction markets.

## Features
- Multi-token wallet (ETH + ERC20)
- Deposit and withdraw funds
- View transaction history
- AI-powered crypto price predictions
- Staking and rewards system
- Admin controls and emergency functions

## Structure
- `lib/` — Flutter app source code
- `contracts/` — Solidity smart contracts (CryptoPredictorWallet, PredictionEngine)
- `test/` — Smart contract tests (Hardhat)

## Getting Started
1. Install Flutter and Node.js
2. Run `flutter pub get` in the project root
3. Compile and test contracts in `contracts/` with Hardhat

## Quick Start
```sh
flutter run
```

## Contract Testing
```sh
cd contracts
npm install
npx hardhat test
```

---
For more details, see the code and comments in each folder.