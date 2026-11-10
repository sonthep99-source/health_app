import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'coin_shop_screen.dart';
import 'ai_coach_screen.dart';

class ShopCoachScreen extends StatefulWidget {
  final int initialSubIndex;

  const ShopCoachScreen({super.key, this.initialSubIndex = 1});

  @override
  State<ShopCoachScreen> createState() => _ShopCoachScreenState();
}

class _ShopCoachScreenState extends State<ShopCoachScreen> {
  late int _selectedSubIndex;

  @override
  void initState() {
    super.initState();
    _selectedSubIndex = widget.initialSubIndex == 0 ? 0 : 1;
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSegmentButton(index: 0, label: '🛍️ ร้านค้า', isSelected: _selectedSubIndex == 0),
              const SizedBox(width: 6),
              _buildSegmentButton(index: 1, label: '🤖 AI Coach', isSelected: _selectedSubIndex == 1),
            ],
          ),
        ),
        actions: [
          // Coins Pill
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.amber.withOpacity(0.18),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.amber.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                const Text('🪙', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 4),
                Text(
                  '${appState.userCoins}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.amber),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _selectedSubIndex == 0
          ? const CoinShopScreen()
          : const AiCoachScreen(),
    );
  }

  Widget _buildSegmentButton({required int index, required String label, required bool isSelected}) {
    return InkWell(
      onTap: () => setState(() => _selectedSubIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.cyan : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}

