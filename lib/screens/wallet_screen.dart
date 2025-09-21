import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_colors.dart';
import '../models/wallet_models.dart';
import '../widgets/animated_wallet_card.dart';
import '../widgets/transaction_item.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/crypto_asset_item.dart';
import '../widgets/deposit_withdrawal_modal.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with TickerProviderStateMixin {
  late PageController _cardController;
  late TabController _tabController;
  int _currentCardIndex = 0;
  bool _balanceVisible = true;

  // Sample data
  final List<WalletCard> _cards = [
    WalletCard(
      id: '1',
      name: 'John Doe',
      number: '1234567890123456',
      expiryDate: '12/26',
      cvv: '123',
      balance: 12580.50,
      currency: '\$',
      type: 'visa',
      gradientColors: [0xFF6C5CE7, 0xFF74B9FF],
    ),
    WalletCard(
      id: '2',
      name: 'John Doe',
      number: '9876543210987654',
      expiryDate: '08/25',
      cvv: '456',
      balance: 8930.25,
      currency: '\$',
      type: 'mastercard',
      gradientColors: [0xFF00B894, 0xFF00CEC9],
    ),
    WalletCard(
      id: '3',
      name: 'John Doe',
      number: '5555444433332222',
      expiryDate: '03/27',
      cvv: '789',
      balance: 5420.75,
      currency: '\$',
      type: 'amex',
      gradientColors: [0xFFFDCB6E, 0xFFE17055],
    ),
  ];

  final List<Transaction> _transactions = [
    Transaction(
      id: '1',
      title: 'Starbucks Coffee',
      description: 'Morning coffee',
      amount: 5.50,
      date: DateTime.now().subtract(const Duration(hours: 2)),
      type: 'expense',
      category: 'food',
      icon: 'coffee',
    ),
    Transaction(
      id: '2',
      title: 'Salary Deposit',
      description: 'Monthly salary',
      amount: 3500.00,
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: 'income',
      category: 'salary',
      icon: 'work',
    ),
    Transaction(
      id: '3',
      title: 'Amazon Purchase',
      description: 'Electronics',
      amount: 129.99,
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: 'expense',
      category: 'shopping',
      icon: 'shopping',
    ),
    Transaction(
      id: '4',
      title: 'Uber Ride',
      description: 'Trip to downtown',
      amount: 18.75,
      date: DateTime.now().subtract(const Duration(days: 3)),
      type: 'expense',
      category: 'transport',
      icon: 'car',
    ),
  ];

  final List<CryptoAsset> _cryptoAssets = [
    CryptoAsset(
      id: '1',
      name: 'Bitcoin',
      symbol: 'BTC',
      amount: 0.5234,
      price: 45000.00,
      changePercent: 2.45,
      icon: 'btc',
    ),
    CryptoAsset(
      id: '2',
      name: 'Ethereum',
      symbol: 'ETH',
      amount: 2.8910,
      price: 3200.00,
      changePercent: -1.23,
      icon: 'eth',
    ),
    CryptoAsset(
      id: '3',
      name: 'Cardano',
      symbol: 'ADA',
      amount: 1000.00,
      price: 1.25,
      changePercent: 5.67,
      icon: 'ada',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _cardController = PageController();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _cardController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _addTransaction(Transaction transaction) {
    setState(() {
      _transactions.insert(0, transaction);
    });
  }

  void _updateCardBalance(String cardId, double amount, bool isDeposit) {
    setState(() {
      final cardIndex = _cards.indexWhere((card) => card.id == cardId);
      if (cardIndex != -1) {
        final oldCard = _cards[cardIndex];
        final newBalance = isDeposit
            ? oldCard.balance + amount
            : oldCard.balance - amount;

        _cards[cardIndex] = WalletCard(
          id: oldCard.id,
          name: oldCard.name,
          number: oldCard.number,
          expiryDate: oldCard.expiryDate,
          cvv: oldCard.cvv,
          balance: newBalance,
          currency: oldCard.currency,
          type: oldCard.type,
          gradientColors: oldCard.gradientColors,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            // Balance and Quick Actions
            _buildBalanceSection(),
            // Cards Section
            _buildCardsSection(),
            // Tab Section
            _buildTabSection(),
            // Content based on selected tab
            Expanded(
              child: _buildTabContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning',
                style: TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'John Doe',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.surfaceVariant.withValues(alpha: 0.3),
              ),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    ).animate().slideY(
      begin: -1,
      end: 0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    ).fadeIn();
  }

  Widget _buildBalanceSection() {
    final totalBalance = _cards.fold(0.0, (sum, card) => sum + card.balance);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
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
                      key: ValueKey(_balanceVisible),
                      _balanceVisible
                          ? '\$${totalBalance.toStringAsFixed(2)}'
                          : '•••••••',
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
                onTap: () {
                  setState(() {
                    _balanceVisible = !_balanceVisible;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      key: ValueKey(_balanceVisible),
                      _balanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              QuickActionButton(
                icon: Icons.add,
                label: 'Deposit',
                onTap: () => _showDepositWithdrawalModal(true),
              ),
              QuickActionButton(
                icon: Icons.send,
                label: 'Send',
                onTap: () {},
              ),
              QuickActionButton(
                icon: Icons.remove,
                label: 'Withdraw',
                onTap: () => _showDepositWithdrawalModal(false),
              ),
              QuickActionButton(
                icon: Icons.more_horiz,
                label: 'More',
                onTap: () {},
              ),
            ],
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

  void _showDepositWithdrawalModal(bool isDeposit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DepositWithdrawalModal(
        isDeposit: isDeposit,
        cards: _cards,
        onComplete: (cardId, amount, description) {
          _updateCardBalance(cardId, amount, isDeposit);
          _addTransaction(Transaction(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: isDeposit ? 'Deposit' : 'Withdrawal',
            description: description,
            amount: amount,
            date: DateTime.now(),
            type: isDeposit ? 'income' : 'expense',
            category: isDeposit ? 'deposit' : 'withdrawal',
            icon: isDeposit ? 'deposit' : 'withdrawal',
          ));
        },
      ),
    );
  }

  Widget _buildCardsSection() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(vertical: 24),
      child: PageView.builder(
        controller: _cardController,
        onPageChanged: (index) {
          setState(() {
            _currentCardIndex = index;
          });
        },
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          return AnimatedWalletCard(
            card: _cards[index],
            isSelected: index == _currentCardIndex,
            onTap: () {
              // Handle card tap
            },
          ).animate().slideX(
            begin: 1,
            end: 0,
            duration: Duration(milliseconds: 400 + (index * 100)),
            curve: Curves.easeOutCubic,
          );
        },
      ),
    );
  }

  Widget _buildTabSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        onTap: (index) {
          // Tab selection is automatically handled by TabController
        },
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.onSurfaceVariant,
        tabs: const [
          Tab(text: 'Transactions'),
          Tab(text: 'Crypto Assets'),
        ],
      ),
    ).animate().slideY(
      begin: 1,
      end: 0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    ).fadeIn(
      delay: const Duration(milliseconds: 600),
    );
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildTransactionsList(),
        _buildCryptoAssetsList(),
      ],
    );
  }

  Widget _buildTransactionsList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16),
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        return TransactionItem(
          transaction: _transactions[index],
          index: index,
        );
      },
    );
  }

  Widget _buildCryptoAssetsList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16),
      itemCount: _cryptoAssets.length,
      itemBuilder: (context, index) {
        return CryptoAssetItem(
          asset: _cryptoAssets[index],
          index: index,
        );
      },
    );
  }
}
