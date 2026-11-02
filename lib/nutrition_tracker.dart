import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Data Models for Nutrition & Meals
// ---------------------------------------------------------------------------

enum MealType { breakfast, lunch, dinner, snack }

class FoodItem {
  final String id;
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final String emoji;
  final bool isClean;
  final String portion;

  const FoodItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.emoji,
    this.isClean = true,
    this.portion = '1 จาน/เสิร์ฟ',
  });
}

class MealLog {
  final String id;
  final String name;
  final MealType type;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final DateTime time;
  final String emoji;
  final bool isClean;

  MealLog({
    required this.id,
    required this.name,
    required this.type,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.time,
    this.emoji = '🥗',
    this.isClean = true,
  });

  String get typeName {
    switch (type) {
      case MealType.breakfast:
        return 'มื้อเช้า';
      case MealType.lunch:
        return 'มื้อกลางวัน';
      case MealType.dinner:
        return 'มื้อเย็น';
      case MealType.snack:
        return 'ของว่าง/โปรตีนเสริม';
    }
  }

  Color get typeColor {
    switch (type) {
      case MealType.breakfast:
        return const Color(0xFFF59E0B);
      case MealType.lunch:
        return const Color(0xFF0284C7);
      case MealType.dinner:
        return const Color(0xFF8B5CF6);
      case MealType.snack:
        return const Color(0xFF10B981);
    }
  }
}

// ---------------------------------------------------------------------------
// Predefined Healthy Food Library
// ---------------------------------------------------------------------------

const List<FoodItem> defaultFoodLibrary = [
  // มื้อหลัก
  FoodItem(id: 'f1', name: 'ข้าวอกไก่ย่าง + บรอกโคลี', calories: 380, protein: 42, carbs: 40, fat: 4, emoji: '🍗', portion: '1 จาน (300g)'),
  FoodItem(id: 'f2', name: 'สเต็กแซลมอนย่าง + สลัดผัก', calories: 450, protein: 36, carbs: 12, fat: 28, emoji: '🐟', portion: '1 จาน (250g)'),
  FoodItem(id: 'f3', name: 'ข้าวกะเพราอกไก่ไข่ดาวน้ำ (คลีน)', calories: 420, protein: 38, carbs: 48, fat: 6, emoji: '🍳', portion: '1 จาน (320g)'),
  FoodItem(id: 'f4', name: 'สุกี้น้ำอกไก่ ผักรวมเส้นบุก', calories: 260, protein: 28, carbs: 22, fat: 4, emoji: '🍲', portion: '1 ชามใหญ่'),
  FoodItem(id: 'f5', name: 'สเต็กเนื้อสันใน + มันบดโฮมเมด', calories: 480, protein: 44, carbs: 35, fat: 16, emoji: '🥩', portion: '1 จาน (280g)'),
  FoodItem(id: 'f6', name: 'สลัดอกไก่ฉีก น้ำสลัดงาญี่ปุ่น', calories: 290, protein: 30, carbs: 18, fat: 9, emoji: '🥗', portion: '1 ชาม (220g)'),
  FoodItem(id: 'f7', name: 'ข้าวผัดกุ้งไรซ์เบอร์รี่ (น้ำมันน้อย)', calories: 410, protein: 26, carbs: 54, fat: 8, emoji: '🦐', portion: '1 จาน (300g)'),

  // ของว่าง & โปรตีนเสริม
  FoodItem(id: 'f8', name: 'ไข่ต้ม 2 ฟอง', calories: 140, protein: 13, carbs: 1, fat: 9, emoji: '🥚', portion: '2 ฟอง'),
  FoodItem(id: 'f9', name: 'เวย์โปรตีน 1 สกู๊ป', calories: 120, protein: 25, carbs: 3, fat: 1, emoji: '🥛', portion: '1 แก้ว (30g)'),
  FoodItem(id: 'f10', name: 'กรีกโยเกิร์ต + บลูเบอร์รี่สด', calories: 180, protein: 16, carbs: 22, fat: 2, emoji: '🫐', portion: '1 ถ้วย (150g)'),
  FoodItem(id: 'f11', name: 'อัลมอนด์อบธรรมชาติ 1 กำมือ', calories: 170, protein: 6, carbs: 6, fat: 14, emoji: '🥜', portion: '30g'),
  FoodItem(id: 'f12', name: 'กล้วยหอม 1 ผล', calories: 105, protein: 1.3, carbs: 27, fat: 0.3, emoji: '🍌', portion: '1 ผลกลาง'),
];

// ---------------------------------------------------------------------------
// Nutrition Review / Analysis
// ---------------------------------------------------------------------------

