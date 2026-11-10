import 'package:flutter/material.dart';

import '../models/health_models.dart';

class AppState extends ChangeNotifier {
  // ==========================================================================
  // 1. DUAL-ENTITY: USER HERO & VIRTUAL PET
  // ==========================================================================
  final UserHero _hero = UserHero(
    id: 'hero_1',
    name: 'Hero Alex',
    heroClass: HeroClass.warrior,
    level: 6,
    exp: 480,
    maxExp: 650,
    atk: 240,
    maxHp: 1000,
    currentHp: 880,
    maxMp: 100,
    currentMp: 85,
  );

  VirtualPet _pet = VirtualPet(
    id: 'pet_kuro',
    petType: PetType.shibaInu,
    name: 'Kuro (คุโระ)',
    level: 5,
    xp: 380,
    maxXp: 550,
    stage: PetEvolutionStage.teen,
    hunger: 80.0,
    happiness: 92.0,
    energy: 88.0,
    equippedAccessory: '🕶️ Cool Shades',
  );

  final List<VirtualPet> _availablePets = [
    VirtualPet(
      id: 'pet_shiba',
      petType: PetType.shibaInu,
      name: 'Kuro (คุโระ)',
      level: 5,
      xp: 380,
      maxXp: 550,
      stage: PetEvolutionStage.teen,
      hunger: 80.0,
      happiness: 92.0,
      energy: 88.0,
      equippedAccessory: '🕶️ Cool Shades',
    ),
    VirtualPet(
      id: 'pet_dragon',
      petType: PetType.babyDragon,
      name: 'Ignis (อิกนิส)',
      level: 4,
      xp: 210,
      maxXp: 500,
      stage: PetEvolutionStage.baby,
      hunger: 70.0,
      happiness: 85.0,
      energy: 80.0,
    ),
    VirtualPet(
      id: 'pet_slime',
      petType: PetType.slime,
      name: 'Bubbles (บับเบิ้ล)',
      level: 4,
      xp: 190,
      maxXp: 500,
      stage: PetEvolutionStage.baby,
      hunger: 90.0,
      happiness: 88.0,
      energy: 95.0,
    ),
    VirtualPet(
      id: 'pet_cat',
      petType: PetType.mochiCat,
      name: 'Yuki (ยูกิ)',
      level: 5,
      xp: 340,
      maxXp: 550,
      stage: PetEvolutionStage.teen,
      hunger: 75.0,
      happiness: 90.0,
      energy: 92.0,
    ),
  ];

  // Subscription & Coins
  SubscriptionTier _subscriptionTier = SubscriptionTier.free;
  int _userCoins = 450;
  int _battlePower = 10;
  int _streakDays = 7;
  bool _hasStreakShield = true;
  final Set<String> _inventory = {
    'streak_shield',
    'pet_apple',
    'acc_sunglasses',
  };
  String _cloudSyncStatus = 'ยังไม่ได้เชื่อมต่อ Health Connect / Apple Health';
  bool _isSyncing = false;

  // ==========================================================================
  // 2. AI FOOD SCANNER & GAMIFIED NUTRITION
  // ==========================================================================
  final List<FoodNutrition> _foodScans = [
    FoodNutrition(
      id: 'scan_1',
      foodName: 'สลัดอกไก่ย่างควินัว & อะโวคาโด',
      calories: 420,
      protein: 38.5,
      carbs: 32.0,
      fat: 12.0,
      healthScore: 9.4,
      confidence: 0.98,
      emoji: '🥗',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      source: HealthDataSource.aiEstimated,
    ),
    FoodNutrition(
      id: 'scan_2',
      foodName: 'ข้าวกล้องปลาแซลมอนย่างเทอริยากิ',
      calories: 540,
      protein: 42.0,
      carbs: 52.0,
      fat: 16.0,
      healthScore: 9.1,
      confidence: 0.95,
      emoji: '🍱',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      source: HealthDataSource.aiEstimated,
    ),
  ];

