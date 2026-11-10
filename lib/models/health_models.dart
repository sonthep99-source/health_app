import 'package:flutter/material.dart';

/// แหล่งที่มาของข้อมูลสุขภาพ
enum HealthDataSource {
  appleHealth,
  googleFit,
  manualInput,
  aiEstimated,
}

extension HealthDataSourceExtension on HealthDataSource {
  String get label {
    switch (this) {
      case HealthDataSource.appleHealth:
        return 'Synced via Apple Health';
      case HealthDataSource.googleFit:
        return 'Synced via Google Fit';
      case HealthDataSource.manualInput:
        return 'Manual Input';
      case HealthDataSource.aiEstimated:
        return 'AI Vision Estimated';
    }
  }

  IconData get icon {
    switch (this) {
      case HealthDataSource.appleHealth:
      case HealthDataSource.googleFit:
        return Icons.watch_outlined;
      case HealthDataSource.manualInput:
        return Icons.touch_app_outlined;
      case HealthDataSource.aiEstimated:
        return Icons.auto_awesome;
    }
  }

  Color get color {
    switch (this) {
      case HealthDataSource.appleHealth:
        return const Color(0xFF06B6D4); // Cyan
      case HealthDataSource.googleFit:
        return const Color(0xFF38BDF8); // Sky blue
      case HealthDataSource.manualInput:
        return const Color(0xFFF59E0B); // Amber
      case HealthDataSource.aiEstimated:
        return const Color(0xFFA855F7); // Purple
    }
  }
}

/// ระดับสมาชิก
enum SubscriptionTier {
  free,
  pro,
}

// ============================================================================
// 1. DUAL-ENTITY: USER HERO & HERO CLASS
// ============================================================================

enum HeroClass {
  warrior, // นักรบเหล็กไหล: บัฟ ATK +20%, ได้รับ EXP จากการยกเวท
  paladin, // อัศวินผู้พิทักษ์: บัฟฟื้นฟู HP +25%, ได้รับ EXP จากการนอนหลับ
  rogue,   // จอมโจรสายพริ้ว: บัฟ Agility +20%, ได้รับ EXP จากก้าวเดิน
  mage,    // จอมเวทวารี: บัฟ MP +30%, ได้รับ EXP จากการดื่มน้ำและทานคลีน
}

extension HeroClassExtension on HeroClass {
  String get nameTh {
    switch (this) {
      case HeroClass.warrior:
        return 'นักรบเหล็กไหล (Iron Warrior)';
      case HeroClass.paladin:
        return 'อัศวินผู้พิทักษ์ (Holy Paladin)';
      case HeroClass.rogue:
        return 'จอมโจรสายพริ้ว (Shadow Rogue)';
      case HeroClass.mage:
        return 'จอมเวทวารี (Aqua Mage)';
    }
  }

  String get iconEmoji {
    switch (this) {
      case HeroClass.warrior:
        return '⚔️';
      case HeroClass.paladin:
        return '🛡️';
      case HeroClass.rogue:
        return '🗡️';
      case HeroClass.mage:
        return '🔮';
    }
  }

  String get perkDescription {
    switch (this) {
      case HeroClass.warrior:
        return 'พลังโจมตีบอส ATK +20% • โบนัส EXP จากเวทเทรนนิ่ง';
      case HeroClass.paladin:
        return 'อัตราฟื้นฟู HP +25% • โบนัสเหรียญจากการนอนหลับครบ 7 ชม.';
      case HeroClass.rogue:
        return 'โบนัสเผาผลาญ Active Burn +15% • ได้ EXP จากการเดิน';
      case HeroClass.mage:
        return 'ความจุพลังเวท MP +30% • เพิ่มความเร็วการวิเคราะห์ AI';
    }
  }
}

class UserHero {
  String id;
  String name;
  HeroClass heroClass;
  int level;
  int exp;
  int maxExp;
  int atk;
  int maxHp;
  int currentHp;
  int maxMp;
  int currentMp;

