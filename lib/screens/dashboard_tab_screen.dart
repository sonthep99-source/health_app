import 'package:flutter/material.dart';
import '../models/health_models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/quick_logging_strip.dart';
import '../widgets/source_badge.dart';
import 'coin_shop_screen.dart';
import 'premium_subscription_screen.dart';
import '../profile_history_screen.dart';

class DashboardTabScreen extends StatelessWidget {
  final Function(int) onNavigateTab;

  const DashboardTabScreen({super.key, required this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final hero = appState.hero;
    final pet = appState.pet;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: Hero Profile & Coin / Pro Switcher
              _buildTopHeader(context, appState),

              const SizedBox(height: 16),

              // Put the daily actions first so logging is the shortest path.
              const QuickLoggingStrip(),

              const SizedBox(height: 16),

              // Progress and pet motivation follow the primary actions.
              _buildHeroMasterCard(context, appState, hero),

              const SizedBox(height: 16),

              // Companion Pet Quick Overview Banner (Taps to Pet Room Tab 3)
              _buildPetCompanionBanner(context, appState, pet),

              const SizedBox(height: 16),

              // Feature #2 & #3: Calorie Balance Summary (In vs Out)
              _buildCalorieSummaryCard(context, appState),

              const SizedBox(height: 16),

              // Multi-Source Health Metrics Grid (with Badges)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ข้อมูลสุขภาพวันนี้ (Multi-Source Health)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileHistoryScreen()),
                    ),
                    child: const Text('ดูประวัติรวม >', style: TextStyle(fontSize: 12, color: AppTheme.cyan)),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      title: 'การดื่มน้ำ',
                      value: '${appState.waterMl} / ${appState.waterGoalMl} ml',
                      subtitle: 'บันทึกการดื่มน้ำวันนี้',
                      icon: Icons.water_drop,
                      color: AppTheme.cyan,
                      source: HealthDataSource.manualInput,
                      onTap: () => appState.addWater(250),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricTile(
                      title: 'การนอนหลับ',
                      value: '${appState.sleepData.durationHours} ชม.',
                      subtitle: 'คะแนน ${appState.sleepData.qualityScore}/100 ดีเยี่ยม',
                      icon: Icons.bedtime,
                      color: const Color(0xFFA855F7),
                      source: appState.sleepData.source,
                      onTap: () => onNavigateTab(1), // Trackers
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      title: 'การออกกำลังกาย',
                      value: '${appState.workoutPlans.where((w) => w.isCompleted).length} แผนฝึกเสร็จ',
                      subtitle: 'ติดตามเวลาฝึกและปริมาณยก',
                      icon: Icons.fitness_center,
                      color: AppTheme.rose,
                      source: HealthDataSource.manualInput,
                      onTap: () => onNavigateTab(1), // Trackers
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricTile(
                      title: 'ก้าวเดินสะสม',
                      value: '${appState.stepsToday} ก้าว',
                      subtitle: '${appState.activeCalories} Active kcal',
                      icon: Icons.directions_walk,
                      color: AppTheme.mint,
                      source: appState.stepsSource,
                      onTap: () => appState.syncSmartwatchData(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context, AppState appState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileHistoryScreen()),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppTheme.cyan, AppTheme.mint],
                  ),
                  border: Border.all(
                    color: appState.isPro ? AppTheme.amber : Colors.transparent,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(appState.hero.heroClass.iconEmoji, style: const TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'HABITA',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '🔥 ${appState.streakDays}d',
                        style: const TextStyle(fontSize: 11, color: AppTheme.amber, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    '${appState.hero.name} • ${appState.hero.heroClass.nameTh}',
                    style: const TextStyle(fontSize: 10.5, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CoinShopScreen()),
              ),
              child: Container(
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
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppTheme.amber),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PremiumSubscriptionScreen()),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  gradient: appState.isPro
                      ? const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)])
                      : null,
                  color: appState.isPro ? null : Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: appState.isPro ? Colors.transparent : Colors.white24),
                ),
                child: Text(
                  appState.isPro ? '👑 PRO' : 'FREE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: appState.isPro ? Colors.white : AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Feature #1: User Hero Master RPG Card
  Widget _buildHeroMasterCard(BuildContext context, AppState appState, UserHero hero) {
    return GlassCard(
      gradient: const LinearGradient(
        colors: [Color(0xFF1E293B), Color(0xFF1E1B4B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF0E7490), Color(0xFF06B6D4)]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Lv. ${hero.level} Master',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    hero.heroClass.nameTh,
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppTheme.cyan),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '🌟 บัฟสายอาชีพ: ${hero.heroClass.perkDescription}',
            style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 10),
          // EXP Progress Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Hero EXP (จากออกกำลังกายจริง)', style: TextStyle(fontSize: 10.5, color: AppTheme.textMuted)),
              Text('${hero.exp} / ${hero.maxExp} EXP', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppTheme.cyan)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: hero.expProgress,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.cyan),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  // Feature #5: Virtual Pet Companion Overview Banner
  Widget _buildPetCompanionBanner(BuildContext context, AppState appState, VirtualPet pet) {
    return GlassCard(
      gradient: LinearGradient(
        colors: [
          const Color(0xFF1E293B),
          appState.isPro ? const Color(0xFF2E1065) : const Color(0xFF0F3B54),
        ],
      ),
      padding: const EdgeInsets.all(16),
      onTap: () => onNavigateTab(2), // Navigate to Pet Room Sanctuary!
      child: Row(
        children: [
          // Pet Avatar Circle
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.surfaceLight.withOpacity(0.6),
              border: Border.all(color: AppTheme.cyan, width: 2),
            ),
            alignment: Alignment.center,
            child: Text(pet.visualEmoji, style: const TextStyle(fontSize: 32)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${pet.name} (${pet.petType.nameTh})',
                        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      pet.stage.nameTh,
                      style: const TextStyle(fontSize: 10, color: AppTheme.cyan, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  pet.petType.specialtyBuff,
                  style: const TextStyle(fontSize: 10.5, color: AppTheme.mint, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                // Hunger, Happiness, Energy Mini Indicators
                Row(
                  children: [
                    _buildPetStatPill('🍖 อิ่ม', '${pet.hunger.round()}%', AppTheme.amber),
                    const SizedBox(width: 8),
                    _buildPetStatPill('💖 สุข', '${pet.happiness.round()}%', const Color(0xFFF43F5E)),
                    const SizedBox(width: 8),
                    _buildPetStatPill('⚡ พลัง', '${pet.energy.round()}%', AppTheme.cyan),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppTheme.cyan),
        ],
      ),
    );
  }

  Widget _buildPetStatPill(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '$label $value',
        style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  // Feature #2: Calorie Balance Summary (In vs Out)
  Widget _buildCalorieSummaryCard(BuildContext context, AppState appState) {
    final calIn = appState.totalCaloriesIn;
    final calOut = appState.totalCaloriesOut;
    final net = calIn - calOut;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.balance, size: 18, color: AppTheme.cyan),
                  SizedBox(width: 6),
                  Text(
                    'สรุปพลังงานแคลอรี (In vs Out)',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                ],
              ),
              Text(
                net <= 0 ? '🔥 Calorie Deficit ($net)' : '⚡ Calorie Surplus (+$net)',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: net <= 0 ? AppTheme.mint : AppTheme.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.amber.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🍱 แคลอรีรับเข้า (In)', style: TextStyle(fontSize: 10.5, color: AppTheme.textSecondary)),
                      const SizedBox(height: 4),
                      Text('$calIn kcal', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.amber)),
                      const SizedBox(height: 2),
                      Text('จาก ${appState.foodScans.length} มื้อ AI Scan', style: const TextStyle(fontSize: 9.5, color: AppTheme.textMuted)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.mint.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🔥 แคลอรีเผาผลาญ (Out)', style: TextStyle(fontSize: 10.5, color: AppTheme.textSecondary)),
                      const SizedBox(height: 4),
                      Text('$calOut kcal', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.mint)),
                      const SizedBox(height: 2),
                      const Text('Active + เวิร์กเอาต์', style: TextStyle(fontSize: 9.5, color: AppTheme.textMuted)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required HealthDataSource source,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 18, color: color),
              SourceBadge(source: source, compact: true),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
