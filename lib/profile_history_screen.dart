import 'package:flutter/material.dart';
import 'nutrition_tracker.dart';
import 'theme/app_theme.dart';

// ---------------------------------------------------------------------------
// Unified History Item Model
// ---------------------------------------------------------------------------

enum HistoryType { workout, meal, water, sleep }

class UnifiedHistoryItem {
  final String id;
  final HistoryType type;
  final String title;
  final String subtitle;
  final DateTime date;
  final IconData icon;
  final Color color;
  final String? badgeText;
  final Color? badgeColor;

  UnifiedHistoryItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.icon,
    required this.color,
    this.badgeText,
    this.badgeColor,
  });
}

// ---------------------------------------------------------------------------
// Profile & Unified History Screen
// ---------------------------------------------------------------------------

class ProfileHistoryScreen extends StatefulWidget {
  final int userLevel;
  final int userExp;
  final int userExpMax;
  final int userCoins;
  final int userStreak;
  final bool isSubscribed;
  final List<dynamic> workoutRecords; // List<WorkoutRecord>
  final List<MealLog> meals;
  final List<dynamic> waterLogs; // List<WaterLog>
  final List<dynamic> sleepRecords; // List<SleepRecord>
  final VoidCallback? onOpenSubscription;

  const ProfileHistoryScreen({
    super.key,
    this.userLevel = 5,
    this.userExp = 420,
    this.userExpMax = 600,
    this.userCoins = 350,
    this.userStreak = 7,
    this.isSubscribed = false,
    this.workoutRecords = const [],
    this.meals = const [],
    this.waterLogs = const [],
    this.sleepRecords = const [],
    this.onOpenSubscription,
  });

  @override
  State<ProfileHistoryScreen> createState() => _ProfileHistoryScreenState();
}

class _ProfileHistoryScreenState extends State<ProfileHistoryScreen> {
  HistoryType? _selectedFilter; // null = all

