import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Data Models for Custom Routine & Review
// ---------------------------------------------------------------------------

class RoutineExercise {
  final String id;
  final String name;
  final String muscle;
  int sets;
  int reps;
  double weightKg;
  bool isCompound;

  RoutineExercise({
    required this.id,
    required this.name,
    required this.muscle,
    this.sets = 3,
    this.reps = 10,
    this.weightKg = 0,
    this.isCompound = false,
  });

  RoutineExercise copy() {
    return RoutineExercise(
      id: id,
      name: name,
      muscle: muscle,
      sets: sets,
      reps: reps,
      weightKg: weightKg,
      isCompound: isCompound,
    );
  }
}

class RoutineAnalysis {
  final double score; // 0.0 - 10.0
  final String grade; // เช่น 'ยอดเยี่ยม (S)', 'สมดุลดีมาก (A)'
  final Color gradeColor;
  final int totalSets;
  final int estimatedMinutes;
  final int estimatedCalories;
  final Map<String, double> muscleDistribution; // muscle name -> percentage
  final List<String> pros;
  final List<String> recommendations;
  final String aiCoachVerdict;
  final String hypertrophyRating; // ต่ำ, เหมาะสม, สูงมาก

  RoutineAnalysis({
    required this.score,
    required this.grade,
    required this.gradeColor,
    required this.totalSets,
    required this.estimatedMinutes,
    required this.estimatedCalories,
    required this.muscleDistribution,
    required this.pros,
    required this.recommendations,
    required this.aiCoachVerdict,
    required this.hypertrophyRating,
  });
}

// ---------------------------------------------------------------------------
// Pre-defined Exercise Library
// ---------------------------------------------------------------------------

final List<RoutineExercise> exerciseLibrary = [
  // อก (Chest)
  RoutineExercise(id: 'c1', name: 'Barbell Bench Press', muscle: 'อก', sets: 4, reps: 8, isCompound: true),
  RoutineExercise(id: 'c2', name: 'Incline Dumbbell Press', muscle: 'อก', sets: 3, reps: 10, isCompound: true),
  RoutineExercise(id: 'c3', name: 'Cable Chest Fly', muscle: 'อก', sets: 3, reps: 12),
  RoutineExercise(id: 'c4', name: 'Push-up (วิดพื้น)', muscle: 'อก', sets: 3, reps: 15, isCompound: true),
  RoutineExercise(id: 'c5', name: 'Dips', muscle: 'อก', sets: 3, reps: 10, isCompound: true),

  // หลัง (Back)
  RoutineExercise(id: 'b1', name: 'Deadlift', muscle: 'หลัง', sets: 4, reps: 6, isCompound: true),
  RoutineExercise(id: 'b2', name: 'Lat Pulldown', muscle: 'หลัง', sets: 4, reps: 10, isCompound: true),
  RoutineExercise(id: 'b3', name: 'Barbell Bent-Over Row', muscle: 'หลัง', sets: 4, reps: 8, isCompound: true),
  RoutineExercise(id: 'b4', name: 'Seated Cable Row', muscle: 'หลัง', sets: 3, reps: 12),
  RoutineExercise(id: 'b5', name: 'Pull-up (ดึงข้อ)', muscle: 'หลัง', sets: 3, reps: 8, isCompound: true),

  // ไหล่ (Shoulders)
  RoutineExercise(id: 's1', name: 'Overhead Shoulder Press', muscle: 'ไหล่', sets: 4, reps: 8, isCompound: true),
  RoutineExercise(id: 's2', name: 'Dumbbell Lateral Raise', muscle: 'ไหล่', sets: 4, reps: 15),
  RoutineExercise(id: 's3', name: 'Face Pull (บ่า/หลังไหล่)', muscle: 'ไหล่', sets: 3, reps: 15),
  RoutineExercise(id: 's4', name: 'Rear Delt Fly', muscle: 'ไหล่', sets: 3, reps: 12),

  // แขน (Arms)
  RoutineExercise(id: 'a1', name: 'Barbell Bicep Curl', muscle: 'แขน', sets: 3, reps: 10),
  RoutineExercise(id: 'a2', name: 'Hammer Curl', muscle: 'แขน', sets: 3, reps: 12),
  RoutineExercise(id: 'a3', name: 'Tricep Rope Pushdown', muscle: 'แขน', sets: 3, reps: 12),
  RoutineExercise(id: 'a4', name: 'Skull Crusher', muscle: 'แขน', sets: 3, reps: 10),

  // ขา & ก้น (Legs & Glutes)
  RoutineExercise(id: 'l1', name: 'Barbell Back Squat', muscle: 'ขา', sets: 4, reps: 8, isCompound: true),
  RoutineExercise(id: 'l2', name: 'Romanian Deadlift (RDL)', muscle: 'ขา', sets: 3, reps: 10, isCompound: true),
  RoutineExercise(id: 'l3', name: 'Leg Press', muscle: 'ขา', sets: 4, reps: 10, isCompound: true),
  RoutineExercise(id: 'l4', name: 'Walking Lunge', muscle: 'ขา', sets: 3, reps: 12, isCompound: true),
  RoutineExercise(id: 'l5', name: 'Standing Calf Raise', muscle: 'ขา', sets: 4, reps: 15),

  // แกนกลางลำตัว & คาร์ดิโอ (Core & Cardio)
  RoutineExercise(id: 'co1', name: 'Plank (เกร็งหน้าท้อง)', muscle: 'ท้อง', sets: 3, reps: 45),
  RoutineExercise(id: 'co2', name: 'Hanging Leg Raise', muscle: 'ท้อง', sets: 3, reps: 12),
  RoutineExercise(id: 'co3', name: 'Russian Twist', muscle: 'ท้อง', sets: 3, reps: 20),
  RoutineExercise(id: 'co4', name: 'Burpees (เบิร์นไขมัน)', muscle: 'คาร์ดิโอ', sets: 3, reps: 12, isCompound: true),
];

