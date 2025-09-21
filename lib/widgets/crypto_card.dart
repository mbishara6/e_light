import 'package:flutter/material.dart';
import '../models/crypto_models.dart';
import '../utils/app_colors.dart';

class CryptoCard extends StatefulWidget {
  final CryptoData crypto;
  final bool isSelected;
  final VoidCallback onTap;

  const CryptoCard({
    super.key,
    required this.crypto,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<CryptoCard> createState() => _CryptoCardState();
}

class _CryptoCardState extends State<CryptoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  border: Border.all(
                    color: widget.isSelected
                        ? AppColors.primary
                        : Colors.grey.withValues(alpha: 0.3),
                    width: widget.isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
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
                          widget.crypto.symbol.substring(0, 2),
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
                            widget.crypto.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.crypto.symbol,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.crypto.formattedPrice,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: widget.crypto.isPositiveChange
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.crypto.formattedChange,
                            style: TextStyle(
                              color: widget.crypto.isPositiveChange
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getCryptoColor() {
    switch (widget.crypto.symbol.toLowerCase()) {
      case 'btc':
        return const Color(0xFFF7931A);
      case 'eth':
        return const Color(0xFF627EEA);
      case 'ada':
        return const Color(0xFF0033AD);
      case 'sol':
        return const Color(0xFF9945FF);
      default:
        return AppColors.primary;
    }
  }
}
