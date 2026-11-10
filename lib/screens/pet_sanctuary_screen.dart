import 'package:flutter/material.dart';
import '../models/health_models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import 'coin_shop_screen.dart';

class PetSanctuaryScreen extends StatefulWidget {
  const PetSanctuaryScreen({super.key});

  @override
  State<PetSanctuaryScreen> createState() => _PetSanctuaryScreenState();
}

class _PetSanctuaryScreenState extends State<PetSanctuaryScreen> with SingleTickerProviderStateMixin {
  late AnimationController _petAnimController;
  late Animation<double> _bounceAnimation;
  String? _petReaction;

  @override
  void initState() {
    super.initState();
    _petAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _petAnimController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _petAnimController.dispose();
    super.dispose();
  }

  void _triggerReaction(String text) {
    setState(() => _petReaction = text);
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) setState(() => _petReaction = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final pet = appState.pet;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('🐾', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text('${pet.name} Sanctuary'),
          ],
        ),
        actions: [
          // Switch Pet Companion Button
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: AppTheme.cyan),
            icon: const Icon(Icons.swap_horiz, size: 18),
            label: const Text('สลับสัตว์เลี้ยง', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            onPressed: () => _showPetSelectionModal(context, appState),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Interactive Pet Room Sanctuary Canvas
            _buildSanctuaryRoomCanvas(context, appState, pet),

            const SizedBox(height: 16),

            // Care Mechanics Action Strip (Feed, Pet, Dress-up, Shop)
            _buildCareActionsRow(context, appState),

            const SizedBox(height: 16),

            // Pet Vitals Gauges (Hunger, Happiness, Energy)
            _buildVitalsCard(context, pet),

            const SizedBox(height: 16),

            // Evolution Roadmap Card
            _buildEvolutionCard(context, pet, appState.isPro),
          ],
        ),
      ),
    );
  }

  // Interactive Pet Room Canvas
  Widget _buildSanctuaryRoomCanvas(BuildContext context, AppState appState, VirtualPet pet) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E293B),
            appState.isPro ? const Color(0xFF3B0764) : const Color(0xFF0C4A6E),
            const Color(0xFF0F172A),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: AppTheme.cyan.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.cyan.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Decor (Sanctuary Room Elements)
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: Text(
                'Lv. ${pet.level} • ${pet.stage.nameTh}',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.mint.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.mint),
              ),
              child: Text(
                pet.petType.specialtyBuff,
                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppTheme.mint),
              ),
            ),
          ),

          // Central Pet Avatar with Interactive Tap
          GestureDetector(
            onTap: () {
              appState.petThePet();
              _triggerReaction('💖 มีความสุขขึ้น! +12 XP');
            },
            child: AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, _) {
                return Transform.translate(
                  offset: Offset(0, _bounceAnimation.value),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      // Glow Aura
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              (pet.stage == PetEvolutionStage.mythicalPro ? AppTheme.purple : AppTheme.cyan)
                                  .withOpacity(0.35),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      // Pet Face Circle
                      Container(
                        width: 104,
                        height: 104,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.surfaceLight.withOpacity(0.7),
                          border: Border.all(
                            color: pet.stage == PetEvolutionStage.mythicalPro
                                ? const Color(0xFFF472B6)
                                : AppTheme.cyan,
                            width: 2.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          pet.visualEmoji,
                          style: const TextStyle(fontSize: 54),
                        ),
                      ),
                      // Reaction Bubble Pop-up
                      if (_petReaction != null)
                        Positioned(
                          top: -30,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFF43F5E)),
                            ),
                            child: Text(
                              _petReaction!,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Pet Name & Status Bottom Strip
          Positioned(
            bottom: 16,
            child: Column(
              children: [
                Text(
                  pet.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  pet.moodStatus,
                  style: const TextStyle(fontSize: 11.5, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Care Mechanics Action Row
  Widget _buildCareActionsRow(BuildContext context, AppState appState) {
    return Row(
      children: [
        // 1. Feed Digital Food
        Expanded(
          child: _buildCareButton(
            icon: Icons.fastfood,
            label: 'ป้อนอาหาร (${appState.digitalPantry.length})',
            color: AppTheme.amber,
            onTap: () => _showDigitalPantryModal(context, appState),
          ),
        ),
        const SizedBox(width: 8),

        // 2. Pet Head
        Expanded(
          child: _buildCareButton(
            icon: Icons.favorite,
            label: 'ลูบหัวเล่น 💖',
            color: const Color(0xFFF43F5E),
            onTap: () {
              appState.petThePet();
              _triggerReaction('💖 สัตว์เลี้ยงอารมณ์ดี!');
            },
          ),
        ),
        const SizedBox(width: 8),

        // 3. Shop & Dress up
        Expanded(
          child: _buildCareButton(
            icon: Icons.storefront,
            label: 'ร้านค้าแต่งตัว',
            color: AppTheme.cyan,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CoinShopScreen()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCareButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.15),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: color.withOpacity(0.5), width: 1.2),
        ),
      ),
      onPressed: onTap,
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  // Pet Vitals Gauges
  Widget _buildVitalsCard(BuildContext context, VirtualPet pet) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('ค่าสถานะสัตว์เลี้ยง (Pet Vitals)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
              Text('${pet.xp}/${pet.maxXp} XP', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.cyan)),
            ],
          ),
          const SizedBox(height: 12),
          _buildVitalBar(label: '🍖 ความอิ่ม (Hunger)', percent: pet.hunger / 100, color: AppTheme.amber, valueStr: '${pet.hunger.round()}%'),
          const SizedBox(height: 10),
          _buildVitalBar(label: '💖 ความสุข (Happiness)', percent: pet.happiness / 100, color: const Color(0xFFF43F5E), valueStr: '${pet.happiness.round()}%'),
          const SizedBox(height: 10),
          _buildVitalBar(label: '⚡ พลังงาน (Energy - จากการนอนจริง)', percent: pet.energy / 100, color: AppTheme.cyan, valueStr: '${pet.energy.round()}%'),
        ],
      ),
    );
  }

  Widget _buildVitalBar({required String label, required double percent, required Color color, required String valueStr}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
            Text(valueStr, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent.clamp(0.0, 1.0),
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 5,
          ),
        ),
      ],
    );
  }

  // Evolution Roadmap
  Widget _buildEvolutionCard(BuildContext context, VirtualPet pet, bool isPro) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('เส้นทางวิวัฒนาการ (Evolution Stages)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildEvolutionNode('Baby', 'Lv. 1', '🐣', pet.level >= 1),
              const Icon(Icons.arrow_forward, size: 14, color: Colors.white24),
              _buildEvolutionNode('Teen', 'Lv. 5', '🦊', pet.level >= 5),
              const Icon(Icons.arrow_forward, size: 14, color: Colors.white24),
              _buildEvolutionNode('Adult', 'Lv. 10', '🦁', pet.level >= 10),
              const Icon(Icons.arrow_forward, size: 14, color: Colors.white24),
              _buildEvolutionNode('Mythical', 'Pro Tier', '🐉', isPro),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEvolutionNode(String title, String level, String emoji, bool isUnlocked) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isUnlocked ? AppTheme.cyan.withOpacity(0.2) : Colors.white10,
            border: Border.all(color: isUnlocked ? AppTheme.cyan : Colors.white24),
          ),
          alignment: Alignment.center,
          child: Text(emoji, style: TextStyle(fontSize: 20, color: isUnlocked ? Colors.white : Colors.white38)),
        ),
        const SizedBox(height: 4),
        Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isUnlocked ? Colors.white : AppTheme.textMuted)),
        Text(level, style: const TextStyle(fontSize: 9, color: AppTheme.textMuted)),
      ],
    );
  }

  // Cute Pet Selection Modal (Shiba Inu, Baby Dragon, Slime, Mochi Cat)
  void _showPetSelectionModal(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text('🐾', style: TextStyle(fontSize: 22)),
                  SizedBox(width: 8),
                  Text('เลือกสัตว์เลี้ยงคู่หู (Pet Selection)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              const SizedBox(height: 4),
              const Text('สัตว์เลี้ยงแต่ละตัวจะให้บัฟสุขภาพที่แตกต่างกันตามไลฟ์สไตล์ของคุณ:', style: TextStyle(fontSize: 11.5, color: AppTheme.textSecondary)),
              const SizedBox(height: 14),
              ...appState.availablePets.map((p) {
                final isSelected = appState.pet.petType == p.petType;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.cyan.withOpacity(0.15) : Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isSelected ? AppTheme.cyan : Colors.white12, width: 1.2),
                  ),
                  child: ListTile(
                    leading: Text(p.visualEmoji, style: const TextStyle(fontSize: 28)),
                    title: Text(p.nameTh, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                    subtitle: Text(p.petType.specialtyBuff, style: const TextStyle(fontSize: 11, color: AppTheme.mint)),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: AppTheme.cyan)
                        : TextButton(
                            onPressed: () {
                              appState.selectCompanionPet(p.petType);
                              Navigator.pop(ctx);
                              _triggerReaction('✨ เปลี่ยนคู่หูเป็น ${p.name} สำเร็จ!');
                            },
                            child: const Text('เลือกคู่หู', style: TextStyle(fontSize: 11, color: AppTheme.cyan)),
                          ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // Digital Food Pantry Modal (Feed Pet from AI Scans)
  void _showDigitalPantryModal(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        final pantry = appState.digitalPantry;
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text('🍱', style: TextStyle(fontSize: 22)),
                  SizedBox(width: 8),
                  Text('กระเป๋าอาหารดิจิทัล (Digital Pantry)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              const SizedBox(height: 4),
              const Text('อาหารที่ได้จากการถ่ายรูปสแกน AI จะถูกแปลงมาเป็นอาหารให้สัตว์เลี้ยงที่นี่:', style: TextStyle(fontSize: 11.5, color: AppTheme.textSecondary)),
              const SizedBox(height: 12),
              if (pantry.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text('กระเป๋าว่างเปล่า! ไปที่แท็บ "Food AI" เพื่อถ่ายรูปอาหารสะสมอาหารกันเถอะ', style: TextStyle(fontSize: 12, color: AppTheme.textMuted), textAlign: TextAlign.center),
                  ),
                )
              else
                ...pantry.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.amber.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(item.emoji, style: const TextStyle(fontSize: 24)),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                                Text('ฟื้นฟูความอิ่ม +${item.hungerRestore.round()}% • ความสุข +${item.happyBonus.round()}%', style: const TextStyle(fontSize: 10.5, color: AppTheme.mint)),
                              ],
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.amber, foregroundColor: Colors.black, minimumSize: const Size(60, 30)),
                          onPressed: () {
                            appState.feedPetDigitalFood(item);
                            Navigator.pop(ctx);
                            _triggerReaction('🍏 อิ่มอร่อย! สัตว์เลี้ยงเติบโตขึ้น!');
                          },
                          child: const Text('ป้อน', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}

