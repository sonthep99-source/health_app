import 'package:flutter/material.dart';
import '../models/health_models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/pet_card_widget.dart';
import '../widgets/quick_logging_strip.dart';
import '../widgets/rpg_status_bar.dart';
import '../widgets/source_badge.dart';
import 'boss_battle_screen.dart';
import 'coin_shop_screen.dart';
import 'premium_subscription_screen.dart';
import '../profile_history_screen.dart';

class GamifiedDashboardScreen extends StatelessWidget {
  final Function(int) onNavigateTab;

  const GamifiedDashboardScreen({
    super.key,
    required this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: User Profile, Coin Counter & Pro Switcher
              _buildTopHeader(context, appState),

              const SizedBox(height: 16),

              // 1-Tap Quick Logging Strip
              const QuickLoggingStrip(),

              const SizedBox(height: 16),

              // Feature #7: Tamagotchi Health Pet Main Widget
              PetCardWidget(
                onOpenShop: () => _openScreen(context, const CoinShopScreen()),
              ),

              const SizedBox(height: 16),

              // Feature #6: HealthQuest RPG Status & Boss Battle Shortcut
              RpgStatusBar(
                onOpenBossBattle: () => _openScreen(context, const BossBattleScreen()),
              ),

              const SizedBox(height: 18),

              // Feature #5: Multi-Source Health Metrics Grid (with Badges)
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
                    onPressed: () => _openScreen(context, const ProfileHistoryScreen()),
                    child: const Text(
                      'ดูประวัติรวม >',
                      style: TextStyle(fontSize: 12, color: AppTheme.cyan),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 2x2 Metric Cards Grid
              Row(
                children: [
                  // 1. Water Metric
                  Expanded(
                    child: _buildMetricCard(
                      title: 'การดื่มน้ำ',
                      valueStr: '${appState.waterMl} / ${appState.waterGoalMl} ml',
                      subStr: '${(appState.waterProgress * 100).round()}% ครบเป้า',
                      icon: Icons.water_drop,
                      color: AppTheme.cyan,
                      source: HealthDataSource.manualInput,
                      onTap: () => onNavigateTab(1), // Go to Water/Nutrition Tab
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 2. Sleep Metric
                  Expanded(
                    child: _buildMetricCard(
                      title: 'การนอนหลับ',
                      valueStr: '${appState.sleepRecord.durationHours} ชม.',
                      subStr: 'คุณภาพ ${appState.sleepRecord.qualityScore}/100 ดีเยี่ยม',
                      icon: Icons.bedtime,
                      color: const Color(0xFFA855F7),
                      source: appState.sleepRecord.source,
                      onTap: () => onNavigateTab(2), // Go to Sleep Tab
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  // 3. Workout Metric
                  Expanded(
                    child: _buildMetricCard(
                      title: 'การออกกำลังกาย',
                      valueStr: '${appState.workouts.length} เซสชั่น',
                      subStr: '${appState.workouts.fold(0, (s, w) => s + w.caloriesBurned)} kcal เผาผลาญ',
                      icon: Icons.fitness_center,
                      color: AppTheme.rose,
                      source: appState.workouts.isNotEmpty
                          ? appState.workouts.first.source
                          : HealthDataSource.manualInput,
                      onTap: () => onNavigateTab(3), // Go to Workout Tab
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 4. Steps & Active Calories (Smartwatch Sync)
                  Expanded(
                    child: _buildMetricCard(
                      title: 'ก้าวเดิน & เคลื่อนไหว',
                      valueStr: '${appState.stepsToday} ก้าว',
                      subStr: '${appState.activeCalories} Active kcal',
                      icon: Icons.directions_walk,
                      color: AppTheme.mint,
                      source: appState.stepsSource,
                      onTap: () => appState.syncSmartwatchData(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // AI Health Coach Teaser Card (Feature #4)
              GlassCard(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0E7490).withOpacity(0.35),
                    const Color(0xFF1E293B),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                onTap: () => onNavigateTab(4), // Navigate to AI Coach Tab
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.cyan, AppTheme.mint],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.psychology, color: Colors.black, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'AI Health Coach พร้อมให้คำปรึกษา',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.cyan.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  appState.isPro ? 'PRO UNLIMITED' : 'FREE ${appState.remainingAiMessages}/5',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.cyan,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'ถามเกี่ยวกับเมนูหลังออกกำลังกาย, แก้นอนไม่หลับ หรือจัดตารางเวท',
                            style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppTheme.cyan),
                  ],
                ),
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
        // Avatar & Greeting (Tapping avatar opens Profile History Screen!)
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _openScreen(context, const ProfileHistoryScreen()),
          child: Row(
            children: [
              Stack(
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
                        color: appState.isPro ? const Color(0xFFF59E0B) : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text('🛡️', style: TextStyle(fontSize: 22)),
                  ),
                  if (appState.isPro)
                    const Positioned(
                      bottom: 0,
                      right: 0,
                      child: Text('👑', style: TextStyle(fontSize: 14)),
                    ),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Health Dashboard',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '🔥 ${appState.streakDays}d Streak',
                        style: const TextStyle(fontSize: 11, color: AppTheme.amber, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Text(
                    'Hero Alex • แตะเพื่อดูประวัติสุขภาพรวม >',
                    style: TextStyle(fontSize: 10.5, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Quick Controls: Coins Counter & Pro Toggle
        Row(
          children: [
            // Coins Counter (Opens Shop)
            GestureDetector(
              onTap: () => _openScreen(context, const CoinShopScreen()),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.amber.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.amber.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const Text('🪙', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text(
                      '${appState.userCoins}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.amber,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Pro / Free Mode Switcher Pill (Fast 1-tap testing button)
            GestureDetector(
              onTap: () => _openScreen(context, const PremiumSubscriptionScreen()),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  gradient: appState.isPro
                      ? const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)])
                      : null,
                  color: appState.isPro ? null : Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: appState.isPro ? Colors.transparent : Colors.white24,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      appState.isPro ? '👑 PRO' : 'FREE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: appState.isPro ? Colors.white : AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String valueStr,
    required String subStr,
    required IconData icon,
    required Color color,
    required HealthDataSource source,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 20, color: color),
              SourceBadge(source: source, compact: true),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 11.5, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 2),
          Text(
            valueStr,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subStr,
            style: TextStyle(fontSize: 10.5, color: color, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _openScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}