  List<UnifiedHistoryItem> _buildUnifiedHistory() {
    final List<UnifiedHistoryItem> items = [];

    // 1. Workouts
    for (int i = 0; i < widget.workoutRecords.length; i++) {
      final w = widget.workoutRecords[i];
      items.add(
        UnifiedHistoryItem(
          id: 'w_$i',
          type: HistoryType.workout,
          title: '${w.category} Day (${w.durationMinutes} นาที)',
          subtitle: w.exercises.toString(),
          date: w.date as DateTime,
          icon: Icons.fitness_center_rounded,
          color: const Color(0xFF10B981),
          badgeText: '~${w.durationMinutes * 8} kcal',
          badgeColor: const Color(0xFF059669),
        ),
      );
    }

    // 2. Meals
    for (int i = 0; i < widget.meals.length; i++) {
      final m = widget.meals[i];
      items.add(
        UnifiedHistoryItem(
          id: 'm_$i',
          type: HistoryType.meal,
          title: '${m.emoji} ${m.name} (${m.typeName})',
          subtitle: '${m.calories} kcal • P: ${m.protein.toStringAsFixed(0)}g | C: ${m.carbs.toStringAsFixed(0)}g | F: ${m.fat.toStringAsFixed(0)}g',
          date: m.time,
          icon: Icons.restaurant_rounded,
          color: const Color(0xFFD97706),
          badgeText: m.isClean ? 'อาหารคลีน ✓' : 'มื้อทั่วไป',
          badgeColor: m.isClean ? const Color(0xFF059669) : const Color(0xFFD97706),
        ),
      );
    }

    // 3. Water logs
    for (int i = 0; i < widget.waterLogs.length; i++) {
      final wl = widget.waterLogs[i];
      items.add(
        UnifiedHistoryItem(
          id: 'wl_$i',
          type: HistoryType.water,
          title: 'ดื่มน้ำ +${wl.amount} ml',
          subtitle: 'เติมความชุ่มชื้นให้ร่างกาย',
          date: wl.time as DateTime,
          icon: Icons.water_drop_rounded,
          color: const Color(0xFF0284C7),
          badgeText: '+${wl.amount} ml',
          badgeColor: const Color(0xFF0284C7),
        ),
      );
    }

    // 4. Sleep logs
    for (int i = 0; i < widget.sleepRecords.length; i++) {
      final s = widget.sleepRecords[i];
      items.add(
        UnifiedHistoryItem(
          id: 's_$i',
          type: HistoryType.sleep,
          title: 'นอนหลับ ${s.hours} ชม. (${s.quality})',
          subtitle: 'ช่วงเวลา: ${s.bedTime.format(context)} - ${s.wakeTime.format(context)}',
          date: s.date as DateTime,
          icon: Icons.bedtime_rounded,
          color: const Color(0xFF6366F1),
          badgeText: s.quality as String,
          badgeColor: const Color(0xFF6366F1),
        ),
      );
    }

    // Fallback sample items if empty
    if (items.isEmpty) {
      final now = DateTime.now();
      items.addAll([
        UnifiedHistoryItem(
          id: 'sample_w1',
          type: HistoryType.workout,
          title: 'Push Day - อก ไหล่ หลังแขน (45 นาที)',
          subtitle: 'Bench Press, Incline Dumbbell, Lateral Raise, Tricep Rope',
          date: now.subtract(const Duration(hours: 4)),
          icon: Icons.fitness_center_rounded,
          color: const Color(0xFF10B981),
          badgeText: '~360 kcal',
          badgeColor: const Color(0xFF059669),
        ),
        UnifiedHistoryItem(
          id: 'sample_m1',
          type: HistoryType.meal,
          title: '🥗 สลัดอกไก่ย่างควินัว (มื้อกลางวัน)',
          subtitle: '450 kcal • P: 38g | C: 42g | F: 12g',
          date: now.subtract(const Duration(hours: 6)),
          icon: Icons.restaurant_rounded,
          color: const Color(0xFFD97706),
          badgeText: 'อาหารคลีน ✓',
          badgeColor: const Color(0xFF059669),
        ),
        UnifiedHistoryItem(
          id: 'sample_wl1',
          type: HistoryType.water,
          title: 'ดื่มน้ำบริสุทธิ์ +750 ml',
          subtitle: 'เติมความชุ่มชื้น & เพิ่ม MP',
          date: now.subtract(const Duration(hours: 7)),
          icon: Icons.water_drop_rounded,
          color: const Color(0xFF0284C7),
          badgeText: '+750 ml',
          badgeColor: const Color(0xFF0284C7),
        ),
        UnifiedHistoryItem(
          id: 'sample_s1',
          type: HistoryType.sleep,
          title: 'นอนหลับ 7.5 ชม. (ดีมาก)',
          subtitle: 'หลับลึก 2.2 ชม. • REM 1.8 ชม. (ซิงค์ผ่าน Apple Watch)',
          date: now.subtract(const Duration(hours: 12)),
          icon: Icons.bedtime_rounded,
          color: const Color(0xFF6366F1),
          badgeText: 'คะแนน 88/100',
          badgeColor: const Color(0xFF6366F1),
        ),
      ]);
    }

    // Sort newest first
    items.sort((a, b) => b.date.compareTo(a.date));

    // Filter
    if (_selectedFilter != null) {
      return items.where((item) => item.type == _selectedFilter).toList();
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final historyList = _buildUnifiedHistory();
    final totalWorkoutMins = widget.workoutRecords.fold<int>(0, (sum, w) => sum + (w.durationMinutes as int));
    final totalBurned = totalWorkoutMins * 8;
    final totalWaterMl = widget.waterLogs.fold<int>(0, (sum, w) => sum + (w.amount as int));
    final totalCals = widget.meals.fold<int>(0, (sum, m) => sum + m.calories);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('โปรไฟล์ & ประวัติสุขภาพ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'ส่งออกรายงานประวัติ',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    widget.isSubscribed
                        ? '📄 ส่งออกรายงานประวัติสุขภาพ PDF สำเร็จแล้ว (VIP Pro)!'
                        : '🔒 สมัคร VIP Pro เพื่อส่งออกรายงานประวัติสุขภาพ PDF แบบละเอียด',
                  ),
                  action: widget.isSubscribed
                      ? null
                      : SnackBarAction(
                          label: 'ดูแพ็กเกจ',
                          onPressed: widget.onOpenSubscription ?? () {},
                        ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // User Profile Card
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF0369A1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(color: Color(0x22000000), blurRadius: 18, offset: Offset(0, 6)),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Avatar with Level Ring
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFFCD34D)]),
                          ),
                          padding: const EdgeInsets.all(3),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF0F172A),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text('🏋️', style: TextStyle(fontSize: 28)),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF0F172A), width: 1.5),
                          ),
                          child: Text(
                            'LV.${widget.userLevel}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),

                    // User Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'คุณ (นักรบสุขภาพ)',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 6),
                              if (widget.isSubscribed)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF59E0B),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text('VIP', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Gold League 🏆 • สายสุขภาพครบวงจร',
                            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text('🪙 ${widget.userCoins} Coins', style: const TextStyle(color: Color(0xFFFDE68A), fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDC2626).withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text('🔥 สตรีค ${widget.userStreak} วัน', style: const TextStyle(color: Color(0xFFFCA5A5), fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // EXP Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('EXP เพื่อขึ้นสู่เลเวลถัดไป', style: TextStyle(color: Colors.white70, fontSize: 11)),
                        Text('${widget.userExp} / ${widget.userExpMax} EXP', style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: (widget.userExp / widget.userExpMax).clamp(0.0, 1.0),
                        minHeight: 8,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF38BDF8)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // VIP Status button
                InkWell(
                  onTap: widget.onOpenSubscription,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: widget.isSubscribed ? const Color(0xFFF59E0B).withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: widget.isSubscribed ? const Color(0xFFF59E0B) : Colors.white24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.workspace_premium_rounded, color: widget.isSubscribed ? const Color(0xFFF59E0B) : Colors.white70, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              widget.isSubscribed ? 'สมาชิก Health Pro VIP (ใช้งานอยู่)' : 'อัปเกรดเป็น Health Pro VIP',
                              style: TextStyle(
                                color: widget.isSubscribed ? const Color(0xFFFDE68A) : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Lifetime Stats Grid
          const Text('ภาพรวมสถิติสะสม', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(child: _buildStatTile('ออกกำลังกาย', '$totalWorkoutMins นาที', '~$totalBurned kcal 🔥', Icons.fitness_center_rounded, const Color(0xFF10B981))),
              const SizedBox(width: 10),
              Expanded(child: _buildStatTile('อาหารที่บันทึก', '${widget.meals.length} มื้อ', '$totalCals kcal รวม', Icons.restaurant_rounded, const Color(0xFFD97706))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildStatTile('น้ำดื่มสะสม', '${(totalWaterMl / 1000).toStringAsFixed(1)} ลิตร', '${widget.waterLogs.length} ครั้ง', Icons.water_drop_rounded, const Color(0xFF0284C7))),
              const SizedBox(width: 10),
              Expanded(child: _buildStatTile('การนอนหลับ', '${widget.sleepRecords.length} บันทึก', 'เฉลี่ย 8.0 ชม./คืน', Icons.bedtime_rounded, const Color(0xFF6366F1))),
            ],
          ),

          const SizedBox(height: 24),

          // History Feed Header & Filters
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('ประวัติกิจกรรมทั้งหมด', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
              Text('${historyList.length} รายการ', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('ทั้งหมด', null),
                const SizedBox(width: 6),
                _buildFilterChip('🏋️ ออกกำลังกาย', HistoryType.workout),
                const SizedBox(width: 6),
                _buildFilterChip('🥗 การกิน', HistoryType.meal),
                const SizedBox(width: 6),
                _buildFilterChip('💧 ดื่มน้ำ', HistoryType.water),
                const SizedBox(width: 6),
                _buildFilterChip('💤 การนอน', HistoryType.sleep),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Feed List
          if (historyList.isEmpty)
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white12),
              ),
              child: const Center(
                child: Text('ไม่พบรายการประวัติในหมวดนี้', style: TextStyle(color: Color(0xFF94A3B8))),
              ),
            )
          else
            ...historyList.map((item) => _buildHistoryCard(item)),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, HistoryType? type) {
    final isSelected = _selectedFilter == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) setState(() => _selectedFilter = type);
      },
      selectedColor: const Color(0xFF0284C7),
      labelStyle: TextStyle(
        fontSize: 11,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        color: isSelected ? Colors.white : const Color(0xFF475569),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      side: BorderSide(color: isSelected ? const Color(0xFF0284C7) : const Color(0xFFE2E8F0)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildStatTile(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)), maxLines: 1),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(UnifiedHistoryItem item) {
    final timeStr = '${item.date.hour.toString().padLeft(2, '0')}:${item.date.minute.toString().padLeft(2, '0')} น.';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
        boxShadow: const [BoxShadow(color: Color(0x04000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: item.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                      ),
                    ),
                    Text(timeStr, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), height: 1.3),
                ),
                if (item.badgeText != null) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: (item.badgeColor ?? item.color).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.badgeText!,
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: item.badgeColor ?? item.color),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

