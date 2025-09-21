import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_colors.dart';
import '../models/wallet_models.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final int index;

  const TransactionItem({
    super.key,
    required this.transaction,
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
              color: _getIconBackgroundColor(),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getTransactionIcon(),
              color: _getIconColor(),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.description,
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM dd, yyyy').format(transaction.date),
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            transaction.formattedAmount,
            style: TextStyle(
              color: transaction.type == 'income' 
                  ? AppColors.success 
                  : transaction.type == 'expense' 
                      ? AppColors.error 
                      : AppColors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
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

  IconData _getTransactionIcon() {
    switch (transaction.category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'entertainment':
        return Icons.movie;
      case 'bills':
        return Icons.receipt;
      case 'transfer':
        return Icons.swap_horiz;
      case 'salary':
        return Icons.work;
      default:
        return Icons.account_balance_wallet;
    }
  }

  Color _getIconColor() {
    switch (transaction.type) {
      case 'income':
        return AppColors.success;
      case 'expense':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  Color _getIconBackgroundColor() {
    switch (transaction.type) {
      case 'income':
        return AppColors.success.withValues(alpha: 0.1);
      case 'expense':
        return AppColors.error.withValues(alpha: 0.1);
      default:
        return AppColors.primary.withValues(alpha: 0.1);
    }
  }
}