class DailyNutritionReview {
  final double score; // 0 - 10
  final String grade;
  final Color gradeColor;
  final int totalCalories;
  final int calorieGoal;
  final double totalProtein;
  final double proteinGoal;
  final double totalCarbs;
  final double carbsGoal;
  final double totalFat;
  final double fatGoal;
  final List<String> pros;
  final List<String> tips;
  final String aiVerdict;

  DailyNutritionReview({
    required this.score,
    required this.grade,
    required this.gradeColor,
    required this.totalCalories,
    required this.calorieGoal,
    required this.totalProtein,
    required this.proteinGoal,
    required this.totalCarbs,
    required this.carbsGoal,
    required this.totalFat,
    required this.fatGoal,
    required this.pros,
    required this.tips,
    required this.aiVerdict,
  });
}

DailyNutritionReview evaluateDailyNutrition({
  required List<MealLog> meals,
  int calorieGoal = 2100,
  double proteinGoal = 140,
  double carbsGoal = 220,
  double fatGoal = 65,
}) {
  int totalCals = 0;
  double totalP = 0;
  double totalC = 0;
  double totalF = 0;
  int cleanMealCount = 0;

  for (final m in meals) {
    totalCals += m.calories;
    totalP += m.protein;
    totalC += m.carbs;
    totalF += m.fat;
    if (m.isClean) cleanMealCount++;
  }

  double score = 7.0;
  final List<String> pros = [];
  final List<String> tips = [];

  // Protein check
  final pRatio = totalP / proteinGoal;
  if (pRatio >= 0.85 && pRatio <= 1.2) {
    score += 1.5;
    pros.add('โปรตีนถึงเป้าหมายยอดเยี่ยม (${totalP.toStringAsFixed(0)}g / ${proteinGoal.toInt()}g) เสริมสร้างและซ่อมแซมกล้ามเนื้อได้เต็มที่');
  } else if (pRatio < 0.85) {
    tips.add('โปรตีนยังขาดอีก ${(proteinGoal - totalP).toStringAsFixed(0)}g แนะนำเพิ่มไข่ต้ม นม หรือเวย์โปรตีน 1 มื้อ');
  } else {
    score += 0.5;
    pros.add('โปรตีนสูงมาก (${totalP.toStringAsFixed(0)}g) เหมาะสำหรับช่วงเวทเทรนนิ่งหนัก');
  }

  // Calorie check
  final calRatio = totalCals / calorieGoal;
  if (calRatio >= 0.8 && calRatio <= 1.05) {
    score += 1.0;
    pros.add('พลังงานรวม ($totalCals kcal) อยู่ในกรอบสมดุล ไม่เกินเป้าหมายรายวัน');
  } else if (calRatio < 0.8) {
    tips.add('พลังงานยังเหลืออีก ${(calorieGoal - totalCals)} kcal สามารถทานมื้อว่างดีต่อสุขภาพได้');
  } else {
    score -= 0.5;
    tips.add('พลังงานใกล้แตะเป้าหมาย แนะนำเน้นผักใบเขียวและน้ำเปล่าในมื้อถัดไป');
  }

  // Clean meals
  if (cleanMealCount >= 2) {
    score += 0.8;
    pros.add('เลือกทานอาหารคลีน $cleanMealCount มื้อ ช่วยลดโซเดียมและไขมันอิ่มตัวได้ดีมาก');
  }

  score = score.clamp(1.0, 9.9);

  String grade;
  Color gradeColor;
  if (score >= 9.0) {
    grade = 'ยอดเยี่ยมระดับ S (สมดุลสารอาหารทองคำ)';
    gradeColor = const Color(0xFF10B981);
  } else if (score >= 8.0) {
    grade = 'ดีมากระดับ A (ครบถ้วนตามแผน)';
    gradeColor = const Color(0xFF0284C7);
  } else if (score >= 7.0) {
    grade = 'เกณฑ์มาตรฐาน (Tier B)';
    gradeColor = const Color(0xFFF59E0B);
  } else {
    grade = 'ควรปรับเพิ่ม (Tier C)';
    gradeColor = const Color(0xFFEF4444);
  }

  String verdict = 'วันนี้ทานไปทั้งหมด ${meals.length} มื้อ รวม $totalCals kcal (โปรตีน ${totalP.toStringAsFixed(0)}g) ';
  if (pRatio >= 0.85) {
    verdict += 'สัดส่วนโปรตีนสูงและสารอาหารสมดุล เหมาะสมมากสำหรับฟื้นฟูกล้ามเนื้อหลังออกกำลังกาย ดื่มน้ำให้ครบ 2,000 ml เพื่อช่วยการย่อยอาหารครับ!';
  } else {
    verdict += 'แนะนำเน้นแหล่งโปรตีนสะอาดในมื้อถัดไป เพื่อให้กล้ามเนื้อฟื้นตัวได้เต็มประสิทธิภาพครับ!';
  }

  return DailyNutritionReview(
    score: double.parse(score.toStringAsFixed(1)),
    grade: grade,
    gradeColor: gradeColor,
    totalCalories: totalCals,
    calorieGoal: calorieGoal,
    totalProtein: totalP,
    proteinGoal: proteinGoal,
    totalCarbs: totalC,
    carbsGoal: carbsGoal,
    totalFat: totalF,
    fatGoal: fatGoal,
    pros: pros,
    tips: tips,
    aiVerdict: verdict,
  );
}