  UserHero({
    this.id = 'hero_master_1',
    this.name = 'Hero Alex',
    this.heroClass = HeroClass.warrior,
    this.level = 6,
    this.exp = 480,
    this.maxExp = 650,
    this.atk = 240,
    this.maxHp = 1000,
    this.currentHp = 880,
    this.maxMp = 100,
    this.currentMp = 85,
  });

  void gainExp(int amount) {
    exp += amount;
    while (exp >= maxExp) {
      exp -= maxExp;
      level++;
      atk += 25;
      maxHp += 80;
      currentHp = maxHp;
      maxExp = (maxExp * 1.3).round();
    }
  }

  double get expProgress => (exp / maxExp).clamp(0.0, 1.0);
  double get hpPercent => (currentHp / maxHp).clamp(0.0, 1.0);
  double get mpPercent => (currentMp / maxMp).clamp(0.0, 1.0);
}

// ============================================================================
// 2. DUAL-ENTITY: VIRTUAL PET COMPANION & PET TYPES
// ============================================================================

enum PetType {
  shibaInu,    // 🐕 Shiba Inu: บัฟก้าวเดิน & Active Burn +15%
  babyDragon,  // 🐉 Baby Dragon: บัฟพลังโจมตีบอส & Workout ATK +20%
  slime,       // 💧 Slime: บัฟการดื่มน้ำ & เติม MP +25%
  mochiCat,    // 🐱 Mochi Cat: บัฟการนอนหลับ & ฟื้นฟู Energy +20%
}

extension PetTypeExtension on PetType {
  String get nameTh {
    switch (this) {
      case PetType.shibaInu:
        return 'ชิบะอินุ (Shiba Inu)';
      case PetType.babyDragon:
        return 'มังกรเพลิงน้อย (Baby Dragon)';
      case PetType.slime:
        return 'สไลม์วารี (Aqua Slime)';
      case PetType.mochiCat:
        return 'แมวโมจิ (Mochi Cat)';
    }
  }

  String get emoji {
    switch (this) {
      case PetType.shibaInu:
        return '🐕';
      case PetType.babyDragon:
        return '🐲';
      case PetType.slime:
        return '💧';
      case PetType.mochiCat:
        return '🐱';
    }
  }

  String get specialtyBuff {
    switch (this) {
      case PetType.shibaInu:
        return '🐕 บัฟก้าวเดิน & Active Calories +15%';
      case PetType.babyDragon:
        return '🐉 บัฟพลังโจมตี Boss ATK +20%';
      case PetType.slime:
        return '💧 บัฟการดื่มน้ำ & เติม MP เร็วขึ้น +25%';
      case PetType.mochiCat:
        return '🐱 บัฟการนอนหลับ & ฟื้นฟู Energy เร็วขึ้น +20%';
    }
  }
}

enum PetEvolutionStage {
  baby,
  teen,
  adult,
  mythicalPro, // Pro Tier Only
}

extension PetEvolutionExtension on PetEvolutionStage {
  String get nameTh {
    switch (this) {
      case PetEvolutionStage.baby:
        return 'ร่างทารก (Baby Stage)';
      case PetEvolutionStage.teen:
        return 'ร่างวัยรุ่น (Teen Stage)';
      case PetEvolutionStage.adult:
        return 'ร่างผู้กล้า (Adult Guardian)';
      case PetEvolutionStage.mythicalPro:
        return 'ร่างเทพในตำนาน (Mythical Celestial)';
    }
  }

  int get requiredLevel {
    switch (this) {
      case PetEvolutionStage.baby:
        return 1;
      case PetEvolutionStage.teen:
        return 5;
      case PetEvolutionStage.adult:
        return 10;
      case PetEvolutionStage.mythicalPro:
        return 15;
    }
  }
}

class VirtualPet {
  String id;
  PetType petType;
  String name;
  int level;
  int xp;
  int maxXp;
  PetEvolutionStage stage;
  double hunger;    // 0 - 100: 100 = อิ่มแปล้, <30 = หิว
  double happiness; // 0 - 100: จากการลูบหัว & เล่น
  double energy;    // 0 - 100: ฟื้นฟูจากการนอนหลับจริงผ่าน Smartwatch
  String? equippedAccessory;

