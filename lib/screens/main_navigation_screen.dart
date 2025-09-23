import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_colors.dart';
import 'wallet_screen.dart';
import 'home_screen.dart';
import 'dashboard_screen.dart';
import 'create_prediction_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;
  late AnimationController _fabController;
  late Animation<double> _fabScaleAnimation;
  late Animation<double> _fabRotationAnimation;

  final List<Widget> _screens = [
    const HomeScreen(),
    const WalletScreen(),
    const DashboardScreen(),
    const CreatePredictionScreen(),
  ];

  final List<NavigationItem> _navItems = [
    NavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    NavigationItem(
      icon: Icons.account_balance_wallet_outlined,
      activeIcon: Icons.account_balance_wallet,
      label: 'Wallet',
    ),
    NavigationItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
    ),
    NavigationItem(
      icon: Icons.add_circle_outline,
      activeIcon: Icons.add_circle,
      label: 'Predict',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _fabScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeInOut,
    ));
    
    _fabRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = _selectedIndex == index;
              
              return GestureDetector(
                onTap: () => _onItemTapped(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          isSelected ? item.activeIcon : item.icon,
                          key: ValueKey(isSelected),
                          color: isSelected 
                              ? AppColors.primary 
                              : AppColors.onSurfaceVariant,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          color: isSelected 
                              ? AppColors.primary 
                              : AppColors.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: isSelected 
                              ? FontWeight.w600 
                              : FontWeight.w400,
                        ),
                        child: Text(item.label),
                      ),
                    ],
                  ),
                ),
              ).animate().scale(
                duration: Duration(milliseconds: 200 + (index * 50)),
                curve: Curves.easeOutBack,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return AnimatedBuilder(
      animation: _fabController,
      builder: (context, child) {
        return Transform.scale(
          scale: _fabScaleAnimation.value,
          child: Transform.rotate(
            angle: _fabRotationAnimation.value,
            child: FloatingActionButton(
              onPressed: () {
                _fabController.forward().then((_) {
                  _fabController.reverse();
                });
                // Add your scan functionality here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Scan feature coming soon!'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              backgroundColor: AppColors.primary,
              elevation: 8,
              child: const Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        );
      },
    ).animate().scale(
      delay: const Duration(milliseconds: 500),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
