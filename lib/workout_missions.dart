import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Workout Mission Model
// ---------------------------------------------------------------------------

class WorkoutMission {
  final String id;
  final String title;
  final String subtitle;
  final String category; // 'Full Body', 'Push', 'Pull', 'Legs', 'Core', 'Cardio'
  final int durationMinutes;
  final int caloriesBurn;
  final String difficulty; // 'ง่าย', 'ปานกลาง', 'ท้าทาย'
  final Color difficultyColor;
  final int expReward;
  final int coinReward;
  final IconData icon;
  final List<String> exercises;
  final String targetMuscles;
  bool isCompletedToday;

  WorkoutMission({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.durationMinutes,
    required this.caloriesBurn,
    required this.difficulty,
    required this.difficultyColor,
    required this.expReward,
    required this.coinReward,
    required this.icon,
    required this.exercises,
    required this.targetMuscles,
    this.isCompletedToday = false,
  });
}

// ---------------------------------------------------------------------------
// Default Curated Missions
// ---------------------------------------------------------------------------

List<WorkoutMission> getDefaultWorkoutMissions() {
  return [
    WorkoutMission(
      id: 'm1',
      title: 'เผาผลาญไขมัน Full Body HIIT',
      subtitle: 'เบิร์นพลังงานสูงสุด กระตุ้นระบบเผาผลาญทั่วร่าง',
      category: 'Full Body',
      durationMinutes: 20,
      caloriesBurn: 220,
      difficulty: 'ปานกลาง',
      difficultyColor: const Color(0xFFF59E0B),
      expReward: 120,
      coinReward: 30,
      icon: Icons.local_fire_department_rounded,
      exercises: [
        'Jumping Jacks 45 วินาที (3 เซต)',
        'Burpees 12 ครั้ง (3 เซต)',
        'Mountain Climbers 40 วินาที (3 เซต)',
        'High Knees 30 วินาที (3 เซต)',
      ],
      targetMuscles: 'หัวใจ, ปอด, ขา, หน้าท้อง',
    ),
    WorkoutMission(
      id: 'm2',
      title: 'พลังอกและไหล่ Push Power',
      subtitle: 'สร้างกล้ามเนื้อส่วนบน อก ไหล่ และหลังแขนให้แน่น',
      category: 'Push',
      durationMinutes: 30,
      caloriesBurn: 260,
      difficulty: 'ท้าทาย',
      difficultyColor: const Color(0xFFEF4444),
      expReward: 150,
      coinReward: 40,
      icon: Icons.fitness_center_rounded,
      exercises: [
        'Dumbbell / Barbell Bench Press 4 เซต x 10 ครั้ง',
        'Incline Dumbbell Press 3 เซต x 12 ครั้ง',
        'Overhead Shoulder Press 3 เซต x 10 ครั้ง',
        'Tricep Dips หรือ Pushdown 3 เซต x 15 ครั้ง',
      ],
      targetMuscles: 'อกบน-กลาง, ไหล่หน้า, ไตรเซปส์',
    ),
    WorkoutMission(
      id: 'm3',
      title: 'ดึงหลังทรงพลัง Pull Master',
      subtitle: 'เสริมบุคลิกภาพ หลังตรง ปีกกว้าง และแขนหน้า',
      category: 'Pull',
      durationMinutes: 25,
      caloriesBurn: 240,
      difficulty: 'ปานกลาง',
      difficultyColor: const Color(0xFFF59E0B),
      expReward: 130,
      coinReward: 35,
      icon: Icons.sports_gymnastics_rounded,
      exercises: [
        'Lat Pulldown 4 เซต x 12 ครั้ง',
        'Seated Cable Row 3 เซต x 12 ครั้ง',
        'Face Pulls 3 เซต x 15 ครั้ง',
        'Dumbbell Bicep Curl 3 เซต x 12 ครั้ง',
      ],
      targetMuscles: 'หลังกว้าง (Lats), สะบัก, ไบเซปส์',
    ),
    WorkoutMission(
      id: 'm4',
      title: 'ขาเหล็กทรงพลัง Leg Destroyer',
      subtitle: 'สร้างฐานกำลังที่แข็งแกร่งที่สุดของร่างกาย',
      category: 'Legs',
      durationMinutes: 30,
      caloriesBurn: 310,
      difficulty: 'ท้าทาย',
      difficultyColor: const Color(0xFFEF4444),
      expReward: 160,
      coinReward: 45,
      icon: Icons.directions_run_rounded,
      exercises: [
        'Barbell Squats 4 เซต x 10 ครั้ง',
        'Romanian Deadlift 3 เซต x 12 ครั้ง',
        'Walking Lunges 3 เซต x 12 ก้าว/ข้าง',
        'Calf Raises 4 เซต x 15 ครั้ง',
      ],
      targetMuscles: 'ต้นขาหน้า, ก้น, แฮมสตริง, น่อง',
    ),
    WorkoutMission(
      id: 'm5',
      title: 'ซิกแพค & แกนกลางลำตัว Core Burn',
      subtitle: 'กระชับหน้าท้อง ลดเอว เพิ่มความมั่นคงให้กระดูกสันหลัง',
      category: 'Core',
      durationMinutes: 15,
      caloriesBurn: 140,
      difficulty: 'ง่าย',
      difficultyColor: const Color(0xFF10B981),
      expReward: 90,
      coinReward: 25,
      icon: Icons.accessibility_new_rounded,
      exercises: [
        'Plank Hold 60 วินาที (3 เซต)',
        'Russian Twist 3 เซต x 20 ครั้ง',
        'Hanging / Floor Leg Raises 3 เซต x 12 ครั้ง',
        'Bicycle Crunches 3 เซต x 20 ครั้ง',
      ],
      targetMuscles: 'หน้าท้องบน-ล่าง, เอวด้านข้าง, แกนกลางลำตัว',
    ),
  ];
}

