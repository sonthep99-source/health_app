import 'package:flutter/material.dart';
import '../models/health_models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/source_badge.dart';

class FoodAiScannerScreen extends StatefulWidget {
  final VoidCallback? onGoToPetRoom;

  const FoodAiScannerScreen({super.key, this.onGoToPetRoom});

  @override
  State<FoodAiScannerScreen> createState() => _FoodAiScannerScreenState();
}

class _FoodAiScannerScreenState extends State<FoodAiScannerScreen> with SingleTickerProviderStateMixin {
  bool _isAnalyzing = false;
  bool _isFlashOn = false;
  FoodNutrition? _detectedFood;
  late AnimationController _scanLineController;

  final List<Map<String, dynamic>> _foodPresets = [
    {
      'name': 'สลัดอกไก่ย่างอะโวคาโด',
      'emoji': '🥗',
      'calories': 420,
      'protein': 38.5,
      'carbs': 28.0,
      'fat': 12.0,
      'score': 9.5,
    },
    {
      'name': 'สเต๊กแซลมอน & ข้าวไรซ์เบอร์รี่',
      'emoji': '🍣',
      'calories': 540,
      'protein': 42.0,
      'carbs': 48.0,
      'fat': 15.0,
      'score': 9.2,
    },
    {
      'name': 'สเต๊กเนื้อสันใน & บรอกโคลีย่าง',
      'emoji': '🥩',
      'calories': 480,
      'protein': 46.0,
      'carbs': 18.0,
      'fat': 14.0,
      'score': 8.9,
    },
    {
      'name': 'เวย์โปรตีนเชค & กล้วยหอมทอง',
      'emoji': '🥤',
      'calories': 290,
      'protein': 32.0,
      'carbs': 35.0,
      'fat': 3.0,
      'score': 9.0,
    },
    {
      'name': 'ก๋วยเตี๋ยวเส้นหมี่ต้มยำอกไก่ฉีก',
      'emoji': '🍜',
      'calories': 380,
      'protein': 29.0,
      'carbs': 52.0,
      'fat': 6.0,
      'score': 8.4,
    },
  ];

  @override
  void initState() {
    super.initState();
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    super.dispose();
  }

