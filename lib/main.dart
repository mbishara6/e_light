import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'providers/prediction_provider.dart';
import 'utils/theme.dart';

void main() {
  runApp(const CryptoPredictorApp());
}

class CryptoPredictorApp extends StatelessWidget {
  const CryptoPredictorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PredictionProvider(),
      child: MaterialApp(
        title: 'Crypto Predictor - Wallet & AI Predictions',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