// ---------------------------------------------------------------------------
// Routine Analyzer Algorithm
// ---------------------------------------------------------------------------

RoutineAnalysis analyzeRoutine(List<RoutineExercise> exercises) {
  if (exercises.isEmpty) {
    return RoutineAnalysis(
      score: 0,
      grade: 'ยังไม่มีท่าฝึก',
      gradeColor: Colors.grey,
      totalSets: 0,
      estimatedMinutes: 0,
      estimatedCalories: 0,
      muscleDistribution: {},
      pros: ['กรุณาเพิ่มท่าฝึกอย่างน้อย 1 ท่าเพื่อรับการวิเคราะห์'],
      recommendations: ['แตะที่ปุ่ม "+ เพิ่มท่าฝึก" หรือเลือกจากคลังท่าด้านล่าง'],
      aiCoachVerdict: 'ยังไม่มีข้อมูลท่าฝึกสำหรับวิเคราะห์',
      hypertrophyRating: 'ไม่มี',
    );
  }

  int totalSets = 0;
  int compoundCount = 0;
  final Map<String, int> muscleSets = {};

  for (final ex in exercises) {
    totalSets += ex.sets;
    if (ex.isCompound) compoundCount++;
    muscleSets[ex.muscle] = (muscleSets[ex.muscle] ?? 0) + ex.sets;
  }

  // Calculate percentage
  final Map<String, double> distribution = {};
  for (final entry in muscleSets.entries) {
    distribution[entry.key] = (entry.value / totalSets) * 100.0;
  }

  // Estimated duration & calories
  // Avg 2.5 mins per set (set + rest) + 5 min warmup
  final estimatedMinutes = (totalSets * 2.5).round() + 5;
  // Avg 6-8 kcal per min of resistance training
  final estimatedCalories = (estimatedMinutes * 7.5).round();

  // Scoring
  double score = 7.0; // Base score
  final List<String> pros = [];
  final List<String> recommendations = [];

  // 1. Compound movements
  if (compoundCount >= 2) {
    score += 1.2;
    pros.add('มีท่า Compound ($compoundCount ท่า) ซึ่งเป็นหัวใจสำคัญในการกระตุ้นฮอร์โมนสร้างกล้ามเนื้อและเผาผลาญ');
  } else if (compoundCount == 1) {
    score += 0.5;
    pros.add('มีท่า Compound พื้นฐาน 1 ท่า ช่วยให้ระบบประสาทและกล้ามเนื้อทำงานร่วมกันได้ดี');
  } else {
    recommendations.add('แนะนำเพิ่มท่า Compound เช่น Bench Press, Squat หรือ Lat Pulldown เพื่อผลลัพธ์ที่ดียิ่งขึ้น');
  }

  // 2. Total Volume Check
  if (totalSets >= 10 && totalSets <= 20) {
    score += 1.0;
    pros.add('ปริมาณเซตรวม ($totalSets เซต) อยู่ในระดับ Gold Standard สำหรับการสร้างกล้ามเนื้อ (Hypertrophy)');
  } else if (totalSets < 10) {
    score += 0.2;
    recommendations.add('ปริมาณเซตรวม $totalSets เซตค่อนข้างเบา เหมาะสำหรับวันพักฟื้น หรือเพิ่มอีก 1-2 ท่าเพื่อให้ถึงเกณฑ์ 10-15 เซต');
  } else {
    score -= 0.5;
    recommendations.add('ปริมาณเซตรวม $totalSets เซตเริ่มสูง ระวังอาการล้าสะสม (Overtraining) อย่าลืมพักระหว่างวันอย่างน้อย 48 ชม.');
  }

  // 3. Balance distribution
  final muscleCount = muscleSets.keys.length;
  if (muscleCount >= 2 && muscleCount <= 4) {
    score += 0.8;
    pros.add('โฟกัสกลุ่มกล้ามเนื้อสัมพันธ์กันได้ดี ($muscleCount กลุ่ม) ไม่กระจายจนเกินไป');
  }

  // Clamping score
  score = score.clamp(1.0, 9.9);

  // Grade & Color
  String grade;
  Color gradeColor;
  if (score >= 9.0) {
    grade = 'ยอดเยี่ยมระดับ S (Optimal Split)';
    gradeColor = const Color(0xFF10B981);
  } else if (score >= 8.0) {
    grade = 'สมดุลดีมาก (Tier A)';
    gradeColor = const Color(0xFF0284C7);
  } else if (score >= 7.0) {
    grade = 'มาตรฐานใช้ได้ (Tier B)';
    gradeColor = const Color(0xFFF59E0B);
  } else {
    grade = 'ควรปรับแก้เพิ่ม (Tier C)';
    gradeColor = const Color(0xFFEF4444);
  }

  // Hypertrophy Rating
  String hypertrophyRating;
  if (totalSets >= 12 && totalSets <= 18) {
    hypertrophyRating = 'สูงสุด (Optimal Hypertrophy)';
  } else if (totalSets >= 8) {
    hypertrophyRating = 'ปานกลาง (Strength & Maintenance)';
  } else {
    hypertrophyRating = 'เริ่มต้น (Active Recovery)';
  }

  // Coach verdict
  String verdict = 'ตารางนี้มีความเข้มข้นที่เหมาะสม ใช้เวลาประมาณ $estimatedMinutes นาที เบิร์น ~$estimatedCalories kcal ';
  if (compoundCount >= 2) {
    verdict += 'เน้นการพัฒนาพละกำลังและความคมชัดของกล้ามเนื้อได้ตรงจุด แนะนำจิบน้ำทุก 15 นาที และทานโปรตีนหลังฝึก 25-30g ครับ!';
  } else {
    verdict += 'เหมาะสำหรับการวอร์มร่างกายหรือวันที่เวลาจำกัด แนะนำโฟกัสจังหวะบีบเกร็ง (Mind-Muscle Connection) ให้เต็มที่ครับ!';
  }

  return RoutineAnalysis(
    score: double.parse(score.toStringAsFixed(1)),
    grade: grade,
    gradeColor: gradeColor,
    totalSets: totalSets,
    estimatedMinutes: estimatedMinutes,
    estimatedCalories: estimatedCalories,
    muscleDistribution: distribution,
    pros: pros,
    recommendations: recommendations,
    aiCoachVerdict: verdict,
    hypertrophyRating: hypertrophyRating,
  );
}

