import 'dart:async';

import 'package:flutter/material.dart';

import '../models/health_models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/source_badge.dart';

class TrackersScreen extends StatefulWidget {
  const TrackersScreen({super.key});

  @override
  State<TrackersScreen> createState() => _TrackersScreenState();
}

class _TrackersScreenState extends State<TrackersScreen> {
  Timer? _stopwatchTimer;
  int _activeSubTab = 0; // Nutrition, water, workouts, sleep

  @override
  void initState() {
    super.initState();
    _stopwatchTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        final state = AppScope.of(context);
        if (state.isLiveTimerRunning) {
          state.incrementLiveTimer();
        }
      }
    });
  }

  @override
  void dispose() {
    _stopwatchTimer?.cancel();
    super.dispose();
  }

  String _formatTimer(int totalSeconds) {
    final mins = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'บันทึกสุขภาพ',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'เลือกหมวดเพื่อเพิ่มหรือทบทวนข้อมูล',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 14),
            // Smartwatch Quick Sync Hero Card
            _buildSmartwatchSyncCard(context, appState),

            const SizedBox(height: 16),

            // Top Segment Switcher: Workouts vs Sleep
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.7,
                children: [
                  _buildSubTabButton(
                    index: 0,
                    label: 'อาหาร',
                    icon: Icons.restaurant_outlined,
                    isSelected: _activeSubTab == 0,
                  ),
                  _buildSubTabButton(
                    index: 1,
                    label: 'น้ำ',
                    icon: Icons.water_drop_outlined,
                    isSelected: _activeSubTab == 1,
                  ),
                  _buildSubTabButton(
                    index: 2,
                    label: 'ออกกำลัง',
                    icon: Icons.fitness_center_outlined,
                    isSelected: _activeSubTab == 2,
                  ),
                  _buildSubTabButton(
                    index: 3,
                    label: 'การนอน',
                    icon: Icons.bedtime_outlined,
                    isSelected: _activeSubTab == 3,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            if (_activeSubTab == 0) _buildNutritionSection(context, appState),
            if (_activeSubTab == 1) _buildWaterSection(context, appState),
            if (_activeSubTab == 2) _buildWorkoutSection(context, appState),
            if (_activeSubTab == 3) _buildSleepSection(context, appState),
          ],
        ),
      ),
    );
  }

  Widget _buildSubTabButton({
    required int index,
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: 'หมวด $label',
      child: InkWell(
        onTap: () => setState(() => _activeSubTab = index),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.cyan.withOpacity(0.18)
                : Theme.of(context).colorScheme.surface,
            border: Border.all(
              color: isSelected ? AppTheme.cyan : Colors.white12,
              width: isSelected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 21,
                color: isSelected ? AppTheme.cyan : AppTheme.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppTheme.cyan : AppTheme.textPrimary,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, size: 17, color: AppTheme.cyan),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionSection(BuildContext context, AppState state) {
    final meals = state.foodScans;
    final protein = meals.fold<double>(0, (sum, meal) => sum + meal.protein);
    final carbs = meals.fold<double>(0, (sum, meal) => sum + meal.carbs);
    final fat = meals.fold<double>(0, (sum, meal) => sum + meal.fat);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'พลังงานวันนี้',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                '${state.totalCaloriesIn} kcal',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: (state.totalCaloriesIn / 2000).clamp(0.0, 1.0),
                minHeight: 8,
              ),
              const SizedBox(height: 6),
              const Text(
                'เป้าหมายอ้างอิง 2,000 kcal • ควรปรับตามเป้าหมายส่วนตัว',
                style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _macroPill('โปรตีน', protein, AppTheme.cyan),
                  _macroPill('คาร์บ', carbs, AppTheme.amber),
                  _macroPill('ไขมัน', fat, AppTheme.rose),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showMealDialog(context, state),
            icon: const Icon(Icons.add),
            label: const Text('บันทึกอาหารด้วยตนเอง'),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'รายการอาหาร',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        if (meals.isEmpty)
          const Text(
            'ยังไม่มีรายการอาหาร',
            style: TextStyle(color: AppTheme.textMuted),
          ),
        ...meals.map(
          (meal) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Text(meal.emoji, style: const TextStyle(fontSize: 24)),
            title: Text(meal.foodName),
            subtitle: Text(
              'P ${meal.protein}g • C ${meal.carbs}g • F ${meal.fat}g',
            ),
            trailing: Text(
              '${meal.calories} kcal',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _macroPill(String label, double amount, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      '$label ${amount.round()}g',
      style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
    ),
  );

  Widget _buildWaterSection(BuildContext context, AppState state) {
    final remaining = (state.waterGoalMl - state.waterMl).clamp(
      0,
      state.waterGoalMl,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'น้ำที่ดื่มวันนี้',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                '${state.waterMl} / ${state.waterGoalMl} ml',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: state.waterProgress,
                minHeight: 10,
              ),
              const SizedBox(height: 6),
              Text(
                remaining == 0
                    ? 'ถึงเป้าหมายแล้ว'
                    : 'เหลืออีก $remaining ml ถึงเป้าหมาย',
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [150, 250, 500]
              .map(
                (ml) => OutlinedButton(
                  onPressed: () => state.addWater(ml),
                  child: Text('+$ml ml'),
                ),
              )
              .toList(),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showCustomWaterDialog(context, state),
            icon: const Icon(Icons.edit),
            label: const Text('กำหนดปริมาณเอง'),
          ),
        ),
      ],
    );
  }

  Future<void> _showCustomWaterDialog(
    BuildContext context,
    AppState state,
  ) async {
    final controller = TextEditingController();
    final amount = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('บันทึกปริมาณน้ำ'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'มิลลิลิตร',
            suffixText: 'ml',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ยกเลิก'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, int.tryParse(controller.text)),
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (amount != null && amount > 0) state.addWater(amount);
  }

  Future<void> _showMealDialog(BuildContext context, AppState state) async {
    final fields = List.generate(5, (_) => TextEditingController());
    const labels = [
      'ชื่ออาหาร',
      'พลังงาน (kcal)',
      'โปรตีน (g)',
      'คาร์โบไฮเดรต (g)',
      'ไขมัน (g)',
    ];
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('บันทึกมื้ออาหาร'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              fields.length,
              (i) => TextField(
                controller: fields[i],
                keyboardType: i == 0
                    ? TextInputType.text
                    : const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: labels[i]),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('ยกเลิก'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );
    if (saved == true && fields[0].text.trim().isNotEmpty) {
      state.logMeal(
        name: fields[0].text.trim(),
        calories: int.tryParse(fields[1].text) ?? 0,
        protein: double.tryParse(fields[2].text) ?? 0,
        carbs: double.tryParse(fields[3].text) ?? 0,
        fat: double.tryParse(fields[4].text) ?? 0,
      );
    }
    for (final field in fields) {
      field.dispose();
    }
  }

  // Smartwatch Sync Card (Apple Health / Google Fit)
  Widget _buildSmartwatchSyncCard(BuildContext context, AppState appState) {
    return GlassCard(
      gradient: const LinearGradient(
        colors: [Color(0xFF0E7490), Color(0xFF164E63), Color(0xFF1E293B)],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.3),
              border: Border.all(color: AppTheme.cyan),
            ),
            child: const Icon(Icons.watch, color: AppTheme.cyan, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Apple Health / Smartwatch',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SourceBadge(source: appState.stepsSource, compact: true),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  appState.cloudSyncStatus,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '👣 ${appState.stepsToday} ก้าว',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.mint,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '🔥 ${appState.activeCalories} Active kcal',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.amber,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Workout Planner & Live Tracker View
  Widget _buildWorkoutSection(BuildContext context, AppState appState) {
    final livePlan = appState.activeLiveWorkout;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Live Tracker Banner (If in progress)
        if (livePlan != null) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF991B1B), Color(0xFF1E293B)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.rose, width: 1.5),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.timer, color: AppTheme.rose, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'Live Workout: ${livePlan.title}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _formatTimer(appState.liveSecondsElapsed),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.amber,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Live Exercise Checkboxes
                ...livePlan.exercises.map((ex) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: ex.isCompleted,
                          activeColor: AppTheme.mint,
                          onChanged: (_) =>
                              appState.toggleExerciseSet(livePlan.id, ex.id),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ex.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${ex.targetSets} เซ็ต x ${ex.reps} ครั้ง (${ex.weightKg > 0 ? '${ex.weightKg}kg' : 'Bodyweight'})',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => appState.toggleLiveTimer(),
                        child: Text(
                          appState.isLiveTimerRunning
                              ? '⏸️ หยุดชั่วคราว'
                              : '▶️ เริ่มต่อ',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.mint,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () => _showFinishWorkoutDialog(
                          context,
                          appState,
                          livePlan,
                        ),
                        child: const Text(
                          '🏁 บันทึกและจบเซสชั่น',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Weekly Schedule List
        const Text(
          'โปรแกรมออกกำลังกายของฉัน',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _showCreateWorkoutDialog(context, appState),
            icon: const Icon(Icons.add),
            label: const Text('สร้างโปรแกรมหรือกิจกรรมเอง'),
          ),
        ),
        const SizedBox(height: 10),

        ...appState.workoutPlans.map((plan) {
          final volumeKg = plan.exercises.fold<double>(
            0,
            (sum, exercise) =>
                sum + exercise.targetSets * exercise.reps * exercise.weightKg,
          );
          return GlassCard(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.rose.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.fitness_center,
                            size: 20,
                            color: AppTheme.rose,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan.title,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${plan.dayOfWeek} • ${plan.targetDurationMinutes} นาที',
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (plan.isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.mint.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'สำเร็จแล้ว ✓',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.mint,
                          ),
                        ),
                      )
                    else
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.cyan,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          minimumSize: const Size(60, 30),
                        ),
                        onPressed: () => appState.startLiveWorkout(plan),
                        child: const Text(
                          'เริ่มฝึก',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'ปริมาณยกตามแผน ${volumeKg.round()} kg • ${plan.exercises.fold<int>(0, (sum, e) => sum + e.targetSets)} เซ็ต',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'คำนวณจาก น้ำหนัก × ครั้ง × เซ็ต; ไม่รวมท่าบอดี้เวต',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Future<void> _showCreateWorkoutDialog(
    BuildContext context,
    AppState appState,
  ) async {
    final title = TextEditingController();
    final exercises = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('สร้างโปรแกรมฝึก'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: 'ชื่อโปรแกรม เช่น โยคะเช้า / วิ่ง'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: exercises,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'กิจกรรมหรือท่าฝึก คั่นด้วยจุลภาค',
                hintText: 'เดินเร็ว, ยืดเหยียด, Plank',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('ยกเลิก')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('สร้าง')),
        ],
      ),
    );
    if (saved == true) {
      appState.addCustomWorkoutPlan(
        title.text,
        exercises.text.split(','),
      );
    }
    title.dispose();
    exercises.dispose();
  }

  // Sleep Tracker & Sleep Stages View
  Widget _buildSleepSection(BuildContext context, AppState appState) {
    final sleep = appState.sleepData;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sleep Overview Card
        GlassCard(
          gradient: const LinearGradient(
            colors: [Color(0xFF2E1065), Color(0xFF1E1B4B)],
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ระยะเวลานอนหลับเมื่อคืน',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  SourceBadge(source: sleep.source, compact: true),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${sleep.durationHours} ชั่วโมง',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.mint.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.mint),
                    ),
                    child: Text(
                      'คุณภาพ ${sleep.qualityScore}/100 ดีมาก',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.mint,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (sleep.source != HealthDataSource.manualInput)
                Row(
                  children: [
                    _buildSleepStageBar(
                      'หลับลึก (Deep)',
                      '${sleep.deepSleepHours}h',
                      const Color(0xFF6366F1),
                    ),
                    const SizedBox(width: 8),
                    _buildSleepStageBar(
                      'REM Sleep',
                      '${sleep.remSleepHours}h',
                      const Color(0xFFA855F7),
                    ),
                    const SizedBox(width: 8),
                    _buildSleepStageBar(
                      'หลับตื้น (Light)',
                      '${sleep.lightSleepHours}h',
                      const Color(0xFF38BDF8),
                    ),
                  ],
                )
              else
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ระยะหลับลึก/REM จะแสดงเมื่อซิงก์จากอุปกรณ์ที่รองรับ',
                    style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => _showSleepLogDialog(context, appState),
            icon: const Icon(Icons.edit_calendar_outlined),
            label: const Text('บันทึกหรือแก้ไขเวลานอน'),
          ),
        ),

        const SizedBox(height: 12),

        Text(
          appState.sleepData.durationHours >= 7
              ? 'เมื่อคืนได้นอนอย่างน้อย 7 ชั่วโมง'
              : 'บันทึกเวลานอนต่อเนื่องเพื่อดูแนวโน้มการพักผ่อน',
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSleepStageBar(String label, String hours, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 9.5,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hours,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSleepLogDialog(BuildContext context, AppState state) async {
    var bedTime = TimeOfDay.fromDateTime(state.sleepData.bedTime);
    var wakeTime = TimeOfDay.fromDateTime(state.sleepData.wakeTime);
    var quality = state.sleepData.qualityScore.toDouble();
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('บันทึกการนอน'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('เวลาเข้านอน'),
                trailing: Text(bedTime.format(context)),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: bedTime,
                  );
                  if (picked != null) setDialogState(() => bedTime = picked);
                },
              ),
              ListTile(
                title: const Text('เวลาตื่น'),
                trailing: Text(wakeTime.format(context)),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: wakeTime,
                  );
                  if (picked != null) setDialogState(() => wakeTime = picked);
                },
              ),
              Text('คุณภาพการนอน ${quality.round()}/100'),
              Slider(
                value: quality,
                min: 0,
                max: 100,
                divisions: 20,
                label: quality.round().toString(),
                onChanged: (value) => setDialogState(() => quality = value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('ยกเลิก'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('บันทึก'),
            ),
          ],
        ),
      ),
    );
    if (saved != true) return;
    final now = DateTime.now();
    var bed = DateTime(
      now.year,
      now.month,
      now.day,
      bedTime.hour,
      bedTime.minute,
    );
    var wake = DateTime(
      now.year,
      now.month,
      now.day,
      wakeTime.hour,
      wakeTime.minute,
    );
    if (!wake.isAfter(bed)) wake = wake.add(const Duration(days: 1));
    final duration = wake.difference(bed).inMinutes / 60;
    state.recordSleep(
      durationHours: duration,
      qualityScore: quality.round(),
      bedTime: bed,
      wakeTime: wake,
    );
  }

  void _showFinishWorkoutDialog(
    BuildContext context,
    AppState appState,
    WorkoutPlan plan,
  ) {
    final durationMinutes = (appState.liveSecondsElapsed / 60).ceil();
    appState.finishLiveWorkout(plan);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppTheme.mint, width: 1.5),
        ),
        title: const Row(
          children: [
            Text('🏆', style: TextStyle(fontSize: 26)),
            SizedBox(width: 8),
            Text(
              'พิชิตเวิร์กเอาต์สำเร็จ!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'บันทึกเซสชัน "${plan.title}" แล้ว',
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'เวลาออกกำลังกาย: ',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                      Text(
                        '$durationMinutes นาที',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.cyan,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'พลังงานที่ใช้ (ตามแผน): ',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                      Text(
                        'ประมาณ ${plan.estimatedCalories} kcal',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.amber,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.cyan,
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'ยอดเยี่ยม!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
