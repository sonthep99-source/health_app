import 'package:flutter/material.dart';
import '../models/health_models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class QuickLoggingStrip extends StatelessWidget {
  const QuickLoggingStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.bolt, size: 18, color: AppTheme.amber),
                SizedBox(width: 6),
                Text(
                  '1-Tap Quick Logging',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            if (appState.isSyncing)
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.cyan),
                ),
              )
            else
              Flexible(
                child: Text(
                  appState.cloudSyncStatus,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              // +250ml Water
              _buildQuickPill(
                icon: Icons.water_drop,
                label: '+250 ml',
                color: AppTheme.cyan,
                onTap: () {
                  appState.addWater(250, source: HealthDataSource.manualInput);
                  _showToast(context, '💧 ดื่มน้ำ +250ml สำเร็จ! (สัตว์เลี้ยงสดชื่นขึ้น)');
                },
              ),
              const SizedBox(width: 8),

              // +500ml Water
              _buildQuickPill(
                icon: Icons.local_drink,
                label: '+500 ml',
                color: const Color(0xFF38BDF8),
                onTap: () {
                  appState.addWater(500, source: HealthDataSource.manualInput);
                  _showToast(context, '💧 ดื่มน้ำ +500ml สำเร็จ! เติม MP +25%');
                },
              ),
              const SizedBox(width: 8),

              // Sleep 7.5h Quick Log
              _buildQuickPill(
                icon: Icons.bedtime,
                label: 'นอน 7.5 ชม.',
                color: const Color(0xFFA855F7),
                onTap: () {
                  appState.recordSleep(
                    durationHours: 7.5,
                    qualityScore: 90,
                    source: HealthDataSource.manualInput,
                  );
                  _showToast(context, '😴 บันทึกการนอน 7.5 ชม. สำเร็จ! +20 Health Coins');
                },
              ),
              const SizedBox(width: 8),

              // Workout Quick Log
              _buildQuickPill(
                icon: Icons.fitness_center,
                label: 'เวท 45 น.',
                color: AppTheme.rose,
                onTap: () {
                  appState.logWorkout(
                    title: 'Push Day (อก/ไหล่)',
                    category: 'Push',
                    durationMinutes: 45,
                    caloriesBurned: 350,
                    source: HealthDataSource.manualInput,
                  );
                  _showToast(context, '🔥 บันทึกเวทเทรนนิ่ง 45 นาที! +30 Coins & ATK พุ่ง');
                },
              ),
              const SizedBox(width: 8),

              // Smartwatch Auto Sync
              _buildQuickPill(
                icon: Icons.watch,
                label: 'Sync Watch',
                color: AppTheme.mint,
                isOutlined: true,
                onTap: () async {
                  await appState.syncSmartwatchData();
                  if (context.mounted) {
                    _showToast(context, '⌚ ซิงค์ข้อมูลก้าวเดิน & แคลอรีจาก Apple Watch สำเร็จ!');
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickPill({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isOutlined = false,
  }) {
    return Material(
      color: isOutlined ? Colors.transparent : color.withOpacity(0.14),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        splashColor: color.withOpacity(0.3),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isOutlined ? color.withOpacity(0.8) : color.withOpacity(0.3),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 2000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppTheme.cyan, width: 1),
        ),
      ),
    );
  }
}

