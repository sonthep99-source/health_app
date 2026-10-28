import 'package:flutter/material.dart';
import 'quest_ranking_screen.dart';
import 'workout_missions.dart';
import 'subscription_insights.dart';

void main() {
  runApp(const MyApp());
}

/// Root Application Widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0284C7),
          primary: const Color(0xFF0284C7),
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF0F172A),
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
        ),
        fontFamily: 'sans-serif',
      ),
      home: const MainNavigationScreen(),
    );
  }
}

typedef HealthTrackerApp = MyApp;

// ---------------------------------------------------------------------------
// Data Models (Pure Dart)
// ---------------------------------------------------------------------------

class WaterLog {
  final int amount;
  final DateTime time;

  WaterLog({required this.amount, required this.time});
}

class SleepRecord {
  final TimeOfDay bedTime;
  final TimeOfDay wakeTime;
  final double hours;
  final String quality;
  final DateTime date;

  SleepRecord({
    required this.bedTime,
    required this.wakeTime,
    required this.hours,
    required this.quality,
    required this.date,
  });
}

class WorkoutRecord {
  final String category;
  final String exercises;
  final int durationMinutes;
  final DateTime date;

  WorkoutRecord({
    required this.category,
    required this.exercises,
    required this.durationMinutes,
    required this.date,
  });
}

