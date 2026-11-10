import 'package:flutter/material.dart';
import '../models/health_models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class PremiumSubscriptionScreen extends StatelessWidget {
  const PremiumSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final isPro = appState.isPro;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('HABITA Pro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // Pro Crown Hero Banner
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFFC026D3), Color(0xFFF59E0B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withOpacity(0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text('👑', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 8),
                  const Text(
                    'HABITA PRO',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'ยกระดับการดูแลสุขภาพของคุณด้วยขุมพลัง AI และระบบ Gamification เต็มรูปแบบ',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.white, height: 1.4),
                  ),
                  const SizedBox(height: 16),

                  // Current Tier Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isPro ? '✨ สถานะปัจจุบัน: สมาชิก PRO (Active)' : 'สถานะปัจจุบัน: สมาชิกทั่วไป (Free Tier)',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Plan Comparison Table
            GlassCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'เปรียบเทียบสิทธิประโยชน์ (Plan Comparison)',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),

                  _buildFeatureRow(
                    feature: '1. AI Health Coach แชทให้คำปรึกษา',
                    freeText: '5 ข้อความ/วัน',
                    proText: 'ไม่จำกัด 24 ชม.',
                    isHighlight: true,
                  ),
                  _buildFeatureRow(
                    feature: '2. วิเคราะห์ตารางออกกำลัง & เมนูอาหาร',
                    freeText: 'พื้นฐานทั่วไป',
                    proText: 'วิเคราะห์เฉพาะบุคคล',
                  ),
                  _buildFeatureRow(
                    feature: '3. กราฟวิเคราะห์สุขภาพขั้นสูง & Auto-Sync',
                    freeText: 'ย้อนหลัง 7 วัน',
                    proText: 'ไม่จำกัด + ซิงค์สมาร์ทวอทช์',
                    isHighlight: true,
                  ),
                  _buildFeatureRow(
                    feature: '4. ร่างวิวัฒนาการสัตว์เลี้ยงพิเศษ',
                    freeText: 'Baby & Teen',
                    proText: '🐉 Mythical Dragon ร่างเทพ',
                    isHighlight: true,
                  ),
                  _buildFeatureRow(
                    feature: '5. สำรองข้อมูล Cloud Backup แบบเรียลไทม์',
                    freeText: 'บันทึกในเครื่อง',
                    proText: 'Cloud Sync อัตโนมัติ',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Instant Toggle / Switcher Button for Testing
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.cyan.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Text(
                    'สลับโหมดทดสอบ UX/UI (Demo Mode Toggle)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'คลิกเพื่อสลับระหว่าง Free Tier และ Pro Tier ทันที เพื่อดูผลการแสดงผลและฟังก์ชันที่แตกต่างกัน',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.5, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPro ? AppTheme.amber : AppTheme.purple,
                        foregroundColor: isPro ? Colors.black : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: Icon(isPro ? Icons.arrow_back : Icons.star_rounded),
                      label: Text(
                        isPro ? 'สลับกลับเป็น Free Tier' : 'เปิดใช้งาน PRO ทันที (คลิกเดียว)',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      onPressed: () {
                        appState.toggleSubscriptionTier();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              appState.isPro
                                  ? '🎉 ยินดีต้อนรับสู่ HealthQuest PRO! ปลดล็อกฟีเจอร์ทั้งหมดแล้ว'
                                  : 'สลับกลับสู่ Free Tier เรียบร้อย',
                            ),
                            backgroundColor: appState.isPro ? AppTheme.purple : const Color(0xFF1E293B),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow({
    required String feature,
    required String freeText,
    required String proText,
    bool isHighlight = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isHighlight ? AppTheme.purple.withOpacity(0.08) : Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlight ? AppTheme.purple.withOpacity(0.3) : Colors.white.withOpacity(0.04),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            feature,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Free: $freeText',
                  style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                ),
              ),
              Expanded(
                child: Text(
                  'Pro: $proText',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC084FC),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

