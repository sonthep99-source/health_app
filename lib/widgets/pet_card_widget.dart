import 'package:flutter/material.dart';
import '../models/health_models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class PetCardWidget extends StatefulWidget {
  final VoidCallback? onOpenShop;

  const PetCardWidget({super.key, this.onOpenShop});

  @override
  State<PetCardWidget> createState() => _PetCardWidgetState();
}

class _PetCardWidgetState extends State<PetCardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _bounceAnimation;
  String? _feedbackText;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _showReaction(String text) {
    setState(() {
      _feedbackText = text;
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _feedbackText = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final pet = appState.pet;

    return GlassCard(
      gradient: LinearGradient(
        colors: [
          const Color(0xFF1E293B),
          appState.isPro ? const Color(0xFF2E1065) : const Color(0xFF0F2B48),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Name, Stage badge & Pro Tag
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.cyan.withOpacity(0.3), AppTheme.mint.withOpacity(0.2)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.cyan.withOpacity(0.4)),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Lv. ${pet.level}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.cyan,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          pet.stage.nameTh,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (pet.stage == PetEvolutionStage.mythicalPro) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'MYTHICAL PRO',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (pet.equippedAccessory != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    pet.equippedAccessory!,
                    style: const TextStyle(fontSize: 11, color: Colors.white),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          // Central Pet Interactive Area
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Animated Pet Avatar
              GestureDetector(
                onTap: () {
                  appState.petThePet();
                  _showReaction('💖 มีความสุขขึ้น! +10 XP');
                },
                child: AnimatedBuilder(
                  animation: _bounceAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _bounceAnimation.value),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          // Glow Halo
                          Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  (pet.stage == PetEvolutionStage.mythicalPro
                                          ? AppTheme.purple
                                          : AppTheme.cyan)
                                      .withOpacity(0.4),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          // Avatar Circle
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.surfaceLight.withOpacity(0.6),
                              border: Border.all(
                                color: (pet.stage == PetEvolutionStage.mythicalPro
                                        ? const Color(0xFFF472B6)
                                        : AppTheme.cyan)
                                    .withOpacity(0.7),
                                width: 2,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              pet.avatarVisual,
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                          // Reaction Pop-up
                          if (_feedbackText != null)
                            Positioned(
                              top: -24,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppTheme.mint),
                                ),
                                child: Text(
                                  _feedbackText!,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.mint,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 16),

              // Pet Vitals Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          pet.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          '${pet.xp}/${pet.maxXp} XP',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.cyan,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // XP Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: (pet.xp / pet.maxXp).clamp(0.0, 1.0),
                        backgroundColor: Colors.white.withOpacity(0.1),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.cyan),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Mood state based on Real Health metrics
                    Row(
                      children: [
                        const Icon(Icons.psychology_alt, size: 14, color: AppTheme.mint),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            pet.moodStatus,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Quick Gauges: Hydration (Water) & Energy (Sleep)
                    Row(
                      children: [
                        // Hydration
                        Expanded(
                          child: _buildMiniGauge(
                            label: 'ความสดชื่น',
                            value: pet.hydration,
                            color: AppTheme.cyan,
                            icon: '💧',
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Energy
                        Expanded(
                          child: _buildMiniGauge(
                            label: 'พลังงาน',
                            value: pet.energy,
                            color: AppTheme.amber,
                            icon: '⚡',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 10),

          // 1-Tap Interactivity Actions
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.favorite,
                  label: 'ลูบหัวเล่น (+XP)',
                  color: const Color(0xFFF43F5E),
                  onTap: () {
                    appState.petThePet();
                    _showReaction('💖 สัตว์เลี้ยงอารมณ์ดี!');
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.fastfood,
                  label: 'ให้อาหาร 🍎',
                  color: AppTheme.mint,
                  onTap: () {
                    appState.feedPet('pet_apple');
                    _showReaction('🍏 อิ่มอร่อย! พลังงานพุ่ง!');
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.storefront,
                  label: 'ร้านค้าแต่งตัว',
                  color: AppTheme.amber,
                  onTap: widget.onOpenShop,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniGauge({
    required String label,
    required double value,
    required Color color,
    required String icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$icon $label',
              style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
            ),
            Text(
              '${value.round()}%',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (value / 100).clamp(0.0, 1.0),
            backgroundColor: Colors.white.withOpacity(0.08),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