// ---------------------------------------------------------------------------
// Main Navigation Screen (Holds App-Wide State using setState)
// ---------------------------------------------------------------------------

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Water Tracker State
  int _currentWater = 1250;
  final int _waterGoal = 2000;
  final List<WaterLog> _waterLogs = [
    WaterLog(amount: 500, time: DateTime.now().subtract(const Duration(hours: 4))),
    WaterLog(amount: 250, time: DateTime.now().subtract(const Duration(hours: 2))),
    WaterLog(amount: 500, time: DateTime.now().subtract(const Duration(minutes: 40))),
  ];

  // Sleep Tracker State
  TimeOfDay _bedTime = const TimeOfDay(hour: 23, minute: 0);
  TimeOfDay _wakeTime = const TimeOfDay(hour: 7, minute: 0);
  double _sleepHours = 8.0;
  String _sleepQuality = 'ดีเยี่ยม';
  final List<SleepRecord> _sleepRecords = [
    SleepRecord(
      bedTime: const TimeOfDay(hour: 23, minute: 0),
      wakeTime: const TimeOfDay(hour: 7, minute: 0),
      hours: 8.0,
      quality: 'ดีเยี่ยม',
      date: DateTime.now(),
    ),
  ];

  // Workout Tracker State
  String _selectedTemplate = 'Push';
  int _workoutDuration = 45;
  final TextEditingController _exerciseController = TextEditingController(
    text: 'Bench Press 4 เซต, Incline DB Press 3 เซต, Tricep Pushdown 3 เซต',
  );
  final TextEditingController _durationController = TextEditingController(text: '45');
  final List<WorkoutRecord> _workoutRecords = [
    WorkoutRecord(
      category: 'Push',
      exercises: 'Bench Press 4 เซต, Incline DB Press 3 เซต, Tricep Pushdown 3 เซต',
      durationMinutes: 45,
      date: DateTime.now(),
    ),
  ];

  final Map<String, String> _templateDefaults = {
    'Push': 'Bench Press 4 เซต, Incline DB Press 3 เซต, Lateral Raise 4 เซต, Triceps 3 เซต',
    'Pull': 'Lat Pulldown 4 เซต, Barbell Row 4 เซต, Face Pull 3 เซต, Bicep Curl 3 เซต',
    'Legs': 'Barbell Squat 4 เซต, Romanian Deadlift 3 เซต, Leg Press 3 เซต, Calf Raise 4 เซต',
  };

  // Subscription & Pro Insights State
  bool _isSubscribed = false;

  // Workout Missions State
  late List<WorkoutMission> _workoutMissions;
  String _selectedMissionCategory = 'ทั้งหมด';

  // Gamification & Quest State
  int _userLevel = 4;
  int _userExp = 380;
  int _userExpMax = 500;
  int _userCoins = 240;
  final int _userStreak = 5;

  late List<QuestItem> _quests;
  late List<LeaderboardUser> _leaderboard;
  late List<HealthBadge> _badges;

  @override
  void initState() {
    super.initState();
    _workoutMissions = getDefaultWorkoutMissions();
    _initGamificationData();
  }

  void _initGamificationData() {
    _quests = [
      QuestItem(
        id: 'q1',
        title: 'ดื่มน้ำเพื่อสุขภาพ',
        description: 'ดื่มน้ำให้ครบ 2,000 ml วันนี้เพื่อความสดชื่น',
        expReward: 60,
        coinReward: 20,
        category: 'water',
        icon: Icons.water_drop_rounded,
        color: const Color(0xFF0284C7),
        currentProgress: _currentWater,
        targetProgress: _waterGoal,
        unit: 'ml',
        targetTabIndex: 1,
      ),
      QuestItem(
        id: 'q2',
        title: 'นอนหลับเต็มอิ่ม 7+ ชม.',
        description: 'พักผ่อนอย่างเพียงพอเพื่อฟื้นฟูร่างกาย',
        expReward: 70,
        coinReward: 25,
        category: 'sleep',
        icon: Icons.bedtime_rounded,
        color: const Color(0xFF6366F1),
        currentProgress: _sleepHours.toInt(),
        targetProgress: 7,
        unit: 'ชม.',
        targetTabIndex: 2,
      ),
      QuestItem(
        id: 'q3',
        title: 'ฟิตเนสเบิร์นพลังงาน',
        description: 'ออกกำลังกายอย่างน้อย 30 นาทีในวันนี้',
        expReward: 100,
        coinReward: 35,
        category: 'workout',
        icon: Icons.fitness_center_rounded,
        color: const Color(0xFF10B981),
        currentProgress: _workoutDuration,
        targetProgress: 30,
        unit: 'นาที',
        targetTabIndex: 3,
      ),
      QuestItem(
        id: 'q4',
        title: 'เช็คอินทานอาหารคลีน',
        description: 'หลีกเลี่ยงของทอดหรือเครื่องดื่มรสหวาน',
        expReward: 40,
        coinReward: 15,
        category: 'habit',
        icon: Icons.restaurant_rounded,
        color: const Color(0xFFF59E0B),
        currentProgress: 1,
        targetProgress: 1,
        unit: 'ครั้ง',
        targetTabIndex: 0,
      ),
      QuestItem(
        id: 'q5',
        title: 'เดินสะสม 6,000 ก้าว',
        description: 'ขยับร่างกายอย่างกระฉับกระเฉงตลอดวัน',
        expReward: 50,
        coinReward: 20,
        category: 'habit',
        icon: Icons.directions_walk_rounded,
        color: const Color(0xFFEC4899),
        currentProgress: 4500,
        targetProgress: 6000,
        unit: 'ก้าว',
        targetTabIndex: 0,
      ),
    ];

    _leaderboard = [
      LeaderboardUser(
        rank: 1,
        name: 'พี่เบิร์ด สายลีน',
        avatarInitials: 'BL',
        avatarColor: const Color(0xFFF59E0B),
        level: 6,
        exp: 2450,
        streakDays: 14,
        tier: 'Diamond League',
      ),
      LeaderboardUser(
        rank: 2,
        name: 'น้องมุก พิลาทิส',
        avatarInitials: 'MK',
        avatarColor: const Color(0xFF6366F1),
        level: 5,
        exp: 1920,
        streakDays: 9,
        tier: 'Platinum League',
      ),
      LeaderboardUser(
        rank: 3,
        name: 'โค้ชก้อง เวทเทรน',
        avatarInitials: 'KG',
        avatarColor: const Color(0xFF10B981),
        level: 5,
        exp: 1500,
        streakDays: 7,
        tier: 'Gold League',
      ),
      LeaderboardUser(
        rank: 4,
        name: 'คุณ (ผู้ใช้)',
        avatarInitials: 'ME',
        avatarColor: const Color(0xFF0284C7),
        level: _userLevel,
        exp: 1420,
        streakDays: _userStreak,
        tier: 'Gold League',
        isCurrentUser: true,
      ),
      LeaderboardUser(
        rank: 5,
        name: 'แจน วิ่งมาราธอน',
        avatarInitials: 'JN',
        avatarColor: const Color(0xFFEC4899),
        level: 4,
        exp: 1350,
        streakDays: 4,
        tier: 'Gold League',
      ),
      LeaderboardUser(
        rank: 6,
        name: 'เต้ ดื่มน้ำจุใจ',
        avatarInitials: 'TT',
        avatarColor: const Color(0xFF06B6D4),
        level: 3,
        exp: 1100,
        streakDays: 3,
        tier: 'Silver League',
      ),
    ];

    _badges = [
      HealthBadge(
        id: 'b1',
        title: 'เซียนดื่มน้ำ',
        desc: 'ดื่มน้ำครบ 2,000 ml ติดต่อกัน 3 วัน',
        icon: Icons.water_drop_rounded,
        color: const Color(0xFF0284C7),
        isUnlocked: true,
        unlockedDate: 'เมื่อวานนี้',
      ),
      HealthBadge(
        id: 'b2',
        title: 'หลับลึกสุขภาพดี',
        desc: 'นอนหลับ 7 ชั่วโมงขึ้นไปและตื่นตรงเวลา',
        icon: Icons.bedtime_rounded,
        color: const Color(0xFF6366F1),
        isUnlocked: true,
        unlockedDate: 'วันนี้',
      ),
      HealthBadge(
        id: 'b3',
        title: 'พลังกล้ามเนื้อ',
        desc: 'ออกกำลังกายครบ 5 ครั้งในเดือนนี้',
        icon: Icons.fitness_center_rounded,
        color: const Color(0xFF10B981),
        isUnlocked: true,
        unlockedDate: '3 วันที่แล้ว',
      ),
      HealthBadge(
        id: 'b4',
        title: 'สตรีคไฟลุก 7 วัน',
        desc: 'เช็คอินสุขภาพต่อเนื่อง 7 วันติด',
        icon: Icons.local_fire_department_rounded,
        color: const Color(0xFFEF4444),
        isUnlocked: false,
      ),
      HealthBadge(
        id: 'b5',
        title: 'เพอร์เฟกต์เดย์',
        desc: 'ทำเควสประจำวันสำเร็จครบทุกข้อใน 1 วัน',
        icon: Icons.stars_rounded,
        color: const Color(0xFFF59E0B),
        isUnlocked: false,
      ),
      HealthBadge(
        id: 'b6',
        title: 'ตำนานไดมอนด์',
        desc: 'ขึ้นสู่อันดับ Top 3 ในลีกสูงสุด',
        icon: Icons.military_tech_rounded,
        color: const Color(0xFF8B5CF6),
        isUnlocked: false,
      ),
    ];
  }

  void _syncQuestProgress() {
    for (final q in _quests) {
      if (q.id == 'q1') {
        q.currentProgress = _currentWater;
      } else if (q.id == 'q2') {
        q.currentProgress = _sleepHours.toInt();
      } else if (q.id == 'q3') {
        final totalMins = _workoutRecords.fold<int>(0, (sum, i) => sum + i.durationMinutes);
        q.currentProgress = totalMins;
      }
    }
  }

  void _claimQuest(QuestItem quest) {
    if (!quest.isCompleted || quest.isClaimed) return;
    setState(() {
      quest.isClaimed = true;
      _userExp += quest.expReward;
      _userCoins += quest.coinReward;

      // Update leaderboard entry for current user
      final userIndex = _leaderboard.indexWhere((u) => u.isCurrentUser);
      if (userIndex != -1) {
        final current = _leaderboard[userIndex];
        _leaderboard[userIndex] = LeaderboardUser(
          rank: current.rank,
          name: current.name,
          avatarInitials: current.avatarInitials,
          avatarColor: current.avatarColor,
          level: _userLevel,
          exp: current.exp + quest.expReward,
          streakDays: _userStreak,
          tier: current.tier,
          isCurrentUser: true,
        );
      }

      // Check level up
      if (_userExp >= _userExpMax) {
        _userLevel++;
        _userExp -= _userExpMax;
        _userExpMax = (_userExpMax * 1.25).toInt();
        _showLevelUpDialog();
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.stars_rounded, color: Colors.amber, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'สำเร็จเควส "${quest.title}" รับ +${quest.expReward} EXP และ ${quest.coinReward} 🪙!',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  void _showLevelUpDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: const Color(0xFF0F172A),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFFCD34D)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 18),
            const Text(
              '🎉 LEVEL UP! 🎉',
              style: TextStyle(
                color: Color(0xFFF59E0B),
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ยินดีด้วย! คุณเลเวลอัปเป็น LV.$_userLevel แล้ว',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              'สุขภาพของคุณแข็งแกร่งขึ้นอีกขั้น! ได้รับโบนัสพิเศษและปลดล็อกเหรียญตราใหม่',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 13,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                foregroundColor: const Color(0xFF0F172A),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text('ยอดเยี่ยมเลย!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleSubscription(bool status) {
    setState(() {
      _isSubscribed = status;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              status ? Icons.workspace_premium_rounded : Icons.info_outline_rounded,
              color: status ? const Color(0xFFF59E0B) : Colors.white,
              size: 24,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                status
                    ? '🎉 ยินดีต้อนรับสู่ Health Pro VIP! บทวิเคราะห์เชิงลึกถูกปลดล็อกแล้ว'
                    : 'ยกเลิกสถานะ Pro เรียบร้อยแล้ว (Demo Mode)',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  void _completeWorkoutMission(WorkoutMission mission) {
    setState(() {
      mission.isCompletedToday = true;
      final expGain = _isSubscribed ? (mission.expReward * 1.5).toInt() : mission.expReward;
      _userExp += expGain;
      _userCoins += mission.coinReward;

      _workoutRecords.insert(
        0,
        WorkoutRecord(
          category: mission.category,
          exercises: mission.exercises.join(', '),
          durationMinutes: mission.durationMinutes,
          date: DateTime.now(),
        ),
      );

      _syncQuestProgress();

      // Check level up
      if (_userExp >= _userExpMax) {
        _userLevel++;
        _userExp -= _userExpMax;
        _userExpMax = (_userExpMax * 1.25).toInt();
        _showLevelUpDialog();
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.fitness_center_rounded, color: Color(0xFF10B981), size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'พิชิตภารกิจ "${mission.title}" สำเร็จ! รับ +${_isSubscribed ? (mission.expReward * 1.5).toInt() : mission.expReward} EXP และ ${mission.coinReward} 🪙',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  @override
  void dispose() {
    _exerciseController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  // --- Water Methods ---
  void _addWater(int amount) {
    setState(() {
      _currentWater += amount;
      _waterLogs.insert(0, WaterLog(amount: amount, time: DateTime.now()));
      _syncQuestProgress();
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('บันทึกการดื่มน้ำ +$amount ml เรียบร้อยแล้ว!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF0284C7),
      ),
    );
  }

  void _resetWater() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('รีเซ็ตการดื่มน้ำ?'),
        content: const Text('คุณต้องการรีเซ็ตปริมาณน้ำดื่มทั้งหมดของวันนี้เป็น 0 ml ใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ยกเลิก', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _currentWater = 0;
                _waterLogs.clear();
                _syncQuestProgress();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('รีเซ็ตปริมาณน้ำเรียบร้อยแล้ว'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('รีเซ็ต'),
          ),
        ],
      ),
    );
  }

  // --- Sleep Methods ---
  double _calculateHours(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    int diff = endMinutes - startMinutes;
    if (diff <= 0) {
      diff += 24 * 60; // Overnight
    }
    return double.parse((diff / 60.0).toStringAsFixed(1));
  }

  void _selectTime(bool isBedTime) async {
    final initial = isBedTime ? _bedTime : _wakeTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked != null) {
      setState(() {
        if (isBedTime) {
          _bedTime = picked;
        } else {
          _wakeTime = picked;
        }
        _sleepHours = _calculateHours(_bedTime, _wakeTime);
      });
    }
  }

  void _saveSleepLog() {
    setState(() {
      _sleepRecords.insert(
        0,
        SleepRecord(
          bedTime: _bedTime,
          wakeTime: _wakeTime,
          hours: _sleepHours,
          quality: _sleepQuality,
          date: DateTime.now(),
        ),
      );
      _syncQuestProgress();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('บันทึกข้อมูลการนอนเรียบร้อยแล้ว!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF6366F1),
      ),
    );
  }

  // --- Workout Methods ---
  void _onTemplateSelected(String template) {
    setState(() {
      _selectedTemplate = template;
      _exerciseController.text = _templateDefaults[template] ?? '';
    });
  }

  void _addWorkoutLog() {
    final exercises = _exerciseController.text.trim();
    final duration = int.tryParse(_durationController.text) ?? _workoutDuration;
    if (exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากรอกท่าหรือรายละเอียดการฝึก'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _workoutDuration = duration;
      _workoutRecords.insert(
        0,
        WorkoutRecord(
          category: _selectedTemplate,
          exercises: exercises,
          durationMinutes: duration,
          date: DateTime.now(),
        ),
      );
      _syncQuestProgress();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('บันทึกการฝึก $_selectedTemplate ($duration นาที) สำเร็จ!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  void _deleteWorkout(int index) {
    setState(() {
      _workoutRecords.removeAt(index);
      _syncQuestProgress();
    });
  }

  // ---------------------------------------------------------------------------
  // Build Screen Tabs
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.favorite_rounded,
                color: Color(0xFF0284C7),
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Text(_getAppBarTitle()),
          ],
        ),
        actions: [
          // VIP Pro Badge / Subscribe Button
          InkWell(
            onTap: () => showSubscriptionModal(
              context: context,
              isSubscribed: _isSubscribed,
              onToggleSubscription: _toggleSubscription,
            ),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                gradient: _isSubscribed
                    ? const LinearGradient(
                        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                      )
                    : null,
                color: _isSubscribed ? null : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isSubscribed ? const Color(0xFFF59E0B) : const Color(0xFFCBD5E1),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.workspace_premium_rounded,
                    color: _isSubscribed ? Colors.white : const Color(0xFF64748B),
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _isSubscribed ? 'VIP PRO' : 'PRO',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _isSubscribed ? Colors.white : const Color(0xFF475569),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Coins Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🪙', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text(
                  '$_userCoins',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF92400E),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Streak Badge
          InkWell(
            onTap: () => setState(() => _currentIndex = 4),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 4),
                  Text(
                    '$_userStreak วัน',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB91C1C),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildDashboardTab(),
          _buildWaterTab(),
          _buildSleepTab(),
          _buildWorkoutTab(),
          QuestRankingScreen(
            userLevel: _userLevel,
            userExp: _userExp,
            userExpMax: _userExpMax,
            userCoins: _userCoins,
            userStreak: _userStreak,
            quests: _quests,
            leaderboard: _leaderboard,
            badges: _badges,
            onClaimQuest: _claimQuest,
            onNavigateToTab: (index) => setState(() => _currentIndex = index),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF0284C7),
          unselectedItemColor: const Color(0xFF94A3B8),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard_rounded),
              label: 'แดชบอร์ด',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.water_drop_outlined),
              activeIcon: Icon(Icons.water_drop_rounded),
              label: 'ดื่มน้ำ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bedtime_outlined),
              activeIcon: Icon(Icons.bedtime_rounded),
              label: 'การนอน',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center_outlined),
              activeIcon: Icon(Icons.fitness_center_rounded),
              label: 'ออกกำลังกาย',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_outlined),
              activeIcon: Icon(Icons.emoji_events_rounded),
              label: 'เควส & อันดับ',
            ),
          ],
        ),
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Health Dashboard';
      case 1:
        return 'Water Tracker';
      case 2:
        return 'Sleep Tracker';
      case 3:
        return 'Workout Log';
      case 4:
        return 'เควส & ตารางอันดับ';
      default:
        return 'Health Tracker';
    }
  }

  // ===========================================================================
  // TAB 1: DASHBOARD
  // ===========================================================================
  Widget _buildDashboardTab() {
    final waterPercent = (_currentWater / _waterGoal).clamp(0.0, 1.0);
    final totalWorkoutMins = _workoutRecords.fold<int>(
      0,
      (sum, item) => sum + item.durationMinutes,
    );
    final completedQuests = _quests.where((q) => q.isCompleted).length;
    final expPercent = (_userExp / _userExpMax).clamp(0.0, 1.0);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        // Gamified RPG Profile Banner
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF0369A1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x330F172A),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFFF59E0B), Color(0xFFFCD34D)],
                          ),
                        ),
                        padding: const EdgeInsets.all(2.5),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF0F172A),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(Icons.person_rounded, color: Colors.white, size: 28),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF0F172A), width: 1.5),
                        ),
                        child: Text(
                          'LV.$_userLevel',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              'คุณ (นักรบสุขภาพ)',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0x3338BDF8),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Gold League 🏆',
                                style: TextStyle(
                                  color: Color(0xFF38BDF8),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'สตรีค $_userStreak วัน 🔥',
                              style: const TextStyle(
                                color: Color(0xFFFCA5A5),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Coins
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0x22FFFFFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🪙', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          '$_userCoins',
                          style: const TextStyle(
                            color: Color(0xFFFDE68A),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // EXP Level Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'EXP: $_userExp / $_userExpMax',
                    style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${(expPercent * 100).toInt()}% เพื่อ LV.${_userLevel + 1}',
                    style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: expPercent,
                  minHeight: 7,
                  backgroundColor: const Color(0x33FFFFFF),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Deep Health Insights & Subscription Widget
        HealthInsightsWidget(
          isSubscribed: _isSubscribed,
          onOpenSubscription: () => showSubscriptionModal(
            context: context,
            isSubscribed: _isSubscribed,
            onToggleSubscription: _toggleSubscription,
          ),
        ),

        // Today's Quest Mini-Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
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
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.stars_rounded, color: Color(0xFFD97706), size: 20),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ภารกิจประจำวันนี้',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          Text(
                            'สำเร็จแล้ว $completedQuests จาก ${_quests.length} เควส',
                            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => setState(() => _currentIndex = 4),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('ดูทั้งหมด', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Icon(Icons.chevron_right_rounded, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: _quests.isNotEmpty ? (completedQuests / _quests.length) : 0,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFF1F5F9),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                ),
              ),
              const SizedBox(height: 14),

              // Mini Quest Quick Items (First 2 active quests)
              ..._quests.take(2).map((q) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        q.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                        color: q.isCompleted ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          q.title,
                          style: TextStyle(
                            fontSize: 13,
                            color: q.isClaimed ? const Color(0xFF94A3B8) : const Color(0xFF334155),
                            fontWeight: FontWeight.w500,
                            decoration: q.isClaimed ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                      if (q.isCompleted && !q.isClaimed)
                        InkWell(
                          onTap: () => _claimQuest(q),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'รับรางวัล',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      else if (!q.isCompleted)
                        Text(
                          '${q.currentProgress}/${q.targetProgress} ${q.unit}',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.bold),
                        )
                      else
                        const Text('✓ รับแล้ว', style: TextStyle(fontSize: 11, color: Color(0xFF10B981))),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 24),
        const Text(
          'สรุปกิจกรรมวันนี้',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 12),

        // Card 1: Water Intake
        _buildSummaryCard(
          title: 'ปริมาณน้ำที่ดื่ม',
          value: '$_currentWater / $_waterGoal ml',
          subtitle: 'ดื่มไปแล้ว ${(waterPercent * 100).toInt()}% ของเป้าหมาย',
          icon: Icons.water_drop_rounded,
          iconColor: const Color(0xFF0284C7),
          iconBgColor: const Color(0xFFE0F2FE),
          progressValue: waterPercent,
          progressColor: const Color(0xFF0284C7),
          actionLabel: 'บันทึกน้ำ',
          onAction: () => setState(() => _currentIndex = 1),
        ),

        const SizedBox(height: 16),

        // Card 2: Sleep Hours
        _buildSummaryCard(
          title: 'ชั่วโมงการนอนหลับ',
          value: '$_sleepHours ชั่วโมง',
          subtitle: 'นอน ${_bedTime.format(context)} • ตื่น ${_wakeTime.format(context)} ($_sleepQuality)',
          icon: Icons.bedtime_rounded,
          iconColor: const Color(0xFF6366F1),
          iconBgColor: const Color(0xFFEEF2FF),
          progressValue: (_sleepHours / 9.0).clamp(0.0, 1.0),
          progressColor: const Color(0xFF6366F1),
          actionLabel: 'ดูการนอน',
          onAction: () => setState(() => _currentIndex = 2),
        ),

        const SizedBox(height: 16),

        // Card 3: Workout Status
        _buildSummaryCard(
          title: 'การออกกำลังกาย',
          value: _workoutRecords.isNotEmpty
              ? '${_workoutRecords.first.category} Day ($totalWorkoutMins นาที)'
              : 'ยังไม่ได้ออกกำลังกาย',
          subtitle: _workoutRecords.isNotEmpty
              ? 'บันทึกล่าสุด: ${_workoutRecords.first.exercises.split(',').take(2).join(', ')}...'
              : 'เลือกโปรแกรม Push, Pull หรือ Legs เพื่อเริ่มออกกำลังกาย',
          icon: Icons.fitness_center_rounded,
          iconColor: const Color(0xFF10B981),
          iconBgColor: const Color(0xFFECFDF5),
          progressValue: _workoutRecords.isNotEmpty ? 1.0 : 0.0,
          progressColor: const Color(0xFF10B981),
          actionLabel: 'เริ่มฝึก',
          onAction: () => setState(() => _currentIndex = 3),
        ),

        const SizedBox(height: 24),
        const Text(
          'คำแนะนำเพื่อสุขภาพวันนี้',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              _buildTipRow(
                icon: Icons.lightbulb_outline_rounded,
                color: Colors.amber,
                title: 'ดื่มน้ำสม่ำเสมอ',
                desc: 'การจิบน้ำทุกๆ 1 ชั่วโมงช่วยให้สมองปลอดโปร่งและลดความเหนื่อยล้า',
              ),
              const Divider(height: 24, color: Color(0xFFF1F5F9)),
              _buildTipRow(
                icon: Icons.nights_stay_outlined,
                color: const Color(0xFF6366F1),
                title: 'นอนหลับ 7-9 ชั่วโมง',
                desc: 'การนอนหลับให้เพียงพอช่วยซ่อมแซมกล้ามเนื้อและเสริมสร้างภูมิคุ้มกัน',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required double progressValue,
    required Color progressColor,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF0F172A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: onAction,
                  style: TextButton.styleFrom(
                    foregroundColor: iconColor,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(actionLabel, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      const Icon(Icons.chevron_right_rounded, size: 18),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 8,
                backgroundColor: const Color(0xFFF1F5F9),
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipRow({
    required IconData icon,
    required Color color,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // TAB 2: WATER TRACKER
  // ===========================================================================
  Widget _buildWaterTab() {
    final double percent = (_currentWater / _waterGoal).clamp(0.0, 1.0);
    final int remaining = (_waterGoal - _currentWater).clamp(0, _waterGoal);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        // Main Water Progress Display
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 180,
                      height: 180,
                      child: CircularProgressIndicator(
                        value: percent,
                        strokeWidth: 14,
                        strokeCap: StrokeCap.round,
                        backgroundColor: const Color(0xFFE2E8F0),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0284C7)),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.water_drop_rounded,
                          size: 40,
                          color: Color(0xFF0284C7),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$_currentWater',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          '/ $_waterGoal ml',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${(percent * 100).toInt()}%',
                            style: const TextStyle(
                              color: Color(0xFF0284C7),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  remaining > 0
                      ? 'ดื่มอีก $remaining ml จะบรรลุเป้าหมายของวันนี้!'
                      : 'ยอดเยี่ยมมาก! คุณดื่มน้ำครบตามเป้าหมายแล้ว 🎉',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: remaining > 0 ? const Color(0xFF475569) : const Color(0xFF10B981),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),
        const Text(
          'เพิ่มปริมาณน้ำดื่ม',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 12),

        // Quick Add Buttons Row
        Row(
          children: [
            Expanded(
              child: _buildWaterAddButton(
                amount: 250,
                label: '+250 ml',
                sublabel: '1 แก้วน้ำ',
                icon: Icons.local_drink_rounded,
                onTap: () => _addWater(250),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildWaterAddButton(
                amount: 500,
                label: '+500 ml',
                sublabel: '1 ขวดน้ำ',
                icon: Icons.water_damage_rounded,
                onTap: () => _addWater(500),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _addWater(100),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('+100 ml (จิบน้ำ)'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0284C7),
                  side: const BorderSide(color: Color(0xFFBAE6FD)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _resetWater,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('รีเซ็ตข้อมูล'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFEF4444),
                  side: const BorderSide(color: Color(0xFFFECACA)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ประวัติการดื่มน้ำวันนี้',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            Text(
              '${_waterLogs.length} รายการ',
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (_waterLogs.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Center(
              child: Text(
                'ยังไม่มีบันทึกการดื่มน้ำวันนี้ กดปุ่มด้านบนเพื่อบันทึก',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              ),
            ),
          )
        else
          ..._waterLogs.map((log) => _buildWaterLogTile(log)),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildWaterAddButton({
    required int amount,
    required String label,
    required String sublabel,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0284C7),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      child: Column(
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(
            sublabel,
            style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterLogTile(WaterLog log) {
    final hour = log.time.hour.toString().padLeft(2, '0');
    final minute = log.time.minute.toString().padLeft(2, '0');

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.water_drop_rounded, color: Color(0xFF0284C7), size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              '+${log.amount} ml',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
            ),
          ),
          Text(
            '$hour:$minute น.',
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // TAB 3: SLEEP TRACKER
  // ===========================================================================
  Widget _buildSleepTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        // Sleep Overview Display Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bedtime_rounded,
                    color: Color(0xFF6366F1),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  '${_sleepHours.toStringAsFixed(1)} ชั่วโมง',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'คุณภาพการนอน: $_sleepQuality',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _sleepHours >= 7 && _sleepHours <= 9
                        ? const Color(0xFF10B981)
                        : const Color(0xFFF59E0B),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('เวลาเข้านอน', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          const SizedBox(height: 2),
                          Text(
                            _bedTime.format(context),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_rounded, color: Color(0xFF94A3B8), size: 18),
                      Column(
                        children: [
                          const Text('เวลาตื่นนอน', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          const SizedBox(height: 2),
                          Text(
                            _wakeTime.format(context),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),
        const Text(
          'เลือกเวลาเข้านอน - ตื่นนอน',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 12),

        // Time pickers
        Row(
          children: [
            Expanded(
              child: _buildTimePickerTile(
                title: 'เวลาเข้านอน',
                time: _bedTime,
                icon: Icons.nightlight_round,
                color: const Color(0xFF6366F1),
                onTap: () => _selectTime(true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTimePickerTile(
                title: 'เวลาตื่นนอน',
                time: _wakeTime,
                icon: Icons.wb_sunny_rounded,
                color: const Color(0xFFF59E0B),
                onTap: () => _selectTime(false),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),
        const Text(
          'หรือ ปรับจำนวนชั่วโมงโดยตรง',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
        ),
        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('ปรับชั่วโมงการนอน:', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                  Text(
                    '${_sleepHours.toStringAsFixed(1)} ชม.',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF6366F1)),
                  ),
                ],
              ),
              Slider(
                value: _sleepHours,
                min: 3.0,
                max: 12.0,
                divisions: 18,
                activeColor: const Color(0xFF6366F1),
                inactiveColor: const Color(0xFFE2E8F0),
                label: '${_sleepHours.toStringAsFixed(1)} ชม.',
                onChanged: (val) {
                  setState(() {
                    _sleepHours = val;
                  });
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        const Text(
          'ความรู้สึกหลังตื่นนอน (คุณภาพ)',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
        ),
        const SizedBox(height: 10),

        Wrap(
          spacing: 8,
          children: ['ดีเยี่ยม', 'สดชื่น', 'พอใช้', 'ยังเพลียอยู่'].map((quality) {
            final isSelected = _sleepQuality == quality;
            return ChoiceChip(
              label: Text(quality),
              selected: isSelected,
              selectedColor: const Color(0xFFEEF2FF),
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF64748B),
                fontWeight: isSelected ? FontWeight.bold : FontWeig  // ===========================================================================
  // TAB 4: WORKOUT MISSIONS & CHALLENGES
  // ===========================================================================
  Widget _buildWorkoutTab() {
    final categories = ['ทั้งหมด', 'Full Body', 'Push', 'Pull', 'Legs', 'Core'];
    final filteredMissions = _selectedMissionCategory == 'ทั้งหมด'
        ? _workoutMissions
        : _workoutMissions.where((m) => m.category == _selectedMissionCategory).toList();

    final totalBurned = _workoutRecords.fold<int>(0, (sum, w) => sum + (w.durationMinutes * 8));

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        // Hero Mission Center Banner
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF065F46), Color(0xFF047857), Color(0xFF059669)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF059669).withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.military_tech_rounded, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'MISSION CENTER',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  if (_isSubscribed)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 12),
                          SizedBox(width: 4),
                          Text('EXP x1.5 ACTIVE', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'ภารกิจออกกำลังกาย (Workout Missions)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'เลือกภารกิจที่ออกแบบโดยผู้เชี่ยวชาญ พิชิตท่าฝึกเพื่อรับ EXP, เหรียญ และเบิร์นแคลอรี',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 16),

              // Mini summary row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0x22FFFFFF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'พิชิตแล้ว: ${_workoutRecords.length} ครั้ง',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Container(width: 1, height: 16, color: Colors.white30),
                    Text(
                      'เบิร์นสะสม: ~$totalBurned kcal 🔥',
                      style: const TextStyle(color: Color(0xFFFDE68A), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Category Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((cat) {
              final isSelected = _selectedMissionCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _selectedMissionCategory = cat);
                  },
                  selectedColor: const Color(0xFF10B981),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF475569),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 12,
                  ),
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: isSelected ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 16),

        // Missions List
        ...filteredMissions.map((mission) => _buildMissionCard(mission)),

        const SizedBox(height: 24),

        // Workout History Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ประวัติการออกกำลังกายที่พิชิตแล้ว',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            Text(
              '${_workoutRecords.length} รายการ',
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (_workoutRecords.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Center(
              child: Text(
                'ยังไม่มีประวัติภารกิจ เลือกภารกิจด้านบนแล้วกด "เริ่มภารกิจ" ได้เลย!',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              ),
            ),
          )
        else
          ..._workoutRecords.asMap().entries.map((entry) {
            final idx = entry.key;
            final record = entry.value;
            return _buildWorkoutHistoryCard(record, idx);
          }),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildMissionCard(WorkoutMission mission) {
    final expReward = _isSubscribed ? (mission.expReward * 1.5).toInt() : mission.expReward;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: mission.isCompletedToday ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
          width: mission.isCompletedToday ? 1.5 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(mission.icon, color: const Color(0xFF10B981), size: 26),
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
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mission.title,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            mission.subtitle,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4),
          ),
          const SizedBox(height: 14),

          // Pills row
          Row(
            children: [
              _buildBadgePill(Icons.timer_outlined, '${mission.durationMinutes} นาที', const Color(0xFF0284C7)),
              const SizedBox(width: 8),
              _buildBadgePill(Icons.local_fire_department_rounded, '~${mission.caloriesBurn} kcal', const Color(0xFFEF4444)),
              const SizedBox(width: 8),
              _buildBadgePill(Icons.bolt_rounded, '+$expReward EXP', const Color(0xFFF59E0B)),
            ],
          ),
          const SizedBox(height: 14),

          // Action button
          SizedBox(
            width: double.infinity,
            child: mission.isCompletedToday
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 18),
                        SizedBox(width: 6),
                        Text(
                          'พิชิตภารกิจนี้แล้ววันนี้ ✓',
                          style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : ElevatedButton.icon(
                    onPressed: () {
                      showWorkoutMissionModal(
                        context: context,
                        mission: mission,
                        onCompleteMission: _completeWorkoutMission,
                      );
                    },
                    icon: const Icon(Icons.play_arrow_rounded, size: 20),
                    label: const Text('เริ่มทำภารกิจนี้'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgePill(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }�ำลังกายและเซต...',
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _addWorkoutLog,
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: const Text('บันทึกการออกกำลังกาย'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
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
        ),

        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ประวัติการออกกำลังกาย',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            Text(
              '${_workoutRecords.length} ครั้ง',
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (_workoutRecords.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Center(
              child: Text(
                'ยังไม่มีประวัติการออกกำลังกาย เริ่มบันทึกกันเลย!',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              ),
            ),
          )
        else
          ..._workoutRecords.asMap().entries.map((entry) {
            final idx = entry.key;
            final record = entry.value;
            return _buildWorkoutHistoryCard(record, idx);
          }),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTemplateChip(String name, String sub, IconData icon) {
    final isSelected = _selectedTemplate == name;
    return Expanded(
      child: InkWell(
        onTap: () => _onTemplateSelected(name),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFECFDF5) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF10B981) : const Color(0xFF64748B),
                size: 24,
              ),
              const SizedBox(height: 6),
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isSelected ? const Color(0xFF065F46) : const Color(0xFF0F172A),
                ),
              ),
              Text(
                sub,
                style: TextStyle(
                  fontSize: 9,
                  color: isSelected ? const Color(0xFF047857) : const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutHistoryCard(WorkoutRecord record, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${record.category} Day',
                  style: const TextStyle(
                    color: Color(0xFF065F46),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer_outlined, size: 12, color: Color(0xFF64748B)),
                    const SizedBox(width: 4),
                    Text(
                      '${record.durationMinutes} นาที',
                      style: const TextStyle(color: Color(0xFF475569), fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFF94A3B8), size: 20),
                onPressed: () => _deleteWorkout(index),
                visualDensity: VisualDensity.compact,
                tooltip: 'ลบรายการนี้',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            record.exercises,
            style: const TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.4),
          ),
        ],
      ),
    );
  }
}
