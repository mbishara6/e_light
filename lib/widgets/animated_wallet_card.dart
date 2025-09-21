import 'package:flutter/material.dart';
import '../models/wallet_models.dart';

class AnimatedWalletCard extends StatefulWidget {
  final WalletCard card;
  final bool isSelected;
  final VoidCallback? onTap;

  const AnimatedWalletCard({
    super.key,
    required this.card,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<AnimatedWalletCard> createState() => _AnimatedWalletCardState();
}

class _AnimatedWalletCardState extends State<AnimatedWalletCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 8.0,
      end: 4.0,
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

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Container(
              width: 300,
              height: 180,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Card(
                elevation: _elevationAnimation.value,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: widget.card.gradientColors
                          .map((color) => Color(color))
                          .toList(),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.card.type.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              _getCardIcon(widget.card.type),
                              color: Colors.white,
                              size: 32,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          widget.card.maskedNumber,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Card Holder',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  widget.card.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Expires',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  widget.card.expiryDate,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Balance',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  widget.card.formattedBalance,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getCardIcon(String type) {
    switch (type.toLowerCase()) {
      case 'visa':
        return Icons.credit_card;
      case 'mastercard':
        return Icons.credit_card;
      case 'amex':
        return Icons.credit_card;
      default:
        return Icons.credit_card;
    }
  }
}
