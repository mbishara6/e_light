# Flutter Crypto Wallet App

A modern cryptocurrency wallet application built with Flutter, featuring multi-card management, transaction tracking, and smart contract integration.

## ✨ Features

- **Multi-Wallet Support**: Manage multiple wallet cards with different cryptocurrencies
- **Real-time Tracking**: Live balance updates and transaction monitoring
- **Secure Transactions**: Send, receive, deposit, and withdraw cryptocurrencies
- **Smart Contracts**: Ethereum blockchain integration with Solidity contracts
- **Modern UI**: Smooth animations, dark/light themes, and responsive design

## 🛠️ Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.0+)
- [Node.js](https://nodejs.org/) (16+)
- [Git](https://git-scm.com/)
- Android Studio or VS Code with Flutter extensions

## 🚀 Quick Start

1. **Clone & Install**
   ```bash
   git clone <your-repo-url>
   cd flutter_wallet_app
   flutter pub get
   ```

2. **Setup Smart Contracts**
   ```bash
   cd contracts
   npm install
   cp .env.example .env
   # Edit .env with your configuration
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
flutter_wallet_app/
├── lib/
│   ├── models/          # Data models (WalletCard, Transaction)
│   ├── screens/         # Main app screens
│   ├── widgets/         # Reusable UI components
│   ├── utils/           # Themes, colors, constants
│   └── main.dart
├── assets/
│   └── images/          # App icons and images
├── contracts/           # Solidity smart contracts
└── pubspec.yaml
```

## 🔧 Tech Stack

- **Frontend**: Flutter, Dart
- **Blockchain**: Solidity, Hardhat, Ethereum
- **UI**: Custom animations, Material Design
- **Tools**: MetaMask integration support

## 📱 App Screens

- **Wallet Screen**: Main dashboard with card carousel and quick actions
- **Transaction History**: Detailed transaction tracking and categorization
- **Portfolio**: Cryptocurrency holdings overview
- **Settings**: Theme preferences and security options

## 🔐 Smart Contract Deployment

```bash
cd contracts
npx hardhat compile
npx hardhat run scripts/deploy.js --network localhost
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Author**: MiniMax Agent