  VirtualPet({
    this.id = 'pet_main_1',
    this.petType = PetType.shibaInu,
    this.name = 'Kuro (คุโระ)',
    this.level = 5,
    this.xp = 380,
    this.maxXp = 550,
    this.stage = PetEvolutionStage.teen,
    this.hunger = 85.0,
    this.happiness = 92.0,
    this.energy = 88.0,
    this.equippedAccessory = '🕶️ Cool Shades',
  });

  String get nameTh => petType.nameTh;
  double get hydration => hunger;
  String get avatarVisual => visualEmoji;

  String get moodStatus {
    if (hunger < 30) return 'หิวข้าวมาก ท้องร้องจ๊อกๆ! 🍖';
    if (energy < 35) return 'ง่วงนอน เพลียสะสม ต้องการพักผ่อน 💤';
    if (happiness > 80 && hunger > 60 && energy > 60) {
      return 'ร่าเริงสุดๆ พร้อมลุยผจญภัย! ✨';
    }
    return 'สุขภาพดี แข็งแรงสมบูรณ์ 🌟';
  }

  String get visualEmoji {
    switch (petType) {
      case PetType.shibaInu:
        if (stage == PetEvolutionStage.mythicalPro) return '🦊✨';
        if (stage == PetEvolutionStage.adult) return '🐕‍🦺';
        if (stage == PetEvolutionStage.teen) return '🐕';
        return '🐶';
      case PetType.babyDragon:
        if (stage == PetEvolutionStage.mythicalPro) return '🐉🔥';
        if (stage == PetEvolutionStage.adult) return '🐲';
        if (stage == PetEvolutionStage.teen) return '🦎';
        return '🐣';
      case PetType.slime:
        if (stage == PetEvolutionStage.mythicalPro) return '🌊💎';
        if (stage == PetEvolutionStage.adult) return '💠';
        if (stage == PetEvolutionStage.teen) return '🫧';
        return '💧';
      case PetType.mochiCat:
        if (stage == PetEvolutionStage.mythicalPro) return '🦁👑';
        if (stage == PetEvolutionStage.adult) return '🐈‍⬛';
        if (stage == PetEvolutionStage.teen) return '🐈';
        return '🐱';
    }
  }

  void gainXp(int amount) {
    xp += amount;
    while (xp >= maxXp) {
      xp -= maxXp;
      level++;
      maxXp = (maxXp * 1.3).round();
      if (level >= 10 && stage == PetEvolutionStage.teen) {
        stage = PetEvolutionStage.adult;
      } else if (level >= 5 && stage == PetEvolutionStage.baby) {
        stage = PetEvolutionStage.teen;
      }
    }
  }
}

// ============================================================================
// 3. AI FOOD SCANNER & GAMIFIED NUTRITION
// ============================================================================

class DigitalFoodItem {
  final String id;
  final String name;
  final String emoji;
  final int calories;
  final double hungerRestore;
  final double happyBonus;
  final DateTime obtainedAt;

  const DigitalFoodItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.calories,
    required this.hungerRestore,
    required this.happyBonus,
    required this.obtainedAt,
  });
}

class FoodNutrition {
  final String id;
  final String foodName;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final double healthScore; // 0 - 10
  final String portion;
  final double confidence; // 0.0 - 1.0 (AI Vision Confidence)
  final String emoji;
  final DateTime timestamp;
  final HealthDataSource source;

  FoodNutrition({
    required this.id,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.healthScore,
    this.portion = '1 จาน (เสิร์ฟมาตรฐาน)',
    this.confidence = 0.96,
    required this.emoji,
    required this.timestamp,
    this.source = HealthDataSource.aiEstimated,
  });

  DigitalFoodItem toDigitalFood() {
    return DigitalFoodItem(
      id: 'df_$id',
      name: foodName,
      emoji: emoji,
      calories: calories,
      hungerRestore: (calories / 15.0).clamp(15.0, 50.0),
      happyBonus: healthScore * 2.5,
      obtainedAt: DateTime.now(),
    );
  }
}

