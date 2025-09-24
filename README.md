# E-Light 💎

**E-Light** is a modern **Flutter-powered** cryptocurrency wallet and prediction platform that combines traditional wallet functionality with AI-powered market analysis and Web3 blockchain integration. Built entirely with Flutter framework, it delivers beautiful animations and intelligent insights across all platforms.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Web3](https://img.shields.io/badge/Web3-F16822?style=for-the-badge&logo=web3.js&logoColor=white)
![BlockDAG](https://img.shields.io/badge/BlockDAG-6C5CE7?style=for-the-badge&logoColor=white)

## 🎯 What is E-Light?

E-Light is a comprehensive crypto application built with **Flutter**, Google's UI toolkit, that bridges traditional finance with decentralized blockchain technology. Leveraging Flutter's cross-platform capabilities, it delivers native performance across Windows, Android, iOS, and Web with a single codebase.

## 🛠️ **Built with Flutter**

E-Light showcases the power of Flutter development with:

- **Single Codebase**: One Flutter app running on 4+ platforms
- **Native Performance**: Compiled to native code for optimal speed
- **Beautiful Animations**: Flutter's animation framework for smooth UX
- **Material Design 3**: Google's latest design system implementation
- **Hot Reload**: Fast development and testing cycle
- **Rich Ecosystem**: Leveraging Flutter packages for Web3, charts, fonts

## 💎 **App Features**

It offers three main experiences:

### 🏠 **AI Crypto Predictions**
- **Market Intelligence**: AI-powered crypto price predictions for BTC, ETH, ADA, SOL
- **Interactive Charts**: Visual price history and trend analysis
- **Prediction Engine**: Generate forecasts for 1 hour to 30 days
- **Confidence Metrics**: AI confidence levels for each prediction
- **Real-time Data**: Live market data simulation

### 💼 **Digital Wallet**
- **Multi-Card System**: Manage multiple wallet cards (Visa, Mastercard, Amex)
- **Balance Management**: Track balances across different cards
- **Transaction History**: Complete transaction logging with categories
- **Crypto Portfolio**: BTC, ETH, ADA holdings with live prices
- **Deposit/Withdrawal**: Easy fund management with animated modals

### 📊 **Web3 Predictions Dashboard**
- **BlockDAG Connection**: Connect to BlockDAG testnet blockchain
- **Smart Contracts**: Prediction market contract interactions
- **BDAG Token**: Native blockchain token for staking
- **Prediction Staking**: Stake tokens on price predictions
- **Reward System**: Earn rewards for accurate predictions
- **Win/Loss Tracking**: Monitor prediction performance and statistics

## ✨ **Flutter-Powered Features**

- **🎭 Flutter Animations**: Custom particle animations built with Flutter's animation framework
- **🔐 Secure Connection**: Private key-based BlockDAG connection with Flutter crypto libraries
- **🎨 Material Design 3**: Google's latest design system implemented in Flutter
- **📱 True Cross-Platform**: Single Flutter codebase running on Windows, Android, iOS, Web
- **⚡ Real-Time State**: Provider pattern for reactive UI updates
- **📊 FL Chart Integration**: Beautiful charts using Flutter's fl_chart package
- **💳 Animated Cards**: Custom Flutter widgets with gradient animations
- **🧩 Provider State Management**: Efficient state management with Flutter Provider
- **🚀 Smooth Navigation**: Custom Flutter navigation with animated transitions

## 📱 App Flow

```
🎬 Splash Screen → 🔗 Wallet Connect → 🏠 Main Navigation
                                           ├── 🏠 Home (AI Predictions)
                                           ├── 💼 Wallet (Cards & Assets)  
                                           └── 📊 Dashboard (Web3 Predictions)
```

## 📱 How to Use E-Light

### **Step 1: Launch & Connect**
1. **Splash Screen**: Enjoy the animated intro with particles and wallet logo
2. **Wallet Connect**: Enter your BlockDAG private key to connect to testnet
3. **Navigation**: Access the main app with 3-tab bottom navigation

### **Step 2: Explore Features**

#### 🏠 **Home Tab - AI Predictions**
- View market overview with total value and positive/negative ratios
- Select cryptocurrencies (BTC, ETH, ADA, SOL) for analysis
- View interactive price history charts
- Generate AI predictions with confidence scoring
- Choose timeframes: 1h, 24h, 7d with custom duration selection
- Watch animated prediction generation process

#### 💼 **Wallet Tab - Digital Wallet**
- Manage multiple wallet cards (Visa, Mastercard, Amex)
- View total balance across all cards with visibility toggle
- Use quick actions: Deposit, Send, Withdraw, More
- Browse animated wallet cards with gradients
- Switch between Transaction History and Crypto Assets tabs
- Track crypto holdings (BTC, ETH, ADA) with live price changes

#### 📊 **Dashboard Tab - Web3 Predictions**
- Connect your wallet to BlockDAG testnet
- View wallet information and BDAG balance
- Monitor prediction statistics (Total, Win Rate, Active)
- Create new predictions with token address, prices, and stake amounts
- Track your prediction history with status indicators
- Earn rewards for accurate predictions

### **Step 3: Advanced Usage**
- **Create Predictions**: Stake BDAG tokens on price movements
- **Monitor Performance**: Track win/loss ratio and rewards
- **Manage Portfolio**: Balance traditional cards with crypto assets
- **Real-time Updates**: Watch live price changes and market data

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