  final List<DigitalFoodItem> _digitalPantry = [
    DigitalFoodItem(
      id: 'dp_1',
      name: 'สลัดคลีนดิจิทัล 🥗',
      emoji: '🥗',
      calories: 420,
      hungerRestore: 35.0,
      happyBonus: 22.0,
      obtainedAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    DigitalFoodItem(
      id: 'dp_2',
      name: 'แซลมอนโปรตีนบาร์ 🍣',
      emoji: '🍣',
      calories: 540,
      hungerRestore: 45.0,
      happyBonus: 25.0,
      obtainedAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    DigitalFoodItem(
      id: 'dp_3',
      name: 'แอปเปิ้ลฟื้นฟูพลัง 🍎',
      emoji: '🍎',
      calories: 95,
      hungerRestore: 20.0,
      happyBonus: 15.0,
      obtainedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  // ==========================================================================
  // 3. SMARTWATCH SYNC & HEALTH TRACKERS
  // ==========================================================================
  int _waterMl = 1750;
  final int _waterGoalMl = 2000;
  int _stepsToday = 8420;
  final int _stepsGoal = 10000;
  int _activeCalories = 540;
  HealthDataSource _stepsSource = HealthDataSource.manualInput;

  SleepData _sleepData = SleepData(
    bedTime: DateTime.now().subtract(const Duration(hours: 8, minutes: 15)),
    wakeTime: DateTime.now().subtract(const Duration(minutes: 45)),
    durationHours: 7.5,
    qualityScore: 88,
    deepSleepHours: 2.2,
    remSleepHours: 1.8,
    lightSleepHours: 3.5,
    source: HealthDataSource.manualInput,
  );

  // ==========================================================================
  // 4. WORKOUT PLANNER & LIVE TRACKER
  // ==========================================================================
  final List<WorkoutPlan> _workoutPlans = [
    WorkoutPlan(
      id: 'wp_push',
      title: 'Push Day - อก ไหล่ หลังแขน',
      category: 'Push',
      dayOfWeek: 'วันจันทร์ & พฤหัสบดี',
      targetDurationMinutes: 50,
      estimatedCalories: 380,
      isCompleted: true,
      exercises: [
        WorkoutExerciseItem(
          id: 'ex_1',
          name: 'Barbell Bench Press',
          muscleTarget: 'อกกลาง',
          targetSets: 4,
          completedSets: 4,
          reps: 10,
          weightKg: 70,
          isCompleted: true,
        ),
        WorkoutExerciseItem(
          id: 'ex_2',
          name: 'Incline Dumbbell Press',
          muscleTarget: 'อกบน',
          targetSets: 4,
          completedSets: 4,
          reps: 12,
          weightKg: 24,
          isCompleted: true,
        ),
        WorkoutExerciseItem(
          id: 'ex_3',
          name: 'Dumbbell Lateral Raise',
          muscleTarget: 'ไหล่ข้าง',
          targetSets: 4,
          completedSets: 4,
          reps: 15,
          weightKg: 10,
          isCompleted: true,
        ),
        WorkoutExerciseItem(
          id: 'ex_4',
          name: 'Tricep Rope Pushdown',
          muscleTarget: 'หลังแขน',
          targetSets: 3,
          completedSets: 3,
          reps: 12,
          weightKg: 25,
          isCompleted: true,
        ),
      ],
    ),
    WorkoutPlan(
      id: 'wp_pull',
      title: 'Pull Day - หลัง ปีก หน้าแขน',
      category: 'Pull',
      dayOfWeek: 'วันอังคาร & ศุกร์',
      targetDurationMinutes: 45,
      estimatedCalories: 350,
      exercises: [
        WorkoutExerciseItem(
          id: 'ex_5',
          name: 'Lat Pulldown',
          muscleTarget: 'ปีกหลัง',
          targetSets: 4,
          reps: 10,
          weightKg: 55,
        ),
        WorkoutExerciseItem(
          id: 'ex_6',
          name: 'Seated Cable Row',
          muscleTarget: 'หลังกลาง',
          targetSets: 4,
          reps: 12,
          weightKg: 50,
        ),
        WorkoutExerciseItem(
          id: 'ex_7',
          name: 'Face Pulls',
          muscleTarget: 'ไหล่หลัง',
          targetSets: 4,
          reps: 15,
          weightKg: 20,
        ),
        WorkoutExerciseItem(
          id: 'ex_8',
          name: 'Bicep Barbell Curl',
          muscleTarget: 'หน้าแขน',
          targetSets: 3,
          reps: 10,
          weightKg: 25,
        ),
      ],
    ),
    WorkoutPlan(
      id: 'wp_legs',
      title: 'Legs & Core - ขา ก้น แกนกลาง',
      category: 'Legs',
      dayOfWeek: 'วันพุธ & เสาร์',
      targetDurationMinutes: 55,
      estimatedCalories: 450,
      exercises: [
        WorkoutExerciseItem(
          id: 'ex_9',
          name: 'Barbell Back Squat',
          muscleTarget: 'หน้าขา & ก้น',
          targetSets: 4,
          reps: 8,
          weightKg: 80,
        ),
        WorkoutExerciseItem(
          id: 'ex_10',
          name: 'Romanian Deadlift',
          muscleTarget: 'หลังขา',
          targetSets: 4,
          reps: 10,
          weightKg: 75,
        ),
        WorkoutExerciseItem(
          id: 'ex_11',
          name: 'Leg Press',
          muscleTarget: 'ต้นขา',
          targetSets: 4,
          reps: 12,
          weightKg: 140,
        ),
        WorkoutExerciseItem(
          id: 'ex_12',
          name: 'Hanging Leg Raise',
          muscleTarget: 'หน้าท้องล่าง',
          targetSets: 3,
          reps: 15,
          weightKg: 0,
        ),
      ],
    ),
  ];

  WorkoutPlan? _activeLiveWorkout;
  int _liveSecondsElapsed = 0;
  bool _isLiveTimerRunning = false;

  // ==========================================================================
  // 5. RPG BOSS & AI CHAT
  // ==========================================================================
  BossEnemy _weeklyBoss = BossEnemy(
    id: 'boss_w1',
    name: 'Lord Sloth (จอมมารความขี้เกียจ)',
    title: 'จอมมารแห่งเตียงดูดวิญญาณ',
    description: 'จอมมารที่สะกดจิตให้คุณไม่อยากขยับตัว! โจมตีด้วยการออกกำลังกายและดื่มน้ำเพื่อปราบมัน!',
    maxHp: 2000,
    currentHp: 1100,
    emoji: '👹💤',
    rewardCoins: 150,
    rewardXp: 300,
    weakness: 'Cardio & Workout ATK Boost',
  );

  int _aiMessagesUsedToday = 2;
  final int _freeDailyAiLimit = 5;
  final List<HealthCoachMessage> _chatMessages = [
    HealthCoachMessage(
      id: 'm1',
      sender: 'ai',
      text: 'สวัสดีครับ Master Alex! ผมคือ AI Health Companion ของคุณ วันนี้ตรวจพบว่านอนหลับ 7.5 ชม. (คุณภาพ 88%) สัตว์เลี้ยง Kuro กำลังคึกคักมาก! มีเมนูอาหารหรือตารางเวทที่อยากปรึกษาไหมครับ? 🌟',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      contextBadges: ['Sleep: 7.5h (88%)', 'Water: 1,750ml', 'Hero ATK: 240'],
    ),
  ];

  // Shop Catalog
  final List<HealthShopItem> _shopCatalog = const [
    HealthShopItem(
      id: 'pet_apple',
      name: 'แอปเปิ้ลออร์แกนิก',
      description: 'ของว่างเพิ่มค่าความสดชื่นและความสุขให้สัตว์เลี้ยง',
      price: 25,
      category: ShopCategory.petItem,
      iconEmoji: '🍎',
      effect: '+20 ความสุข & +15 พลังงานสัตว์เลี้ยง',
    ),
    HealthShopItem(
      id: 'pet_potion',
      name: 'Energy Elixir',
      description: 'ยาวิเศษฟื้นฟูพลังงานสัตว์เลี้ยงทันที',
      price: 60,
      category: ShopCategory.petItem,
      iconEmoji: '🧪✨',
      effect: '+50 พลังงาน & เติม MP ตัวละครเต็ม',
    ),
    HealthShopItem(
      id: 'acc_sunglasses',
      name: 'Cool Shades (แว่นกันแดดสุดเท่)',
      description: 'ตกแต่งสัตว์เลี้ยงของคุณให้ดูคูลไม่ซ้ำใคร',
      price: 90,
      category: ShopCategory.petItem,
      iconEmoji: '🕶️',
      effect: 'สวมใส่เป็น Accessories ให้สัตว์เลี้ยง',
    ),
    HealthShopItem(
      id: 'acc_crown',
      name: 'Golden Crown (มงกุฎทองคำ)',
      description: 'มงกุฎสำหรับผู้พิชิตเป้าหมายสุขภาพ',
      price: 180,
      category: ShopCategory.petItem,
      iconEmoji: '👑',
      effect: 'ปลดล็อกออร่าประกายแสงรอบตัวสัตว์เลี้ยง',
    ),
    HealthShopItem(
      id: 'acc_cyber_wings',
      name: 'Cybernetic Wings (ปีกไซเบอร์พรีเมียม)',
      description: 'ปีกแสงไซเบอร์สุดอลังการสำหรับ Pro Members เท่านั้น',
      price: 250,
      category: ShopCategory.petItem,
      iconEmoji: '🪽⚡',
      isProOnly: true,
      effect: '[PRO] สวมใส่ปีกอัศวินจักรกล + EXP Bonus 20%',
    ),
    HealthShopItem(
      id: 'theme_cyberpunk',
      name: 'Cyberpunk Neon Theme',
      description: 'เปลี่ยนโทนสีแอปเป็นนีออนฟ้า-ม่วงสไตล์ล้ำยุค',
      price: 120,
      category: ShopCategory.appCosmetic,
      iconEmoji: '🌌',
      effect: 'สกินธีม Cyberpunk สำหรับ Dashboard',
    ),
    HealthShopItem(
      id: 'theme_forest',
      name: 'Emerald Forest Theme',
      description: 'โทนสีธรรมชาติ มิ้นต์สดชื่น สบายตา',
      price: 100,
      category: ShopCategory.appCosmetic,
      iconEmoji: '🍃',
      effect: 'สกินธีม Forest Green สบายตา',
    ),
    HealthShopItem(
      id: 'streak_shield',
      name: 'Streak Shield (การ์ดกันโล่หลุด)',
      description: 'ป้องกันสถิติ Streak หลุดหากคุณลืมบันทึก 1 วันอัตโนมัติ',
      price: 80,
      category: ShopCategory.utilityPerk,
      iconEmoji: '🛡️',
      effect: 'ปกป้อง Streak วันที่ขาดหายไป 1 วัน',
    ),
    HealthShopItem(
      id: 'loot_ticket',
      name: 'Weekly Rare Loot Ticket',
      description: 'ตั๋วสุ่มเปิดกล่องสมบัติรับรางวัลแรร์ประจำสัปดาห์',
      price: 70,
      category: ShopCategory.utilityPerk,
      iconEmoji: '🎟️🎁',
      effect: 'สุ่มรับเหรียญ 50-300 coins หรือชุดตกแต่งพิเศษ',
    ),
  ];

  // ==========================================================================
  // GETTERS
  // ==========================================================================
  UserHero get hero => _hero;
  VirtualPet get pet => _pet;
  List<VirtualPet> get availablePets => List.unmodifiable(_availablePets);
  SubscriptionTier get subscriptionTier => _subscriptionTier;
  bool get isPro => _subscriptionTier == SubscriptionTier.pro;
  int get userCoins => _userCoins;
  int get battlePower => _battlePower;
  int get streakDays => _streakDays;
  bool get hasStreakShield => _hasStreakShield;
  Set<String> get inventory => _inventory;
  String get cloudSyncStatus => _cloudSyncStatus;
  bool get isSyncing => _isSyncing;
  List<HealthShopItem> get shopCatalog => _shopCatalog;

  int get playerHp => _hero.currentHp;
  int get playerMaxHp => _hero.maxHp;
  int get playerMp => _hero.currentMp;
  int get playerMaxMp => _hero.maxMp;
  int get playerAtk => _hero.atk;
  int get freeDailyAiLimit => _freeDailyAiLimit;
  SleepData get sleepRecord => _sleepData;
  List<WorkoutSession> get workouts => [
    WorkoutSession(
      id: 'ws_1',
      title: 'Push Day (อก/ไหล่)',
      category: 'Push',
      durationMinutes: 45,
      caloriesBurned: 350,
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      source: HealthDataSource.manualInput,
    ),
  ];

  List<FoodNutrition> get foodScans => List.unmodifiable(_foodScans);
  List<DigitalFoodItem> get digitalPantry => List.unmodifiable(_digitalPantry);

  int get waterMl => _waterMl;
  int get waterGoalMl => _waterGoalMl;
  double get waterProgress => (_waterMl / _waterGoalMl).clamp(0.0, 1.0);

  int get stepsToday => _stepsToday;
  int get stepsGoal => _stepsGoal;
  double get stepsProgress => (_stepsToday / _stepsGoal).clamp(0.0, 1.0);
  int get activeCalories => _activeCalories;
  HealthDataSource get stepsSource => _stepsSource;

  // Calorie in vs out
  int get totalCaloriesIn => _foodScans.fold(0, (sum, f) => sum + f.calories);
  int get totalCaloriesOut =>
      _activeCalories +
      (_workoutPlans
          .where((w) => w.isCompleted)
          .fold(0, (sum, w) => sum + w.estimatedCalories));

  SleepData get sleepData => _sleepData;
  List<WorkoutPlan> get workoutPlans => List.unmodifiable(_workoutPlans);
  void addCustomWorkoutPlan(String title, List<String> exerciseNames) {
    final stamp = DateTime.now().microsecondsSinceEpoch;
    final exercises = exerciseNames
        .where((name) => name.trim().isNotEmpty)
        .toList()
        .asMap()
        .entries
        .map((entry) => WorkoutExerciseItem(
              id: 'custom_${stamp}_${entry.key}',
              name: entry.value.trim(),
              muscleTarget: 'กำหนดเอง',
              targetSets: 3,
              reps: 10,
              weightKg: 0,
            ))
        .toList();
    if (title.trim().isEmpty || exercises.isEmpty) return;
    _workoutPlans.add(WorkoutPlan(
      id: 'custom_$stamp',
      title: title.trim(),
      category: 'กำหนดเอง',
      dayOfWeek: 'โปรแกรมส่วนตัว',
      targetDurationMinutes: 30,
      estimatedCalories: 180,
      exercises: exercises,
    ));
    notifyListeners();
  }
  WorkoutPlan? get activeLiveWorkout => _activeLiveWorkout;
  int get liveSecondsElapsed => _liveSecondsElapsed;
  bool get isLiveTimerRunning => _isLiveTimerRunning;

  BossEnemy get weeklyBoss => _weeklyBoss;
  int get remainingAiMessages => isPro
      ? 999
      : (_freeDailyAiLimit - _aiMessagesUsedToday).clamp(0, _freeDailyAiLimit);
  List<HealthCoachMessage> get chatMessages => List.unmodifiable(_chatMessages);

  // ==========================================================================
  // ACTIONS: PET SELECTION & HERO CLASS
  // ==========================================================================
  void selectCompanionPet(PetType type) {
    final found = _availablePets.firstWhere(
      (p) => p.petType == type,
      orElse: () => _availablePets.first,
    );
    _pet = found;
    notifyListeners();
  }

  void switchHeroClass(HeroClass newClass) {
    _hero.heroClass = newClass;
    if (newClass == HeroClass.warrior) {
      _hero.atk += 25;
    } else if (newClass == HeroClass.paladin) {
      _hero.maxHp += 100;
      _hero.currentHp = _hero.maxHp;
    } else if (newClass == HeroClass.mage) {
      _hero.maxMp += 30;
      _hero.currentMp = _hero.maxMp;
    }
    notifyListeners();
  }

  // ==========================================================================
  // ACTIONS: AI FOOD SCANNER & GAMIFIED FEEDING
  // ==========================================================================
  void scanFoodWithAi({
    required String foodName,
    required int calories,
    required double protein,
    required double carbs,
    required double fat,
    required double healthScore,
    required String emoji,
  }) {
    final scan = FoodNutrition(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      foodName: foodName,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      healthScore: healthScore,
      emoji: emoji,
      timestamp: DateTime.now(),
      source: HealthDataSource.aiEstimated,
    );

    _foodScans.insert(0, scan);

    // Convert into Digital Food Item for Pet!
    final digitalFood = scan.toDigitalFood();
    _digitalPantry.insert(0, digitalFood);

    // Reward Hero
    _hero.gainExp(50);
    _hero.currentMp = (_hero.currentMp + 15).clamp(0, _hero.maxMp);
    _userCoins += 15;

    notifyListeners();
  }

  void logMeal({
    required String name,
    required int calories,
    required double protein,
    required double carbs,
    required double fat,
  }) {
    _foodScans.insert(
      0,
      FoodNutrition(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        foodName: name,
        calories: calories,
        protein: protein,
        carbs: carbs,
        fat: fat,
        healthScore: 0,
        emoji: '🍽️',
        timestamp: DateTime.now(),
        source: HealthDataSource.manualInput,
      ),
    );
    notifyListeners();
  }

  bool feedPetDigitalFood(DigitalFoodItem foodItem) {
    _digitalPantry.remove(foodItem);
    _pet.hunger = (_pet.hunger + foodItem.hungerRestore).clamp(0.0, 100.0);
    _pet.happiness = (_pet.happiness + foodItem.happyBonus).clamp(0.0, 100.0);
    _pet.gainXp(30);

    _hero.gainExp(25);
    notifyListeners();
    return true;
  }

  void feedPet([String? itemName]) {
    _pet.hunger = (_pet.hunger + 25).clamp(0.0, 100.0);
    _pet.happiness = (_pet.happiness + 15).clamp(0.0, 100.0);
    _pet.gainXp(20);
    notifyListeners();
  }

  void petThePet() {
    _pet.happiness = (_pet.happiness + 8).clamp(0.0, 100.0);
    _pet.gainXp(12);
    _hero.gainExp(10);
    notifyListeners();
  }

  // ==========================================================================
  // ACTIONS: SMARTWATCH AUTO-SYNC
  // ==========================================================================
  Future<void> syncSmartwatchData() async {
    _isSyncing = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _cloudSyncStatus =
        'ยังไม่ได้เชื่อมต่อ — ข้อมูลปัจจุบันเป็นการกรอก/ตัวอย่าง';
    _isSyncing = false;
    notifyListeners();
  }

  // Water Quick Add
  void addWater(
    int amountMl, {
    HealthDataSource source = HealthDataSource.manualInput,
  }) {
    _waterMl += amountMl;
    _hero.currentMp = (_hero.currentMp + (amountMl ~/ 20)).clamp(
      0,
      _hero.maxMp,
    );
    _pet.gainXp(10);
    if (_waterMl >= _waterGoalMl) {
      _userCoins += 10;
    }
    notifyListeners();
  }

  void recordSleep({
    required double durationHours,
    required int qualityScore,
    DateTime? bedTime,
    DateTime? wakeTime,
    HealthDataSource source = HealthDataSource.manualInput,
  }) {
    _sleepData = SleepData(
      bedTime:
          bedTime ??
          DateTime.now().subtract(
            Duration(minutes: (durationHours * 60).round()),
          ),
      wakeTime: wakeTime ?? DateTime.now(),
      durationHours: durationHours,
      qualityScore: qualityScore,
      source: source,
    );
    _pet.energy = 100.0;
    _userCoins += 20;
    notifyListeners();
  }

  void logWorkout({
    required String title,
    required String category,
    required int durationMinutes,
    required int caloriesBurned,
    HealthDataSource source = HealthDataSource.manualInput,
  }) {
    _hero.atk += 15;
    _hero.gainExp(100);
    _activeCalories += caloriesBurned;
    _userCoins += 30;
    _pet.happiness = (_pet.happiness + 15).clamp(0.0, 100.0);
    notifyListeners();
  }

  // ==========================================================================
  // ACTIONS: WORKOUT PLANNER & LIVE TRACKER
  // ==========================================================================
  void startLiveWorkout(WorkoutPlan plan) {
    _activeLiveWorkout = plan;
    _liveSecondsElapsed = 0;
    _isLiveTimerRunning = true;
    notifyListeners();
  }

  void toggleLiveTimer() {
    _isLiveTimerRunning = !_isLiveTimerRunning;
    notifyListeners();
  }

  void incrementLiveTimer() {
    if (_isLiveTimerRunning) {
      _liveSecondsElapsed++;
      notifyListeners();
    }
  }

  void toggleExerciseSet(String planId, String exerciseId) {
    final plan = _workoutPlans.firstWhere(
      (p) => p.id == planId,
      orElse: () => _workoutPlans.first,
    );
    final ex = plan.exercises.firstWhere((e) => e.id == exerciseId);
    ex.isCompleted = !ex.isCompleted;
    if (ex.isCompleted) {
      ex.completedSets = ex.targetSets;
    } else {
      ex.completedSets = 0;
    }
    notifyListeners();
  }

  void finishLiveWorkout(WorkoutPlan plan) {
    plan.isCompleted = true;
    for (var ex in plan.exercises) {
      ex.isCompleted = true;
      ex.completedSets = ex.targetSets;
    }

    // RPG Rewards: Hero ATK & EXP Grow!
    _hero.atk += 20; // Permanent ATK boost!
    _hero.gainExp(140);
    _activeCalories += plan.estimatedCalories;
    _userCoins += 40;
    _pet.happiness = (_pet.happiness + 20).clamp(0.0, 100.0);
    _pet.gainXp(60);

    _activeLiveWorkout = null;
    _isLiveTimerRunning = false;
    _liveSecondsElapsed = 0;

    notifyListeners();
  }

  // ==========================================================================
  // ACTIONS: SHOP, SUBSCRIPTION & BOSS
  // ==========================================================================
  void toggleSubscriptionTier() {
    if (_subscriptionTier == SubscriptionTier.free) {
      _subscriptionTier = SubscriptionTier.pro;
      _pet.stage = PetEvolutionStage.mythicalPro;
    } else {
      _subscriptionTier = SubscriptionTier.free;
      if (_pet.stage == PetEvolutionStage.mythicalPro) {
        _pet.stage = _pet.level >= 10
            ? PetEvolutionStage.adult
            : PetEvolutionStage.teen;
      }
    }
    notifyListeners();
  }

  bool buyShopItem(HealthShopItem item) {
    if (item.isProOnly && !isPro) return false;
    if (_userCoins < item.price) return false;

    _userCoins -= item.price;
    _inventory.add(item.id);

    if (item.id == 'streak_shield') _hasStreakShield = true;
    if (item.id == 'pet_apple') {
      _pet.hunger = (_pet.hunger + 20).clamp(0.0, 100.0);
      _pet.happiness = (_pet.happiness + 15).clamp(0.0, 100.0);
    }
    if (item.id == 'pet_potion') {
      _pet.energy = (_pet.energy + 50).clamp(0.0, 100.0);
      _hero.currentMp = _hero.maxMp;
    }
    if (item.id == 'acc_sunglasses') _pet.equippedAccessory = '🕶️ Cool Shades';
    if (item.id == 'acc_crown') _pet.equippedAccessory = '👑 Golden Crown';
    if (item.id == 'acc_cyber_wings')
      _pet.equippedAccessory = '🪽⚡ Cyber Wings';

    notifyListeners();
    return true;
  }

  bool upgradeBattlePower() {
    const cost = 100;
    if (_userCoins < cost) return false;
    _userCoins -= cost;
    _battlePower += 10;
    notifyListeners();
    return true;
  }

  void addMockCoins(int amount) {
    if (amount <= 0) return;
    _userCoins += amount;
    notifyListeners();
  }

  String attackBoss(String attackType) {
    if (_weeklyBoss.isDefeated) {
      return 'บอสพ่ายแพ้ไปแล้ว! คุณได้รับชัยชนะประจำสัปดาห์! 🎉';
    }

    int damage = 0;
    String moveName = '';

    if (attackType == 'physical') {
      damage = _battlePower;
      moveName = '💥 โจมตี';
    } else if (attackType == 'hydro') {
      damage = _battlePower * 2;
      moveName = '⚡ โจมตีหนัก';
    } else if (attackType == 'shield') {
      damage = _battlePower * 3;
      moveName = '🛡️ ท่าไม้ตาย';
    }

    _weeklyBoss.currentHp = (_weeklyBoss.currentHp - damage).clamp(
      0,
      _weeklyBoss.maxHp,
    );
    String result = '$moveName สร้างความเสียหาย $damage ดาเมจ!';

    if (_weeklyBoss.isDefeated) {
      _userCoins += _weeklyBoss.rewardCoins;
      _hero.gainExp(_weeklyBoss.rewardXp);
      _pet.gainXp(_weeklyBoss.rewardXp);
      result +=
          '\n\n🏆 มหาศึกสิ้นสุด! คุณปราบบอสสำเร็จ ได้รับ +${_weeklyBoss.rewardCoins} Health Coins & กล่องสุ่ม Rare! 🎁✨';
    }

    notifyListeners();
    return result;
  }

  bool sendChatMessage(String messageText) {
    if (!isPro && _aiMessagesUsedToday >= _freeDailyAiLimit) return false;

    final now = DateTime.now();
    _chatMessages.add(
      HealthCoachMessage(
        id: now.millisecondsSinceEpoch.toString(),
        sender: 'user',
        text: messageText,
        timestamp: now,
      ),
    );

    _aiMessagesUsedToday++;

    final reply = _generateContextAwareResponse(messageText);
    final contextTags = [
      'Master ATK: ${_hero.atk}',
      'Companion: ${_pet.name}',
      'Sleep: ${_sleepData.durationHours}h',
      'Calories In/Out: $totalCaloriesIn/$totalCaloriesOut',
    ];

    Future.delayed(const Duration(milliseconds: 600), () {
      _chatMessages.add(
        HealthCoachMessage(
          id: (now.millisecondsSinceEpoch + 1).toString(),
          sender: 'ai',
          text: reply,
          timestamp: DateTime.now(),
          contextBadges: contextTags,
        ),
      );
      notifyListeners();
    });

    notifyListeners();
    return true;
  }

  String _generateContextAwareResponse(String prompt) {
    final lower = prompt.toLowerCase();
    if (lower.contains('อาหาร') ||
        lower.contains('กิน') ||
        lower.contains('แคล') ||
        lower.contains('สแกน')) {
      return 'จากการวิเคราะห์อาหาร AI วันนี้ คุณรับพลังงานไปแล้ว $totalCaloriesIn kcal (เบิร์นออกไป $totalCaloriesOut kcal)!\n\n💡 สัตว์เลี้ยง ${_pet.name} กำลังมีค่าความอิ่ม ${_pet.hunger.round()}% นำอาหารดิจิทัลที่คุณสแกนไปป้อนใน Pet Room ได้เลยนะครับ เพื่อช่วยเพิ่มค่าความสุขและความผูกพัน!';
    } else if (lower.contains('นอน') ||
        lower.contains('หลับ') ||
        lower.contains('นาฬิกา')) {
      return 'ข้อมูลจาก Apple Watch เมื่อคืน: คุณนอนหลับ ${_sleepData.durationHours} ชม. (หลับลึก Deep Sleep ${_sleepData.deepSleepHours} ชม., REM ${_sleepData.remSleepHours} ชม.) คุณภาพยอดเยี่ยม ${_sleepData.qualityScore}/100!\n\nสัตว์เลี้ยงได้รับ Energy เต็มหลอด 100% พร้อมลุยทั้งวันแล้วครับ!';
    } else if (lower.contains('เวท') ||
        lower.contains('ตาราง') ||
        lower.contains('push') ||
        lower.contains('บอส')) {
      return '💪 วันนี้ตาราง Push Day เตรียมพร้อมแล้ว! ปัจจุบัน Master Alex มีพลังโจมตี ATK ${_hero.atk} และเลเวล ${_hero.level} หากฝึกจบเซ็ตใน Live Tracker จะได้รับ ATK เพิ่มอีก +20 ไว้ถล่ม Lord Sloth ได้สบายครับ!';
    } else {
      return 'ยินดีให้คำปรึกษาครับ Master Alex! สายอาชีพ ${_hero.heroClass.nameTh} ของคุณกำลังเติบโตได้ดีมาก ร่างกายฟิตและสัตว์เลี้ยง ${_pet.name} แข็งแรงสมบูรณ์ ลุยเควสต์วันนี้ต่อได้เลยครับ! 🔥';
    }
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState notifier, required super.child})
    : super(notifier: notifier);

  static AppState of(BuildContext context) {
    final AppScope? scope = context
        .dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'No AppScope found in context');
    return scope!.notifier!;
  }
}
