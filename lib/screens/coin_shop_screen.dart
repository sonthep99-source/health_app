import 'package:flutter/material.dart';
import '../models/health_models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class CoinShopScreen extends StatefulWidget {
  const CoinShopScreen({super.key});

  @override
  State<CoinShopScreen> createState() => _CoinShopScreenState();
}

class _CoinShopScreenState extends State<CoinShopScreen> {
  ShopCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final items = appState.shopCatalog.where((item) {
      if (_selectedCategory == null) return true;
      return item.category == _selectedCategory;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Health Shop & Rewards'),
        actions: [
          // Coins Balance Counter
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.amber.withOpacity(0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                const Text('🪙', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(
                  '${appState.userCoins} Coins',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner: How to earn coins
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surface.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.cyan.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.stars, color: AppTheme.amber, size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'วิธีสะสม Health Coins:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '💧 ดื่มน้ำครบ (+10) • 😴 นอน 7 ชม. (+20) • 🏋️ ออกกำลังกาย (+30) • ⚡ สตรีค 7 วัน (+100)',
                        style: TextStyle(fontSize: 10.5, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
                if (appState.hasStreakShield)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.mint.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.mint.withOpacity(0.4)),
                    ),
                    child: const Row(
                      children: [
                        Text('🛡️', style: TextStyle(fontSize: 12)),
                        SizedBox(width: 4),
                        Text(
                          'Shield Active',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.mint,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () => _showMockTopUp(context, appState),
              icon: const Icon(Icons.add_card_rounded),
              label: const Text('เติมเหรียญ (โหมดทดลอง)'),
            ),
          ),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildCategoryChip('ทั้งหมด', null),
                const SizedBox(width: 8),
                _buildCategoryChip('🐾 สัตว์เลี้ยง (Pet)', ShopCategory.petItem),
                const SizedBox(width: 8),
                _buildCategoryChip('🎨 ตกแต่งแอป (Themes)', ShopCategory.appCosmetic),
                const SizedBox(width: 8),
                _buildCategoryChip('🛡️ สิทธิประโยชน์ (Perks)', ShopCategory.utilityPerk),
              ],
            ),
          ),

          // Items List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isOwned = appState.inventory.contains(item.id);
                final canAfford = appState.userCoins >= item.price;
                final isProLocked = item.isProOnly && !appState.isPro;

                return GlassCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      // Item Icon Box
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceLight.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: item.isProOnly
                                ? AppTheme.purple.withOpacity(0.8)
                                : Colors.white.withOpacity(0.1),
                            width: item.isProOnly ? 1.5 : 1.0,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          item.iconEmoji,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: AppTheme.textPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (item.isProOnly)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'PRO ONLY',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.description,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            // Effect Tag
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.mint.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '✨ ${item.effect}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.mint,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Purchase Button / Status
                      Column(
                        children: [
                          Row(
                            children: [
                              const Text('🪙', style: TextStyle(fontSize: 12)),
                              const SizedBox(width: 4),
                              Text(
                                '${item.price}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.amber,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isOwned
                                  ? Colors.white12
                                  : isProLocked
                                      ? AppTheme.purple
                                      : canAfford
                                          ? AppTheme.cyan
                                          : Colors.white24,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              minimumSize: const Size(70, 32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: isOwned
                                ? null
                                : () {
                                    if (isProLocked) {
                                      _showProRequiredDialog(context);
                                      return;
                                    }
                                    if (!canAfford) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('เหรียญไม่เพียงพอ! ทำภารกิจเพื่อรับเหรียญเพิ่มนะ'),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                      return;
                                    }
                                    final success = appState.buyShopItem(item);
                                    if (success) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('🎉 ซื้อ ${item.name} สำเร็จ!'),
                                          backgroundColor: const Color(0xFF1E293B),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  },
                            child: Text(
                              isOwned
                                  ? 'มีแล้ว'
                                  : isProLocked
                                      ? 'ปลดล็อก'
                                      : 'แลกซื้อ',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isOwned ? AppTheme.textMuted : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, ShopCategory? category) {
    final isSelected = _selectedCategory == category;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppTheme.cyan,
      backgroundColor: AppTheme.surface,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isSelected ? Colors.black : AppTheme.textSecondary,
      ),
      onSelected: (_) {
        setState(() {
          _selectedCategory = category;
        });
      },
    );
  }

  void _showMockTopUp(BuildContext context, AppState state) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('เติมเหรียญทดลอง', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Mock เท่านั้น • ไม่ตัดเงินจริง • ไม่มี QR หรือเชื่อมระบบชำระเงิน', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            const SizedBox(height: 12),
            for (final amount in [50, 150, 400])
              ListTile(
                leading: const Text('🪙', style: TextStyle(fontSize: 22)),
                title: Text('จำลองรับ $amount เหรียญ'),
                trailing: const Text('ฟรี (DEMO)'),
                onTap: () {
                  state.addMockCoins(amount);
                  Navigator.pop(sheetContext);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('โหมดทดลอง: เพิ่ม $amount เหรียญแล้ว')));
                },
              ),
          ]),
        ),
      ),
    );
  }

  void _showProRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppTheme.purple, width: 1.5),
        ),
        title: const Row(
          children: [
            Text('👑', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text(
              'เฉพาะสมาชิก Pro!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const Text(
          'ไอเทมนี้เป็นสิทธิพิเศษสำหรับ Pro Member เท่านั้น เพื่อสนับสนุนการออกกำลังกายและอัปเกรดสัตว์เลี้ยงร่างในตำนาน!',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ไว้ทีหลัง', style: TextStyle(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.purple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              AppScope.of(context).toggleSubscriptionTier();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✨ อัปเกรดเป็น Pro สำเร็จแล้ว! คุณสามารถซื้อไอเทมนี้ได้ทันที'),
                  backgroundColor: AppTheme.purple,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('อัปเกรดเป็น PRO ทันที', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

