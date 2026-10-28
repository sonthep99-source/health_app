import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Subscription Paywall Modal
// ---------------------------------------------------------------------------

void showSubscriptionModal({
  required BuildContext context,
  required bool isSubscribed,
  required void Function(bool newStatus) onToggleSubscription,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _SubscriptionModalContent(
      isSubscribed: isSubscribed,
      onToggleSubscription: onToggleSubscription,
    ),
  );
}

class _SubscriptionModalContent extends StatefulWidget {
  final bool isSubscribed;
  final void Function(bool newStatus) onToggleSubscription;

  const _SubscriptionModalContent({
    required this.isSubscribed,
    required this.onToggleSubscription,
  });

  @override
  State<_SubscriptionModalContent> createState() => _SubscriptionModalContentState();
}

class _SubscriptionModalContentState extends State<_SubscriptionModalContent> {
  int _selectedPlanIndex = 0; // 0: Annual (Best value), 1: Monthly

  @override
  Widget build(BuildContext context) {
    final isSubbed = widget.isSubscribed;

    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
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

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              children: [
                // Top VIP Crown Badge
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF59E0B), Color(0xFFFCD34D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 40),
                  ),
                ),
                const SizedBox(height: 14),

                // Title & Subtitle
                const Text(
                  'Health Pro VIP Subscription',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'ซับสไครบ์เพื่อปลดล็อกบทวิเคราะห์สุขภาพเชิงลึก และคำแนะนำเฉพาะบุคคลจาก AI Health Advisor',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // Features list
                _buildFeatureRow(
                  icon: Icons.analytics_rounded,
                  color: const Color(0xFF0284C7),
                  title: 'บทวิเคราะห์สุขภาพเชิงลึก (Deep Analytics)',
                  desc: 'กราฟแนวโน้มสมดุลร่างกาย อัตราการดูดซึมน้ำ และระยะหลับลึก (Deep Sleep/REM)',
                ),
                const SizedBox(height: 14),
                _buildFeatureRow(
                  icon: Icons.psychology_rounded,
                  color: const Color(0xFF8B5CF6),
                  title: 'AI Health Coach ประจำตัว',
                  desc: 'ประเมินความพร้อมของร่างกาย แนะนำตารางฝึก และโภชนาการแบบเฉพาะตัว',
                ),
                const SizedBox(height: 14),
                _buildFeatureRow(
                  icon: Icons.bolt_rounded,
                  color: const Color(0xFFF59E0B),
                  title: 'โบนัส EXP x1.5 & VIP Diamond Badge',
                  desc: 'รับค่าประสบการณ์เพิ่ม 50% ทุกเควส พร้อมกรอบรูปโปรไฟล์ระดับ VIP',
                ),
                const SizedBox(height: 14),
                _buildFeatureRow(
                  icon: Icons.picture_as_pdf_rounded,
                  color: const Color(0xFF10B981),
                  title: 'ส่งออกรายงานสุขภาพสำหรับแพทย์หรือเทรนเนอร์',
                  desc: 'สรุปรายงานสุขภาพรายสัปดาห์/รายเดือนได้อย่างเป็นทางการ',
                ),

                const SizedBox(height: 24),

                // Pricing Plans
                if (!isSubbed) ...[
                  const Text(
                    'เลือกแผนที่เหมาะกับคุณ:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 12),

                  // Plan 1: Annual
                  InkWell(
                    onTap: () => setState(() => _selectedPlanIndex = 0),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _selectedPlanIndex == 0 ? const Color(0xFFFEF3C7) : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: _selectedPlanIndex == 0 ? const Color(0xFFF59E0B) : const Color(0xFFE2E8F0),
                          width: _selectedPlanIndex == 0 ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _selectedPlanIndex == 0
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_unchecked_rounded,
                            color: _selectedPlanIndex == 0 ? const Color(0xFFF59E0B) : const Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'รายปี (Annual Plan)',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      '🔥 ประหยัด 45%',
                                      style: TextStyle(fontSize: 11, color: Color(0xFFD97706), fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Text(
                                  'เพียง ฿82.5 / เดือน (ชำระรายปี ฿990)',
                                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            '฿990',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Plan 2: Monthly
                  InkWell(
                    onTap: () => setState(() => _selectedPlanIndex = 1),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _selectedPlanIndex == 1 ? const Color(0xFFFEF3C7) : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: _selectedPlanIndex == 1 ? const Color(0xFFF59E0B) : const Color(0xFFE2E8F0),
                          width: _selectedPlanIndex == 1 ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _selectedPlanIndex == 1
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_unchecked_rounded,
                            color: _selectedPlanIndex == 1 ? const Color(0xFFF59E0B) : const Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'รายเดือน (Monthly Plan)',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                                ),
                                Text(
                                  'ชำระเป็นรายเดือน ยกเลิกได้ตลอดเวลา',
                                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            '฿149',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  // Current Active Subscription Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF86EFAC)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 28),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'คุณเป็นสมาชิก Health Pro VIP แล้ว',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF065F46)),
                              ),
                              Text(
                                'สิทธิพิเศษและบทวิเคราะห์สุขภาพเชิงลึกทั้งหมดถูกปลดล็อกเรียบร้อย',
                                style: TextStyle(fontSize: 12, color: Color(0xFF047857)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),

          // CTA Action Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: SizedBox(
              width: double.infinity,
              child: isSubbed
                  ? OutlinedButton(
                      onPressed: () {
                        widget.onToggleSubscription(false);
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFEF4444),
                        side: const BorderSide(color: Color(0xFFFCA5A5)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('ยกเลิกการซับสไครบ์ (Demo Mode)', style: TextStyle(fontWeight: FontWeight.bold)),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        widget.onToggleSubscription(true);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.workspace_premium_rounded, color: Color(0xFFF59E0B), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'ซับสไครบ์ Health Pro (ทดลองฟรี 7 วัน)',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow({
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
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Health Insights Widget (Shown on Dashboard or Insights Hub)
// ---------------------------------------------------------------------------

class HealthInsightsWidget extends StatelessWidget {
  final bool isSubscribed;
  final VoidCallback onOpenSubscription;

  const HealthInsightsWidget({
    super.key,
    required this.isSubscribed,
    required this.onOpenSubscription,
  });

  @override
  Widget build(BuildContext context) {
    if (!isSubscribed) {
      // Locked Teaser Card
      return Container(
        margin: const EdgeInsets.only(top: 8, bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x330F172A),
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0x33F59E0B),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0x66F59E0B)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.workspace_premium_rounded, color: Color(0xFFF59E0B), size: 14),
                      SizedBox(width: 4),
                      Text(
                        'PRO INSIGHTS',
                        style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const Icon(Icons.lock_rounded, color: Colors.white54, size: 18),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'บทวิเคราะห์สุขภาพเชิงลึก (Health Insights)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'ซับสไครบ์เพื่อดูดัชนีฟื้นฟูร่างกาย สัดส่วนระยะหลับลึก (Deep Sleep) อัตราการดูดซึมน้ำ และคำแนะนำจาก AI Health Coach',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 12,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onOpenSubscription,
                icon: const Icon(Icons.stars_rounded, color: Color(0xFF0F172A), size: 18),
                label: const Text('ปลดล็อกบทวิเคราะห์เชิงลึก (ซับสไครบ์)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: const Color(0xFF0F172A),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Unlocked Full Deep Analytics
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 14,
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'PRO MEMBER',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'บทวิเคราะห์สุขภาพเชิงลึก',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Color(0xFF64748B), size: 20),
                onPressed: onOpenSubscription,
                tooltip: 'จัดการ Subscription',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Metric 1: Readiness & Muscle Recovery Index
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const SizedBox(
                      width: 54,
                      height: 54,
                      child: CircularProgressIndicator(
                        value: 0.94,
                        strokeWidth: 6,
                        backgroundColor: Color(0xFFBFDBFE),
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0284C7)),
                      ),
                    ),
                    Text(
                      '94%',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF0369A1)),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ความพร้อมและการฟื้นฟู (Readiness Score)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E3A8A)),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'กล้ามเนื้อฟื้นตัว 94% หัวใจอยู่ในเกณฑ์ยอดเยี่ยม พร้อมลุยภารกิจฝึกหนักวันนี้!',
                        style: TextStyle(fontSize: 11, color: Color(0xFF2563EB)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Metric 2: Deep Sleep Architecture
          const Text(
            'สัดส่วนการนอนหลับเชิงลึก (Sleep Architecture)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                Expanded(
                  flex: 28,
                  child: Container(
                    height: 12,
                    color: const Color(0xFF4338CA), // Deep Sleep
                  ),
                ),
                Expanded(
                  flex: 22,
                  child: Container(
                    height: 12,
                    color: const Color(0xFF6366F1), // REM Sleep
                  ),
                ),
                Expanded(
                  flex: 50,
                  child: Container(
                    height: 12,
                    color: const Color(0xFFA5B4FC), // Light Sleep
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SleepStageLegend(color: Color(0xFF4338CA), label: 'หลับลึก 28% (2.2 ชม.)'),
              _SleepStageLegend(color: Color(0xFF6366F1), label: 'REM 22% (1.8 ชม.)'),
              _SleepStageLegend(color: Color(0xFFA5B4FC), label: 'หลับตื้น 50%'),
            ],
          ),

          const SizedBox(height: 16),

          // Metric 3: AI Health Coach Insight Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF5FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE9D5FF)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.smart_toy_rounded, color: Color(0xFF9333EA), size: 22),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Health Coach สรุปประจำวัน:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF6B21A8)),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'การดื่มน้ำและนอนหลับอยู่ในระดับสมดุลยอดเยี่ยม แนะนำให้ดื่มน้ำ 1 แก้วก่อนออกกำลังกาย และเลือกภารกิจ Push หรือ Core วันนี้เพื่อผลลัพธ์สูงสุด!',
                        style: TextStyle(fontSize: 11, color: Color(0xFF581C87), height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SleepStageLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _SleepStageLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
      ],
    );
  }
}