// ---------------------------------------------------------------------------
// Add Meal Modal Bottom Sheet
// ---------------------------------------------------------------------------

void showAddMealModal({
  required BuildContext context,
  required void Function(MealLog newMeal) onAddMeal,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _AddMealModalContent(onAddMeal: onAddMeal),
  );
}

class _AddMealModalContent extends StatefulWidget {
  final void Function(MealLog newMeal) onAddMeal;

  const _AddMealModalContent({required this.onAddMeal});

  @override
  State<_AddMealModalContent> createState() => _AddMealModalContentState();
}

class _AddMealModalContentState extends State<_AddMealModalContent> {
  MealType _selectedType = MealType.lunch;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _calController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  bool _isClean = true;

  @override
  void dispose() {
    _nameController.dispose();
    _calController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  void _selectFromLibrary(FoodItem item) {
    setState(() {
      _nameController.text = item.name;
      _calController.text = item.calories.toString();
      _proteinController.text = item.protein.toStringAsFixed(0);
      _carbsController.text = item.carbs.toStringAsFixed(0);
      _fatController.text = item.fat.toStringAsFixed(0);
      _isClean = item.isClean;
    });
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาระบุชื่อเมนูอาหาร')),
      );
      return;
    }

    final cals = int.tryParse(_calController.text.trim()) ?? 350;
    final p = double.tryParse(_proteinController.text.trim()) ?? 25;
    final c = double.tryParse(_carbsController.text.trim()) ?? 35;
    final f = double.tryParse(_fatController.text.trim()) ?? 8;

    final meal = MealLog(
      id: 'm_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      type: _selectedType,
      calories: cals,
      protein: p,
      carbs: c,
      fat: f,
      time: DateTime.now(),
      isClean: _isClean,
      emoji: _isClean ? '🥗' : '🍱',
    );

    widget.onAddMeal(meal);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
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
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.restaurant_rounded, color: Color(0xFFD97706), size: 22),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'บันทึกมื้ออาหาร (Log Meal)',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        Text(
                          'เลือกจากคลังเมนูเพื่อสุขภาพ หรือระบุเอง',
                          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                      ],
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
                // Meal Type Selector Chips
                const Text('เลือกช่วงเวลา / มื้ออาหาร', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF334155))),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildTypeChip('มื้อเช้า', MealType.breakfast, Icons.wb_sunny_rounded),
                    const SizedBox(width: 6),
                    _buildTypeChip('มื้อกลางวัน', MealType.lunch, Icons.wb_twilight_rounded),
                    const SizedBox(width: 6),
                    _buildTypeChip('มื้อเย็น', MealType.dinner, Icons.nights_stay_rounded),
                    const SizedBox(width: 6),
                    _buildTypeChip('ของว่าง', MealType.snack, Icons.cookie_outlined),
                  ],
                ),

                const SizedBox(height: 18),

                // Quick pick from library
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('เลือกด่วนจากเมนูยอดนิยม (Quick Pick)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF334155))),
                    Text('${defaultFoodLibrary.length} เมนู', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  ],
                ),
                const SizedBox(height: 8),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: defaultFoodLibrary.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ActionChip(
                          avatar: Text(item.emoji, style: const TextStyle(fontSize: 14)),
                          label: Text('${item.name} (${item.calories} kcal)'),
                          labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                          backgroundColor: const Color(0xFFF8FAFC),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          onPressed: () => _selectFromLibrary(item),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 18),

                // Food Details Form Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('ชื่อเมนูอาหาร', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'เช่น สลัดแซลมอน, ข้าวไข่ต้มอกไก่',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Calories and Protein row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('แคลอรี (kcal)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: _calController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    suffixText: 'kcal',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('โปรตีน (g)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0284C7))),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: _proteinController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    suffixText: 'g',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Carbs and Fat row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('คาร์บ (g)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFD97706))),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: _carbsController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    suffixText: 'g',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('ไขมัน (g)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFE11D48))),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: _fatController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    suffixText: 'g',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Clean food toggle
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('เป็นมื้ออาหารคลีน / ปรุงน้อย', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                        subtitle: const Text('ช่วยบันทึกความคืบหน้าเควสเช็คอินอาหารคลีน', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                        value: _isClean,
                        activeTrackColor: const Color(0xFF10B981),
                        onChanged: (val) => setState(() => _isClean = val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Bottom Action
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check_circle_rounded),
                label: const Text('บันทึกมื้ออาหารนี้ 🥗'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
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

  Widget _buildTypeChip(String label, MealType type, IconData icon) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedType = type),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFECFDF5) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 18, color: isSelected ? const Color(0xFF059669) : const Color(0xFF64748B)),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? const Color(0xFF059669) : const Color(0xFF475569),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Daily Nutrition Review Modal Bottom Sheet
