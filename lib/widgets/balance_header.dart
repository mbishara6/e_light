import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_colors.dart';

class BalanceHeader extends StatelessWidget {
  final double balance;
  final String currency;
  final bool isVisible;
  final VoidCallback onVisibilityToggle;

  const BalanceHeader({
    super.key,
    required this.balance,
    required this.currency,
    this.isVisible = true,
    required this.onVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Balance',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  key: ValueKey(isVisible),
                  isVisible 
                      ? '$currency${balance.toStringAsFixed(2)}'
                      : '••••••',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onVisibilityToggle,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  key: ValueKey(isVisible),
                  isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().scale(
      begin: const Offset(0.8, 0.8),
      end: const Offset(1.0, 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
    ).fadeIn(
      delay: const Duration(milliseconds: 200),
    );
  }
}