// ---------------------------------------------------------------------------
// Routine Builder BottomSheet Modal
// ---------------------------------------------------------------------------

void showRoutineBuilderModal({
  required BuildContext context,
  required bool isSubscribed,
  required void Function({
    required String routineName,
    required List<RoutineExercise> exercises,
    required int durationMinutes,
    required RoutineAnalysis analysis,
  }) onSaveRoutine,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _RoutineBuilderContent(
      isSubscribed: isSubscribed,
      onSaveRoutine: onSaveRoutine,
    ),
  );
}

class _RoutineBuilderContent extends StatefulWidget {
  final bool isSubscribed;
  final void Function({
    required String routineName,
    required List<RoutineExercise> exercises,
    required int durationMinutes,
    required RoutineAnalysis analysis,
  }) onSaveRoutine;

  const _RoutineBuilderContent({
    required this.isSubscribed,
    required this.onSaveRoutine,
  });

  @override
  State<_RoutineBuilderContent> createState() => _RoutineBuilderContentState();
}

class _RoutineBuilderContentState extends State<_RoutineBuilderContent> {
  final TextEditingController _nameController = TextEditingController(text: 'ตารางฝึกแบบกำหนดเอง');
  final List<RoutineExercise> _selectedExercises = [
    RoutineExercise(id: 'c1', name: 'Barbell Bench Press', muscle: 'อก', sets: 4, reps: 8, isCompound: true),
    RoutineExercise(id: 's2', name: 'Dumbbell Lateral Raise', muscle: 'ไหล่', sets: 3, reps: 12),
    RoutineExercise(id: 'a3', name: 'Tricep Rope Pushdown', muscle: 'แขน', sets: 3, reps: 12),
  ];