// ============================================================================
// 4. SMARTWATCH SYNC & SLEEP DATA
// ============================================================================

class SleepData {
  final DateTime bedTime;
  final DateTime wakeTime;
  final double durationHours;
  final int qualityScore; // 0 - 100
  final double deepSleepHours;
  final double remSleepHours;
  final double lightSleepHours;
  final HealthDataSource source;

  SleepData({
    required this.bedTime,
    required this.wakeTime,
    required this.durationHours,
    required this.qualityScore,
    this.deepSleepHours = 2.1,
    this.remSleepHours = 1.8,
    this.lightSleepHours = 3.6,
    this.source = HealthDataSource.appleHealth,
  });
}

// Backward compatibility alias
typedef HealthSleepRecord = SleepData;

// ============================================================================
// 5. WORKOUT PLANNER & LIVE TRACKER
// ============================================================================

class WorkoutExerciseItem {
  final String id;
  final String name;
  final String muscleTarget;
  int targetSets;
  int completedSets;
  int reps;
  double weightKg;
  bool isCompleted;

  WorkoutExerciseItem({
    required this.id,
    required this.name,
    required this.muscleTarget,
    this.targetSets = 4,
    this.completedSets = 0,
    this.reps = 10,
    this.weightKg = 0,
    this.isCompleted = false,
  });
}

class WorkoutPlan {
  final String id;
  final String title;
  final String category; // Push, Pull, Legs, Cardio
  final List<WorkoutExerciseItem> exercises;
  final int targetDurationMinutes;
  final int estimatedCalories;
  bool isCompleted;
  final String dayOfWeek;

  WorkoutPlan({
    required this.id,
    required this.title,
    required this.category,
    required this.exercises,
    required this.targetDurationMinutes,
    required this.estimatedCalories,
    this.isCompleted = false,
    required this.dayOfWeek,
  });

  double get progress {
    if (exercises.isEmpty) return 0.0;
    int completed = exercises.where((e) => e.isCompleted).length;
    return completed / exercises.length;
  }
}

class WorkoutSession {
  final String id;
  final String title;
  final String category;
  final int durationMinutes;
  final int caloriesBurned;
  final DateTime timestamp;
  final HealthDataSource source;

  WorkoutSession({
    required this.id,
    required this.title,
    required this.category,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.timestamp,
    this.source = HealthDataSource.manualInput,
  });
}

// ============================================================================
// 6. HEALTH SHOP, AI CHAT & BOSS MODELS
// ============================================================================

enum ShopCategory {
  petItem,
  appCosmetic,
  utilityPerk,
}

class HealthShopItem {
  final String id;
  final String name;
  final String description;
  final int price;
  final ShopCategory category;
  final String iconEmoji;
  final bool isProOnly;
  final String effect;

  const HealthShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.iconEmoji,
    this.isProOnly = false,
    required this.effect,
  });
}

class HealthCoachMessage {
  final String id;
  final String sender; // 'user' or 'ai'
  final String text;
  final DateTime timestamp;
  final List<String>? contextBadges;

  HealthCoachMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.contextBadges,
  });
}

class BossEnemy {
  final String id;
  final String name;
  final String title;
  final String description;
  final int maxHp;
  int currentHp;
  final String emoji;
  final int rewardCoins;
  final int rewardXp;
  final String weakness;

  BossEnemy({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.maxHp,
    required this.currentHp,
    required this.emoji,
    required this.rewardCoins,
    required this.rewardXp,
    required this.weakness,
  });

  bool get isDefeated => currentHp <= 0;
  double get hpPercent => (currentHp / maxHp).clamp(0.0, 1.0);
}

class WaterEntry {
  final String id;
  final int amountMl;
  final DateTime timestamp;
  final HealthDataSource source;

  WaterEntry({
    required this.id,
    required this.amountMl,
    required this.timestamp,
    this.source = HealthDataSource.manualInput,
  });
}
