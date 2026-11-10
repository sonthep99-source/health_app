import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class BossBattleScreen extends StatefulWidget {
  const BossBattleScreen({super.key});

  @override
  State<BossBattleScreen> createState() => _BossBattleScreenState();
}

class _BossBattleScreenState extends State<BossBattleScreen> {
  final List<String> _battleLogs = [
    '⚔️ เข้าสู่สมรภูมิ Boss ประจำสัปดาห์!',
    '💡 อัปพลังถาวรด้วยเหรียญเท่านั้น ข้อมูลสุขภาพไม่เปลี่ยนพลังต่อสู้',
  ];
  bool _isCoopMode = false;

  void _executeMove(AppState appState, String moveType) {
    final result = appState.attackBoss(moveType);
    setState(() {
      _battleLogs.insert(0, result);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final boss = appState.weeklyBoss;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Weekly Boss Battle (ศึกปราบจอมมาร)'),
        actions: [
          // Co-op mode toggle
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                Text(
                  _isCoopMode ? '👥 Co-op' : '👤 Solo',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _isCoopMode,
                  activeColor: AppTheme.cyan,
                  onChanged: (val) {
                    setState(() {
                      _isCoopMode = val;
                      _battleLogs.insert(
                        0,
                        val
                            ? '🤝 เปิดโหมด Co-op! กำลังแชร์พลังเวทกับเพื่อนร่วมกิลด์'
                            : '👤 กลับสู่โหมด Solo Battle',
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Boss Character Card
            GlassCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF31102A), Color(0xFF1E102E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: const Color(0xFFF43F5E).withOpacity(0.4), width: 1.5),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF43F5E).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'WEEKLY BOSS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF43F5E),
                          ),
                        ),
                      ),
                      Text(
                        'จุดอ่อน: ${boss.weakness}',
                        style: const TextStyle(fontSize: 11, color: AppTheme.amber),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Boss Emoji / Avatar
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.3),
                      border: Border.all(color: const Color(0xFFF43F5E), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF43F5E).withOpacity(0.35),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      boss.isDefeated ? '💀' : boss.emoji,
                      style: const TextStyle(fontSize: 44),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    boss.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    boss.title,
                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 14),

                  // Boss HP Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Boss HP', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                      Text(
                        '${boss.currentHp} / ${boss.maxHp}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: boss.isDefeated ? AppTheme.textMuted : const Color(0xFFF43F5E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: boss.hpPercent,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF43F5E)),
                      minHeight: 10,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.upgrade_rounded),
                label: const Text('อัปพลังต่อสู้ +10 • 100 เหรียญ'),
                onPressed: () {
                  final upgraded = appState.upgradeBattlePower();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(upgraded ? 'อัปเกรดสำเร็จ: ใช้ 100 เหรียญ' : 'เหรียญไม่พอ (ต้องใช้ 100 เหรียญ)'),
                  ));
                },
              ),
            ),

            const SizedBox(height: 16),

            GlassCard(
              padding: const EdgeInsets.all(14),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('พลังต่อสู้ถาวร', style: TextStyle(color: AppTheme.textSecondary)),
                Text('${appState.battlePower}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.amber)),
              ]),
            ),

            const SizedBox(height: 16),

            // Battle Commands / Skill Buttons
            Row(
              children: [
                // 1. Physical Strike
                Expanded(
                  child: _buildCommandButton(
                    title: 'โจมตี',
                    subtitle: 'ใช้พลังต่อสู้ถาวร',
                    icon: Icons.flash_on,
                    color: AppTheme.amber,
                    onTap: boss.isDefeated ? null : () => _executeMove(appState, 'physical'),
                  ),
                ),
                const SizedBox(width: 10),

                // 2. Strong attack; power comes from coin upgrades only.
                Expanded(
                  child: _buildCommandButton(
                    title: 'โจมตีหนัก',
                    subtitle: 'ความเสียหาย ×2',
                    icon: Icons.water_drop,
                    color: AppTheme.cyan,
                    onTap: boss.isDefeated ? null : () => _executeMove(appState, 'hydro'),
                  ),
                ),
                const SizedBox(width: 10),

                // 3. Restful Barrier (Sleep HP)
                Expanded(
                  child: _buildCommandButton(
                    title: 'ท่าไม้ตาย',
                    subtitle: 'ความเสียหาย ×3',
                    icon: Icons.shield,
                    color: AppTheme.mint,
                    onTap: boss.isDefeated ? null : () => _executeMove(appState, 'shield'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Battle Activity Log
            GlassCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.history_edu, size: 16, color: AppTheme.cyan),
                      SizedBox(width: 6),
                      Text(
                        'บันทึกการต่อสู้ (Battle Log)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...List.generate(
                    _battleLogs.take(5).length,
                    (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        _battleLogs[i],
                        style: TextStyle(
                          fontSize: 12,
                          color: i == 0 ? Colors.white : AppTheme.textSecondary,
                          fontWeight: i == 0 ? FontWeight.w600 : FontWeight.normal,
                          height: 1.3,
                        ),
                      ),
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

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildCommandButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.15),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: color.withOpacity(0.5), width: 1.2),
        ),
      ),
      onPressed: onTap,
      child: Column(
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(fontSize: 9.5, color: color.withOpacity(0.8)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