  String _filterMuscle = 'ทั้งหมด';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addExercise(RoutineExercise ex) {
    setState(() {
      _selectedExercises.add(ex.copy());
    });
  }

  void _removeExercise(int index) {
    setState(() {
      _selectedExercises.removeAt(index);
    });
  }

  void _showReview() {
    final analysis = analyzeRoutine(_selectedExercises);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _RoutineReviewSheet(
        routineName: _nameController.text.trim().isEmpty ? 'ตารางฝึกที่กำหนดเอง' : _nameController.text.trim(),
        exercises: _selectedExercises,
        analysis: analysis,
        isSubscribed: widget.isSubscribed,
        onConfirmSave: () {
          Navigator.pop(ctx); // Close review
          Navigator.pop(context); // Close builder
          widget.onSaveRoutine(
            routineName: _nameController.text.trim().isEmpty ? 'ตารางฝึกที่กำหนดเอง' : _nameController.text.trim(),
            exercises: _selectedExercises,
            durationMinutes: analysis.estimatedMinutes,
            analysis: analysis,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentAnalysis = analyzeRoutine(_selectedExercises);
    final muscles = ['ทั้งหมด', 'อก', 'หลัง', 'ไหล่', 'แขน', 'ขา', 'ท้อง', 'คาร์ดิโอ'];
    final filteredLibrary = _filterMuscle == 'ทั้งหมด'
        ? exerciseLibrary
        : exerciseLibrary.where((e) => e.muscle == _filterMuscle).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 44,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.fitness_center_rounded, color: Color(0xFF059669), size: 22),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'จัดตารางฝึกด้วยตนเอง',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                        ),
                        Text(
                          'เลือกท่าฝึก ปรับเซต/ครั้ง พร้อมรับรีวิวทันที',
                          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 20, color: Color(0xFFF1F5F9)),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              children: [
                // Routine Name Input
                const Text('ชื่อตารางฝึกของคุณ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF334155))),
                const SizedBox(height: 6),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.edit_note_rounded, color: Color(0xFF059669)),
                    hintText: 'เช่น ตารางอก-ไหล่ วันจันทร์, Upper Body Power',
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  ),
                ),

                const SizedBox(height: 20),

                // Selected Exercises Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ท่าฝึกในตาราง (${_selectedExercises.length} ท่า / ${currentAnalysis.totalSets} เซต)',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: currentAnalysis.gradeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'คะแนนพรีวิว: ${currentAnalysis.score}/10',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: currentAnalysis.gradeColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                if (_selectedExercises.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Center(
                      child: Text('ยังไม่มีท่าฝึกในตาราง แตะเลือกท่าฝึกจากคลังด้านล่างได้เลย!', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                    ),
                  )
                else
                  ..._selectedExercises.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final ex = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 6, offset: Offset(0, 2))],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('${idx + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        ex.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                                      ),
                                    ),
                                    if (ex.isCompound)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEF3C7),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Text('Compound', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFD97706))),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    // Sets control
                                    _buildCounterControl(
                                      label: 'เซต',
                                      value: ex.sets,
                                      onDecrement: () {
                                        if (ex.sets > 1) setState(() => ex.sets--);
                                      },
                                      onIncrement: () {
                                        if (ex.sets < 10) setState(() => ex.sets++);
                                      },
                                    ),
                                    const SizedBox(width: 14),
                                    // Reps control
                                    _buildCounterControl(
                                      label: 'ครั้ง',
                                      value: ex.reps,
                                      step: 2,
                                      onDecrement: () {
                                        if (ex.reps > 2) setState(() => ex.reps -= 2);
                                      },
                                      onIncrement: () {
                                        if (ex.reps < 50) setState(() => ex.reps += 2);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline_rounded, color: Color(0xFFEF4444), size: 20),
                            onPressed: () => _removeExercise(idx),
                            tooltip: 'ลบท่านี้',
                          ),
                        ],
                      ),
                    );
                  }),

                const SizedBox(height: 20),

                // Exercise Library Selector Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('เลือกท่าฝึกเพิ่มจากคลัง (Library)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A))),
                    Text('${filteredLibrary.length} ท่า', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
                const SizedBox(height: 10),

                // Filter muscle chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: muscles.map((m) {
                      final isSelected = _filterMuscle == m;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(m),
                          selected: isSelected,
                          onSelected: (val) {
                            if (val) setState(() => _filterMuscle = m);
                          },
                          selectedColor: const Color(0xFF059669),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF475569),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 11,
                          ),
                          backgroundColor: const Color(0xFFF8FAFC),
                          side: BorderSide(color: isSelected ? const Color(0xFF059669) : const Color(0xFFE2E8F0)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),

                // Library Items Grid/List
                ...filteredLibrary.map((ex) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ex.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                            const SizedBox(height: 2),
                            Text(
                              'กลุ่ม: ${ex.muscle} • ${ex.sets} เซต x ${ex.reps} ครั้ง',
                              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _addExercise(ex),
                          icon: const Icon(Icons.add_rounded, size: 16),
                          label: const Text('เพิ่ม'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF059669),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 80),
              ],
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                // Review Button
                Expanded(
                  flex: 3,
                  child: OutlinedButton.icon(
                    onPressed: _selectedExercises.isEmpty ? null : _showReview,
                    icon: const Icon(Icons.analytics_rounded, size: 18),
                    label: const Text('รีวิวตารางนี้ 🔍'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0284C7),
                      side: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Save and start button
                Expanded(
                  flex: 4,
                  child: ElevatedButton.icon(
                    onPressed: _selectedExercises.isEmpty
                        ? null
                        : () {
                            final analysis = analyzeRoutine(_selectedExercises);
                            Navigator.pop(context);
                            widget.onSaveRoutine(
                              routineName: _nameController.text.trim().isEmpty ? 'ตารางฝึกที่กำหนดเอง' : _nameController.text.trim(),
                              exercises: _selectedExercises,
                              durationMinutes: analysis.estimatedMinutes,
                              analysis: analysis,
                            );
                          },
                    icon: const Icon(Icons.play_arrow_rounded, size: 20),
                    label: const Text('บันทึก & เริ่มฝึก'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterControl({
    required String label,
    required int value,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
    int step = 1,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onDecrement,
            child: const Icon(Icons.remove, size: 14, color: Color(0xFF475569)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('$value $label', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          ),
          InkWell(
            onTap: onIncrement,
            child: const Icon(Icons.add, size: 14, color: Color(0xFF475569)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Routine Review Sheet (Shows Analysis, Score & AI Recommendations)
// ---------------------------------------------------------------------------

class _RoutineReviewSheet extends StatelessWidget {
  final String routineName;
  final List<RoutineExercise> exercises;
  final RoutineAnalysis analysis;
  final bool isSubscribed;
  final VoidCallback onConfirmSave;

  const _RoutineReviewSheet({
    required this.routineName,
    required this.exercises,
    required this.analysis,
    required this.isSubscribed,
    required this.onConfirmSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 44,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.rate_review_rounded, color: Color(0xFF0284C7)),
                    SizedBox(width: 8),
                    Text(
                      'ผลวิเคราะห์ตารางฝึก (Routine Review)',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 16, color: Color(0xFFF1F5F9)),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              children: [
                // Top Score Hero Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [analysis.gradeColor.withValues(alpha: 0.15), Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: analysis.gradeColor.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        routineName,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${analysis.score}',
                            style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: analysis.gradeColor, height: 1.0),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Text('/ 10', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: analysis.gradeColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          analysis.grade,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Stats row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMiniStat('ท่าฝึก', '${exercises.length} ท่า', Icons.list_alt_rounded),
                          _buildMiniStat('เซตรวม', '${analysis.totalSets} เซต', Icons.repeat_rounded),
                          _buildMiniStat('เวลาโดยประมาณ', '~${analysis.estimatedMinutes} นาที', Icons.timer_outlined),
                          _buildMiniStat('เผาผลาญ', '~${analysis.estimatedCalories} kcal', Icons.local_fire_department_rounded),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Muscle Distribution Section
                const Text('สัดส่วนกลุ่มกล้ามเนื้อที่ถูกกระตุ้น (Muscle Balance)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: analysis.muscleDistribution.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('กล้ามเนื้อส่วน: ${entry.key}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                                Text('${entry.value.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0284C7))),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: (entry.value / 100.0).clamp(0.0, 1.0),
                                minHeight: 8,
                                backgroundColor: const Color(0xFFF1F5F9),
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0284C7)),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                // Pros & Recommendations
                const Text('จุดเด่น & ข้อควรระวังของตารางนี้', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                const SizedBox(height: 10),

                // Pros
                ...analysis.pros.map((pro) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(pro, style: const TextStyle(fontSize: 12, color: Color(0xFF065F46), height: 1.4)),
                      ),
                    ],
                  ),
                )),

                // Recommendations
                ...analysis.recommendations.map((rec) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded, color: Color(0xFFD97706), size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(rec, style: const TextStyle(fontSize: 12, color: Color(0xFF92400E), height: 1.4)),
                      ),
                    ],
                  ),
                )),

                const SizedBox(height: 16),

                // AI Health Coach Verdict Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.psychology_rounded, color: Color(0xFF38BDF8), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'AI Health Coach สรุปคำแนะนำ',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        analysis.aiCoachVerdict,
                        style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 12, height: 1.5),
                      ),
                      if (isSubscribed) ...[
                        const Divider(height: 20, color: Color(0xFF334155)),
                        const Row(
                          children: [
                            Icon(Icons.workspace_premium_rounded, color: Color(0xFFF59E0B), size: 16),
                            SizedBox(width: 6),
                            Text(
                              'VIP Pro Optimization: โอกาสบาดเจ็บต่ำมาก (<1%) แนะนำพักเซตละ 75 วิ',
                              style: TextStyle(color: Color(0xFFFDE68A), fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),

          // Bottom CTA Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onConfirmSave,
                icon: const Icon(Icons.check_circle_rounded),
                label: const Text('ตกลงและเริ่มฝึกตามตารางนี้เลย 🚀'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF64748B)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
      ],
    );
  }
}

