# E-Light 🚀

A cross-platform Flutter crypto wallet application with AI-powered price predictions and Web3 integration.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Web3](https://img.shields.io/badge/Web3-F16822?style=for-the-badge&logo=web3.js&logoColor=white)

## 🎯 Features

### 🤖 AI-Powered Predictions
- **Smart Analytics**: AI-generated crypto price predictions
- **Market Insights**: Real-time market data and trends
- **Confidence Scoring**: Reliability metrics for each prediction
- **Multi-timeframe Analysis**: 1h to 30-day prediction horizons

### 💼 Multi-Wallet Management
- **Digital Wallet Cards**: Multiple card support with animations
- **Transaction History**: Complete transaction tracking
- **Balance Management**: Real-time balance updates
- **Crypto Assets**: Support for BTC, ETH, ADA, SOL and more

### 🔗 Web3 Integration
- **BlockDAG Testnet**: Connect to BlockDAG blockchain
- **Smart Contracts**: Prediction market smart contracts
- **Staking System**: Stake BDAG tokens on predictions
- **Reward Mechanism**: Earn rewards for accurate predictions

### 🎨 Beautiful UI/UX
- **Animated Interface**: Smooth Flutter animations
- **Material Design 3**: Modern UI components
- **Dark/Light Theme**: Automatic theme switching
- **Responsive Design**: Works on all screen sizes

## 📱 App Flow

```
🎬 Splash Screen → 🔗 Wallet Connect → 🏠 Main Navigation
                                           ├── 🏠 Home (AI Predictions)
                                           ├── 💼 Wallet (Cards & Assets)
                                           └── 📊 Dashboard (Web3 Predictions)
```

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: `>=3.1.0`
- **Dart SDK**: `>=3.1.0 <4.0.0`
- **Development IDE**: VS Code, Android Studio, or IntelliJ

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/mbishara6/e_light.git
   cd e_light
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For Windows
   flutter run -d windows
   
   # For Android (with device/emulator)
   flutter run -d android
   
   # For Web
   flutter run -d chrome
   
   # For iOS (macOS only)
   flutter run -d ios
   ```

## 🛠️ Development

### Project Structure

```
lib/
├── config/           # Network and contract configurations
├── models/           # Data models (Crypto, Wallet, Prediction)
├── providers/        # State management (Web3, Predictions)
├── screens/          # App screens and navigation
├── services/         # Blockchain and API services
├── utils/            # Utilities and themes
├── widgets/          # Reusable UI components
└── main.dart         # App entry point
```

### Key Dependencies

- **provider**: `^6.1.2` - State management
- **web3dart**: `^3.0.1` - Web3 blockchain integration
- **flutter_animate**: `^4.5.2` - Smooth animations
- **fl_chart**: `^1.1.0` - Beautiful charts
- **google_fonts**: `^6.3.0` - Typography
- **lottie**: `^3.1.2` - Animation support

### Building for Production

```bash
# Android APK
flutter build apk --release

# Windows executable
flutter build windows --release

# Web deployment
flutter build web --release
```

## 🔧 Configuration

### Blockchain Setup

1. **BlockDAG Network**: 
   - RPC URL: Configure in `lib/config/network_config.dart`
   - Chain ID: 1043 (default)
   - Native Token: BDAG

2. **Smart Contracts**:
   - Prediction Engine ABI included
   - Contract addresses configurable
   - Mock implementations for testing

## 📊 Screenshots

| Splash Screen | Wallet Connect | Home Screen |
|---------------|----------------|-------------|
| ![Splash](assets/screenshots/splash.png) | ![Connect](assets/screenshots/connect.png) | ![Home](assets/screenshots/home.png) |

| Wallet Screen | Dashboard | AI Predictions |
|---------------|-----------|----------------|
| ![Wallet](assets/screenshots/wallet.png) | ![Dashboard](assets/screenshots/dashboard.png) | ![Predictions](assets/screenshots/predictions.png) |

## 🤝 Contributing

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Commit changes**: `git commit -m 'Add amazing feature'`
4. **Push to branch**: `git push origin feature/amazing-feature`
5. **Open a Pull Request**

## 📋 Roadmap

- [ ] **Real API Integration**: Connect to live crypto APIs
- [ ] **Enhanced AI Models**: Improve prediction accuracy
- [ ] **Multi-chain Support**: Add Ethereum, BSC, Polygon
- [ ] **NFT Gallery**: Display and manage NFT collections
- [ ] **DeFi Integration**: Yield farming and liquidity pools
- [ ] **Social Features**: Share predictions and compete
- [ ] **Mobile Notifications**: Price alerts and updates
- [ ] **Advanced Charts**: TradingView-style analysis

## 🐛 Known Issues

- DevTools connection warnings (non-critical)
- Mock blockchain data (development phase)
- Limited to testnet functionality

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **E-Light Team** - *Initial work* - [mbishara6](https://github.com/mbishara6)

## 🙏 Acknowledgments

- **Flutter Team** for the amazing framework
- **Web3Dart** for blockchain integration
- **BlockDAG** for testnet support
- **Community** for feedback and contributions

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/mbishara6/e_light/issues)
- **Email**: developer@elight.com
- **Documentation**: [Project Wiki](https://github.com/mbishara6/e_light/wiki)

---

**Built with ❤️ using Flutter**

*Making crypto accessible through beautiful design and intelligent predictions*