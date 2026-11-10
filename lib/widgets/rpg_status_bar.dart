import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class RpgStatusBar extends StatelessWidget {
  final VoidCallback onOpenBossBattle;

  const RpgStatusBar({super.key, required this.onOpenBossBattle});

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final boss = appState.weeklyBoss;

    return GlassCard(
      gradient: const LinearGradient(
        colors: [
          Color(0xFF1E1B4B), // Deep Indigo/Purple
          Color(0xFF0F172A),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      padding: const EdgeInsets.all(14),
      onTap: onOpenBossBattle,
      child: Column(
        children: [
          // Header: RPG Stats & Boss Battle Trigger
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text('⚔️', style: TextStyle(fontSize: 18)),
                  SizedBox(width: 8),
                  Text(
                    'HealthQuest RPG Stats',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE11D48), Color(0xFF9333EA)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE11D48).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(boss.isDefeated ? '🏆 ชนะบอสแล้ว!' : '👹 ลุยบอสประจำสัปดาห์ >',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // RPG Gauges: HP (Sleep), MP (Water), ATK (Workout)
          Row(
            children: [
              // HP from Sleep
              Expanded(
                child: _buildRpgGauge(
                  label: 'HP (การนอน)',
                  valueStr: '${appState.playerHp}/${appState.playerMaxHp}',
                  percent: appState.playerHp / appState.playerMaxHp,
                  color: AppTheme.rose,
                  icon: '❤️',
                ),
              ),
              const SizedBox(width: 10),

              // MP from Water
              Expanded(
                child: _buildRpgGauge(
                  label: 'MP (ดื่มน้ำ)',
                  valueStr: '${appState.playerMp}%',
                  percent: appState.playerMp / 100,
                  color: AppTheme.cyan,
                  icon: '💧',
                ),
              ),
              const SizedBox(width: 10),

              // ATK from Workouts
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.amber.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '💥 ATK (เวิร์กเอาต์)',
                        style: TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${appState.playerAtk}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.amber,
                        ),
                      ),
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

  Widget _buildRpgGauge({
    required String label,
    required String valueStr,
    required double percent,
    required Color color,
    required String icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$icon $label',
                style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
              ),
              Text(
                valueStr,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent.clamp(0.0, 1.0),
              backgroundColor: Colors.white.withOpacity(0.06),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }
}

