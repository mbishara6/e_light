import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_colors.dart';
import '../models/wallet_models.dart';

class CryptoAssetItem extends StatelessWidget {
  final CryptoAsset asset;
  final int index;

  const CryptoAssetItem({
    super.key,
    required this.asset,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getCryptoColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                asset.symbol.substring(0, 2),
                style: TextStyle(
                  color: _getCryptoColor(),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.name,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${asset.amount} ${asset.symbol}',
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                asset.formattedValue,
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: asset.changePercent >= 0
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  asset.formattedChange,
                  style: TextStyle(
                    color: asset.changePercent >= 0
                        ? AppColors.success
                        : AppColors.error,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().slideX(
      begin: 1,
      end: 0,
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutCubic,
    ).fadeIn(
      duration: Duration(milliseconds: 300 + (index * 100)),
    );
  }

  Color _getCryptoColor() {
    switch (asset.symbol.toLowerCase()) {
      case 'btc':
        return const Color(0xFFF7931A);
      case 'eth':
        return const Color(0xFF627EEA);
      case 'ada':
        return const Color(0xFF0033AD);
      default:
        return AppColors.primary;
    }
  }
}