// ---------------------------------------------------------------------------

void showNutritionReviewModal({
  required BuildContext context,
  required List<MealLog> meals,
  required bool isSubscribed,
}) {
  final review = evaluateDailyNutrition(meals: meals);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _NutritionReviewModalContent(
      review: review,
      meals: meals,
      isSubscribed: isSubscribed,
    ),
  );
}

class _NutritionReviewModalContent extends StatelessWidget {
  final DailyNutritionReview review;
  final List<MealLog> meals;
  final bool isSubscribed;

  const _NutritionReviewModalContent({
    required this.review,
    required this.meals,
    required this.isSubscribed,
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
                    Icon(Icons.pie_chart_rounded, color: Color(0xFF10B981)),
                    SizedBox(width: 8),
                    Text(
                      'รีวิวโภชนาการประจำวัน (Nutrition Review)',
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
                // Top Hero Score Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [review.gradeColor.withValues(alpha: 0.15), Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: review.gradeColor.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'คะแนนโภชนาการวันนี้ (Nutrition Score)',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${review.score}',
                            style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: review.gradeColor, height: 1.0),
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
                          color: review.gradeColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          review.grade,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Macro Progress Bars
                      _buildMacroRow('แคลอรีรวม', '${review.totalCalories} / ${review.calorieGoal} kcal', (review.totalCalories / review.calorieGoal).clamp(0.0, 1.0), const Color(0xFFF59E0B)),
                      const SizedBox(height: 8),
                      _buildMacroRow('โปรตีน (Protein)', '${review.totalProtein.toStringAsFixed(0)} / ${review.proteinGoal.toInt()} g', (review.totalProtein / review.proteinGoal).clamp(0.0, 1.0), const Color(0xFF0284C7)),
                      const SizedBox(height: 8),
                      _buildMacroRow('คาร์โบไฮเดรต', '${review.totalCarbs.toStringAsFixed(0)} / ${review.carbsGoal.toInt()} g', (review.totalCarbs / review.carbsGoal).clamp(0.0, 1.0), const Color(0xFF10B981)),
                      const SizedBox(height: 8),
                      _buildMacroRow('ไขมันดี (Fat)', '${review.totalFat.toStringAsFixed(0)} / ${review.fatGoal.toInt()} g', (review.totalFat / review.fatGoal).clamp(0.0, 1.0), const Color(0xFFE11D48)),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Pros & Tips
                const Text('การประเมินและข้อแนะนำ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                const SizedBox(height: 10),

                ...review.pros.map((p) => Container(
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
                        child: Text(p, style: const TextStyle(fontSize: 12, color: Color(0xFF065F46), height: 1.4)),
                      ),
                    ],
                  ),
                )),

                ...review.tips.map((t) => Container(
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
                        child: Text(t, style: const TextStyle(fontSize: 12, color: Color(0xFF92400E), height: 1.4)),
                      ),
                    ],
                  ),
                )),

                const SizedBox(height: 16),

                // AI Nutritionist Summary
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
                            'AI Nutritionist สรุปคำแนะนำ',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        review.aiVerdict,
                        style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 12, height: 1.5),
                      ),
                      if (isSubscribed) ...[
                        const Divider(height: 20, color: Color(0xFF334155)),
                        const Row(
                          children: [
                            Icon(Icons.workspace_premium_rounded, color: Color(0xFFF59E0B), size: 16),
                            SizedBox(width: 6),
                            Text(
                              'VIP Pro Nutrition: ดูดซึมสารอาหารสมบูรณ์ โซเดียมในเกณฑ์ต่ำ',
                              style: TextStyle(color: Color(0xFFFDE68A), fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Bottom Close Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: const Text('รับทราบคำแนะนำ'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroRow(String title, String value, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
            Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            backgroundColor: const Color(0xFFF1F5F9),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