// ---------------------------------------------------------------------------
// Mission Detail & Execution Bottom Sheet
// ---------------------------------------------------------------------------

void showWorkoutMissionModal({
  required BuildContext context,
  required WorkoutMission mission,
  required void Function(WorkoutMission mission) onCompleteMission,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _MissionModalContent(
      mission: mission,
      onCompleteMission: onCompleteMission,
    ),
  );
}

class _MissionModalContent extends StatefulWidget {
  final WorkoutMission mission;
  final void Function(WorkoutMission mission) onCompleteMission;

  const _MissionModalContent({
    required this.mission,
    required this.onCompleteMission,
  });

  @override
  State<_MissionModalContent> createState() => _MissionModalContentState();
}

class _MissionModalContentState extends State<_MissionModalContent> {
  late List<bool> _checkedExercises;

  @override
  void initState() {
    super.initState();
    _checkedExercises = List.filled(widget.mission.exercises.length, false);
  }

  int get _completedCount => _checkedExercises.where((c) => c).length;

  @override
  Widget build(BuildContext context) {
    final mission = widget.mission;
    final total = mission.exercises.length;
    final percent = total > 0 ? (_completedCount / total) : 0.0;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(mission.icon, color: const Color(0xFF10B981), size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: mission.difficultyColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              mission.difficulty,
                              style: TextStyle(
                                color: mission.difficultyColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            mission.category,
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        mission.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Mission stats pills
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMissionPill(
                  icon: Icons.timer_outlined,
                  color: const Color(0xFF0284C7),
                  title: '${mission.durationMinutes} นาที',
                  subtitle: 'ระยะเวลา',
                ),
                Container(width: 1, height: 26, color: const Color(0xFFE2E8F0)),
                _buildMissionPill(
                  icon: Icons.local_fire_department_rounded,
                  color: const Color(0xFFEF4444),
                  title: '${mission.caloriesBurn} kcal',
                  subtitle: 'พลังงานที่เผา',
                ),
                Container(width: 1, height: 26, color: const Color(0xFFE2E8F0)),
                _buildMissionPill(
                  icon: Icons.bolt_rounded,
                  color: const Color(0xFFF59E0B),
                  title: '+${mission.expReward} EXP',
                  subtitle: 'รางวัลเควส',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Progress status bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'รายการท่าฝึกในภารกิจนี้',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                    ),
                    Text(
                      '$_completedCount จาก $total ท่า (${(percent * 100).toInt()}%)',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF10B981)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: percent,
                    minHeight: 7,
                    backgroundColor: const Color(0xFFF1F5F9),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Exercises List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: mission.exercises.length,
              itemBuilder: (context, idx) {
                final ex = mission.exercises[idx];
                final isDone = _checkedExercises[idx];

                return InkWell(
                  onTap: () {
                    setState(() {
                      _checkedExercises[idx] = !_checkedExercises[idx];
                    });
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDone ? const Color(0xFFF0FDF4) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDone ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
                        width: isDone ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                          color: isDone ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            ex,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
                              color: isDone ? const Color(0xFF065F46) : const Color(0xFF1E293B),
                              decoration: isDone ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Target Muscles note
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFF64748B)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'กล้ามเนื้อเป้าหมาย: ${mission.targetMuscles}',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ),
              ],
            ),
          ),

          // Complete Button Footer
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onCompleteMission(mission);
                },
                icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                label: Text(
                  _completedCount == total
                      ? 'พิชิตภารกิจนี้สำเร็จ! (รับ +${mission.expReward} EXP)'
                      : 'บันทึกสำเร็จภารกิจ (${mission.durationMinutes} นาที)',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionPill({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
        ),
      ],
    );
  }
}