  void _simulateCapture(AppState appState, Map<String, dynamic> preset) async {
    setState(() {
      _isAnalyzing = true;
      _detectedFood = null;
    });

    await Future.delayed(const Duration(milliseconds: 1400));

    final food = FoodNutrition(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      foodName: preset['name'] as String,
      calories: preset['calories'] as int,
      protein: (preset['protein'] as num).toDouble(),
      carbs: (preset['carbs'] as num).toDouble(),
      fat: (preset['fat'] as num).toDouble(),
      healthScore: (preset['score'] as num).toDouble(),
      emoji: preset['emoji'] as String,
      timestamp: DateTime.now(),
      confidence: 0.97,
      source: HealthDataSource.aiEstimated,
    );

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        _detectedFood = food;
      });
    }
  }

  void _saveFoodAndDigitalReward(AppState appState) {
    if (_detectedFood == null) return;

    appState.scanFoodWithAi(
      foodName: _detectedFood!.foodName,
      calories: _detectedFood!.calories,
      protein: _detectedFood!.protein,
      carbs: _detectedFood!.carbs,
      fat: _detectedFood!.fat,
      healthScore: _detectedFood!.healthScore,
      emoji: _detectedFood!.emoji,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(_detectedFood!.emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'บันทึกสำเร็จ! ได้รับ "${_detectedFood!.foodName}" ในกระเป๋าอาหารสัตว์เลี้ยง 🍎',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppTheme.mint),
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'ไปป้อนสัตว์เลี้ยง >',
          textColor: AppTheme.cyan,
          onPressed: widget.onGoToPetRoom ?? () {},
        ),
      ),
    );

    setState(() {
      _detectedFood = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.camera_alt_outlined, color: AppTheme.cyan, size: 22),
            SizedBox(width: 8),
            Text(
              'AI Food Vision Scanner',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: _isFlashOn ? AppTheme.amber : Colors.white60,
            ),
            tooltip: 'เปิด/ปิด แฟลช',
            onPressed: () => setState(() => _isFlashOn = !_isFlashOn),
          ),
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.cyan.withOpacity(0.18),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.cyan.withOpacity(0.4)),
            ),
            child: const Row(
              children: [
                Icon(Icons.auto_awesome, size: 13, color: AppTheme.cyan),
                SizedBox(width: 4),
                Text('โหมดตัวอย่าง', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.cyan)),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Camera preview is currently a prototype; analysis below uses demo presets.
            _buildCameraViewfinder(context, appState),

            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.amber.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.amber.withOpacity(0.3)),
              ),
              child: const Text(
                'ตอนนี้ยังไม่ได้วิเคราะห์ภาพจากกล้องจริง ผลด้านล่างเป็นข้อมูลตัวอย่าง และควรตรวจ/แก้ไขก่อนบันทึก',
                style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
              ),
            ),

            const SizedBox(height: 16),

            // AI Vision Analysis Result Card (Appears after capture)
            if (_detectedFood != null) ...[
              _buildAnalysisResultCard(context, appState),
              const SizedBox(height: 16),
            ],

            // Food Preset Quick-Capture Selector (Demo Testing)
            const Text(
              'เลือกเมนูตัวอย่างเพื่อดูขั้นตอนบันทึก:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _foodPresets.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final preset = _foodPresets[index];
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.surface,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: AppTheme.cyan.withOpacity(0.3)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onPressed: _isAnalyzing ? null : () => _simulateCapture(appState, preset),
                    child: Row(
                      children: [
                        Text(preset['emoji'] as String, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 6),
                        Text(preset['name'] as String, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Recent AI Food Scans History
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ประวัติมื้ออาหารที่สแกนแล้ว',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                ),
                Text(
                  'รวม ${appState.foodScans.length} มื้อ',
                  style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ...appState.foodScans.map((scan) => _buildScannedMealItem(scan)),
          ],
        ),
      ),
    );
  }

  // Camera Viewfinder Box with AI Reticle
  Widget _buildCameraViewfinder(BuildContext context, AppState appState) {
    return Container(
      width: double.infinity,
      height: 260,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.cyan.withOpacity(0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.cyan.withOpacity(0.2),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Camera Simulation Pattern
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: RadialGradient(
                colors: [
                  Colors.blueGrey.withOpacity(0.3),
                  Colors.black.withOpacity(0.9),
                ],
              ),
            ),
          ),

          // Central Scanner Target Frame
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppTheme.cyan, width: 2),
            ),
            child: Stack(
              children: [
                // Corner Reticles
                const Positioned(top: 4, left: 4, child: Icon(Icons.crop_free, size: 20, color: AppTheme.cyan)),
                const Positioned(top: 4, right: 4, child: Icon(Icons.crop_free, size: 20, color: AppTheme.cyan)),
                const Positioned(bottom: 4, left: 4, child: Icon(Icons.crop_free, size: 20, color: AppTheme.cyan)),
                const Positioned(bottom: 4, right: 4, child: Icon(Icons.crop_free, size: 20, color: AppTheme.cyan)),

                // Scanning Line Animation
                if (_isAnalyzing)
                  AnimatedBuilder(
                    animation: _scanLineController,
                    builder: (context, _) {
                      return Positioned(
                        top: _scanLineController.value * 180,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Colors.transparent, AppTheme.cyan, Colors.transparent]),
                            boxShadow: [
                              BoxShadow(color: AppTheme.cyan.withOpacity(0.8), blurRadius: 8),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                else
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.center_focus_weak, size: 48, color: Colors.white38),
                        const SizedBox(height: 6),
                        Text(
                          _detectedFood != null ? 'ตรวจจับอาหารสำเร็จ! 🎯' : 'วางจานอาหารในกรอบสแกน',
                          style: const TextStyle(fontSize: 11, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Top Info Pill
          Positioned(
            top: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
              ),
              child: Text(
                _isAnalyzing ? '🧠 AI Vision กำลังวิเคราะห์โภชนาการ...' : '📷 ส่องกล้องเพื่อระบุอาหาร & คำนวณแคลอรี',
                style: const TextStyle(fontSize: 10.5, color: Colors.white),
              ),
            ),
          ),

          // Bottom Shutter Button
          Positioned(
            bottom: 14,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Shutter Button
                GestureDetector(
                  onTap: _isAnalyzing ? null : () => _simulateCapture(appState, _foodPresets.first),
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      color: AppTheme.cyan.withOpacity(0.3),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.black, size: 26),
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

  // AI Vision Analysis Result Card
  Widget _buildAnalysisResultCard(BuildContext context, AppState appState) {
    final food = _detectedFood!;
    return GlassCard(
      gradient: const LinearGradient(
        colors: [Color(0xFF0F2B48), Color(0xFF1E293B)],
      ),
      border: Border.all(color: AppTheme.mint, width: 1.5),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(food.emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.foodName,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        'ความแม่นยำ AI: ${(food.confidence * 100).toStringAsFixed(0)}% • ${food.portion}',
                        style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.mint.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.mint),
                ),
                child: Text(
                  'คะแนน ${food.healthScore}/10',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.mint),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Calories & Macros (P/C/F)
          Row(
            children: [
              _buildMacroBox('🔥 พลังงาน', '${food.calories} kcal', AppTheme.amber),
              const SizedBox(width: 8),
              _buildMacroBox('🥩 โปรตีน', '${food.protein}g', AppTheme.cyan),
              const SizedBox(width: 8),
              _buildMacroBox('🍚 คาร์บ', '${food.carbs}g', const Color(0xFF38BDF8)),
              const SizedBox(width: 8),
              _buildMacroBox('🥑 ไขมัน', '${food.fat}g', AppTheme.rose),
            ],
          ),
          const SizedBox(height: 14),

          // Gamified Save & Convert Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.mint,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.check_circle_outline, size: 20),
              label: const Text(
                'บันทึกมื้อนี้ & แปลงเป็นอาหารดิจิทัลให้สัตว์เลี้ยง 🍎',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              onPressed: () => _saveFoodAndDigitalReward(appState),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 9.5, color: AppTheme.textSecondary)),
            const SizedBox(height: 2),
            Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildScannedMealItem(FoodNutrition scan) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Text(scan.emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scan.foodName,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${scan.calories} kcal • P: ${scan.protein}g | C: ${scan.carbs}g | F: ${scan.fat}g',
                  style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const SourceBadge(source: HealthDataSource.aiEstimated, compact: true),
        ],
      ),
    );
  }
}

