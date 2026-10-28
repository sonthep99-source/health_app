import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Gamification Data Models
// ---------------------------------------------------------------------------

class QuestItem {
  final String id;
  final String title;
  final String description;
  final int expReward;
  final int coinReward;
  final String category; // 'water', 'sleep', 'workout', 'habit'
  final IconData icon;
  final Color color;
  int currentProgress;
  final int targetProgress;
  final String unit;
  bool isClaimed;
  final int targetTabIndex; // Index to navigate to if user taps "Go"

  QuestItem({
    required this.id,
    required this.title,
    required this.description,
    required this.expReward,
    required this.coinReward,
    required this.category,
    required this.icon,
    required this.color,
    required this.currentProgress,
    required this.targetProgress,
    required this.unit,
    this.isClaimed = false,
    required this.targetTabIndex,
  });

  bool get isCompleted => currentProgress >= targetProgress;
  double get progressPercent => (currentProgress / targetProgress).clamp(0.0, 1.0);
}

class LeaderboardUser {
  final int rank;
  final String name;
  final String avatarInitials;
  final Color avatarColor;
  final int level;
  final int exp;
  final int streakDays;
  final String tier;
  final bool isCurrentUser;

  LeaderboardUser({
    required this.rank,
    required this.name,
    required this.avatarInitials,
    required this.avatarColor,
    required this.level,
    required this.exp,
    required this.streakDays,
    required this.tier,
    this.isCurrentUser = false,
  });
}

class HealthBadge {
  final String id;
  final String title;
  final String desc;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final String unlockedDate;

  HealthBadge({
    required this.id,
    required this.title,
    required this.desc,
    required this.icon,
    required this.color,
    required this.isUnlocked,
    this.unlockedDate = '',
  });
}

// ---------------------------------------------------------------------------
// Quest & Leaderboard Screen
// ---------------------------------------------------------------------------

class QuestRankingScreen extends StatefulWidget {
  final int userLevel;
  final int userExp;
  final int userExpMax;
  final int userCoins;
  final int userStreak;
  final List<QuestItem> quests;
  final List<LeaderboardUser> leaderboard;
  final List<HealthBadge> badges;
  final void Function(QuestItem quest) onClaimQuest;
  final void Function(int tabIndex) onNavigateToTab;

  const QuestRankingScreen({
    super.key,
    required this.userLevel,
    required this.userExp,
    required this.userExpMax,
    required this.userCoins,
    required this.userStreak,
    required this.quests,
    required this.leaderboard,
    required this.badges,
    required this.onClaimQuest,
    required this.onNavigateToTab,
  });

  @override
  State<QuestRankingScreen> createState() => _QuestRankingScreenState();
}

class _QuestRankingScreenState extends State<QuestRankingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Gamification Profile Card
        _buildTopProfileCard(),

        // Segment Tab Bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            labelColor: const Color(0xFF0F172A),
            unselectedLabelColor: const Color(0xFF64748B),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flag_rounded, size: 16),
                    SizedBox(width: 6),
                    Text('เควส & ภารกิจ'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.emoji_events_rounded, size: 16),
                    SizedBox(width: 6),
                    Text('ตารางอันดับ'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.military_tech_rounded, size: 16),
                    SizedBox(width: 6),
                    Text('เหรียญตรา'),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildQuestsView(),
              _buildLeaderboardView(),
              _buildBadgesView(),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Top User Level & Stats Card
  // ---------------------------------------------------------------------------

  Widget _buildTopProfileCard() {
    final expPercent = (widget.userExp / widget.userExpMax).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF334155)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x330F172A),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar with Level Ring
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF59E0B), Color(0xFFFCD34D)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF0F172A),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.person_rounded, color: Colors.white, size: 32),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF0F172A), width: 1.5),
                    ),
                    child: Text(
                      'LV.${widget.userLevel}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              // Name, Title & Tier
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'คุณ (ผู้ใช้)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF38BDF8).withValues(alpha: 0.4),
                            ),
                          ),
                          child: const Text(
                            'Gold Tier',
                            style: TextStyle(
                              color: Color(0xFF38BDF8),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'ฉายา: ยอดนักรบสุขภาพ (Health Warrior)',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // EXP Progress Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.bolt_rounded, color: Color(0xFFF59E0B), size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'EXP: ${widget.userExp} / ${widget.userExpMax}',
                    style: const TextStyle(
                      color: Color(0xFFCBD5E1),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                '${(expPercent * 100).toInt()}%',
                style: const TextStyle(
                  color: Color(0xFFF59E0B),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: expPercent,
              minHeight: 8,
              backgroundColor: const Color(0x33FFFFFF),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
            ),
          ),

          const SizedBox(height: 14),

          // Mini Stats (Streak & Coins)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0x1AFFFFFF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMiniStat(
                  icon: Icons.local_fire_department_rounded,
                  color: const Color(0xFFEF4444),
                  label: 'สตรีคต่อเนื่อง',
                  value: '${widget.userStreak} วันติด 🔥',
                ),
                Container(width: 1, height: 24, color: Colors.white24),
                _buildMiniStat(
                  icon: Icons.monetization_on_rounded,
                  color: const Color(0xFFFBBF24),
                  label: 'เหรียญสุขภาพ',
                  value: '${widget.userCoins} 🪙',
                ),
                Container(width: 1, height: 24, color: Colors.white24),
                _buildMiniStat(
                  icon: Icons.leaderboard_rounded,
                  color: const Color(0xFF38BDF8),
                  label: 'อันดับลีก',
                  value: '#4 ลีกทอง 🏆',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 1: QUESTS & MISSIONS VIEW
  // ---------------------------------------------------------------------------

  Widget _buildQuestsView() {
    final completedCount = widget.quests.where((q) => q.isCompleted).length;
    final totalCount = widget.quests.length;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      children: [
        // Summary Header Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0284C7).withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.stars_rounded, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ภารกิจประจำวัน (Daily Quests)',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ทำสำเร็จแล้ว $completedCount จาก $totalCount ภารกิจ',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: totalCount > 0 ? (completedCount / totalCount) : 0,
                        minHeight: 6,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF34D399)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),
        const Text(
          'รายการเควสวันนี้',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),

        // List of Quest Cards
        ...widget.quests.map((quest) => _buildQuestCard(quest)),

        const SizedBox(height: 16),

        // Weekly Challenge Banner
        _buildWeeklyChallengeBanner(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildQuestCard(QuestItem quest) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: quest.isCompleted && !quest.isClaimed
              ? const Color(0xFF10B981)
              : const Color(0xFFE2E8F0),
          width: quest.isCompleted && !quest.isClaimed ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: quest.isCompleted && !quest.isClaimed
                ? const Color(0xFF10B981).withValues(alpha: 0.1)
                : const Color(0x08000000),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Badge
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: quest.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(quest.icon, color: quest.color, size: 24),
              ),
              const SizedBox(width: 12),

              // Title & Desc
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quest.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: quest.isClaimed ? const Color(0xFF94A3B8) : const Color(0xFF0F172A),
                        decoration: quest.isClaimed ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      quest.description,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),

              // Rewards
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bolt_rounded, color: Color(0xFFD97706), size: 14),
                        Text(
                          '+${quest.expReward} EXP',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '+${quest.coinReward} 🪙',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD97706),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Progress Bar & Numbers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ความคืบหน้า: ${quest.currentProgress} / ${quest.targetProgress} ${quest.unit}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
              Text(
                '${(quest.progressPercent * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: quest.isCompleted ? const Color(0xFF10B981) : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: quest.progressPercent,
              minHeight: 7,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(
                quest.isCompleted ? const Color(0xFF10B981) : quest.color,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: _buildQuestActionButton(quest),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestActionButton(QuestItem quest) {
    if (quest.isClaimed) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 16),
            SizedBox(width: 6),
            Text(
              'รับรางวัลเรียบร้อยแล้ว',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    if (quest.isCompleted) {
      return ElevatedButton.icon(
        onPressed: () => widget.onClaimQuest(quest),
        icon: const Icon(Icons.card_giftcard_rounded, size: 16),
        label: const Text('กดรับรางวัล (+EXP & เหรียญ)'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF10B981),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: () => widget.onNavigateToTab(quest.targetTabIndex),
      icon: const Icon(Icons.arrow_forward_rounded, size: 16),
      label: const Text('ไปทำภารกิจนี้เลย'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF0284C7),
        side: const BorderSide(color: Color(0xFFBAE6FD)),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildWeeklyChallengeBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.military_tech_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'เควสพิเศษประจำสัปดาห์ 🔥',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'ออกกำลังกายครบ 4 วันในสัปดาห์นี้ เพื่อรับ +200 EXP และฉายา "Iron Body"',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 2: LEADERBOARD VIEW
  // ---------------------------------------------------------------------------

  Widget _buildLeaderboardView() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      children: [
        // Top 3 Podium
        _buildPodium(),
        const SizedBox(height: 20),

        // User Standings Card
        _buildUserStandingCard(),
        const SizedBox(height: 16),

        const Text(
          'อันดับนักรบสุขภาพประจำสัปดาห์',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),

        // Ranks 4 to N
        ...widget.leaderboard.map((user) => _buildLeaderboardRow(user)),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPodium() {
    if (widget.leaderboard.length < 3) return const SizedBox();

    final first = widget.leaderboard[0];
    final second = widget.leaderboard[1];
    final third = widget.leaderboard[2];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '🏆 3 อันดับผู้นำสูงสุด (Top 3 Champions)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 2nd Place
              _buildPodiumColumn(
                user: second,
                medalColor: const Color(0xFF94A3B8),
                podiumHeight: 70,
                podiumRank: '🥈 2',
                avatarSize: 50,
              ),

              // 1st Place (Center & Highest)
              _buildPodiumColumn(
                user: first,
                medalColor: const Color(0xFFF59E0B),
                podiumHeight: 96,
                podiumRank: '👑 1',
                avatarSize: 62,
                isCrown: true,
              ),

              // 3rd Place
              _buildPodiumColumn(
                user: third,
                medalColor: const Color(0xFFB45309),
                podiumHeight: 56,
                podiumRank: '🥉 3',
                avatarSize: 46,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumColumn({
    required LeaderboardUser user,
    required Color medalColor,
    required double podiumHeight,
    required String podiumRank,
    required double avatarSize,
    bool isCrown = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isCrown)
          const Text('👑', style: TextStyle(fontSize: 22))
        else
          const SizedBox(height: 22),
        CircleAvatar(
          radius: avatarSize / 2,
          backgroundColor: user.avatarColor,
          child: Text(
            user.avatarInitials,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: avatarSize * 0.38,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
        ),
        Text(
          '${user.exp} EXP',
          style: TextStyle(fontSize: 11, color: medalColor, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Podium Block
        Container(
          width: 76,
          height: podiumHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [medalColor.withValues(alpha: 0.25), medalColor.withValues(alpha: 0.1)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border.all(color: medalColor.withValues(alpha: 0.4)),
          ),
          child: Text(
            podiumRank,
            style: TextStyle(
              color: medalColor,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserStandingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF93C5FD)),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFF0284C7),
            child: Icon(Icons.star_rounded, color: Colors.white, size: 24),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'คุณอยู่อันดับที่ #4 ในลีก Gold!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'สะสมอีกเพียง 80 EXP เพื่อแซงขึ้นสู่อันดับ 3 และรับเหรียญทองแดง 🥉',
                  style: TextStyle(fontSize: 12, color: Color(0xFF3B82F6)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardRow(LeaderboardUser user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: user.isCurrentUser ? const Color(0xFFF0FDF4) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: user.isCurrentUser ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
          width: user.isCurrentUser ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Rank Badge
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: user.isCurrentUser ? const Color(0xFF10B981) : const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Text(
              '#${user.rank}',
              style: TextStyle(
                color: user.isCurrentUser ? Colors.white : const Color(0xFF475569),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: user.avatarColor,
            child: Text(
              user.avatarInitials,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),

          // Name and Streak
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: user.isCurrentUser ? const Color(0xFF065F46) : const Color(0xFF0F172A),
                      ),
                    ),
                    if (user.isCurrentUser) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'YOU',
                          style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  '${user.tier} • สตรีค ${user.streakDays} วัน 🔥',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),

          // Total EXP
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${user.exp}',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  color: Color(0xFF0F172A),
                ),
              ),
              const Text('EXP', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 3: BADGES VIEW
  // ---------------------------------------------------------------------------

  Widget _buildBadgesView() {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.85,
      ),
      itemCount: widget.badges.length,
      itemBuilder: (context, index) {
        final badge = widget.badges[index];
        return _buildBadgeCard(badge);
      },
    );
  }

  Widget _buildBadgeCard(HealthBadge badge) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: badge.isUnlocked ? Colors.white : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: badge.isUnlocked ? const Color(0xFFE2E8F0) : const Color(0xFFCBD5E1),
        ),
        boxShadow: badge.isUnlocked
            ? const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: badge.isUnlocked
                  ? badge.color.withValues(alpha: 0.15)
                  : const Color(0xFFE2E8F0),
              shape: BoxShape.circle,
            ),
            child: Icon(
              badge.icon,
              color: badge.isUnlocked ? badge.color : const Color(0xFF94A3B8),
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            badge.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: badge.isUnlocked ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            badge.desc,
            style: TextStyle(
              fontSize: 11,
              color: badge.isUnlocked ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: badge.isUnlocked ? const Color(0xFFDCFCE7) : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              badge.isUnlocked ? 'ปลดล็อกแล้ว' : '🔒 ล็อกอยู่',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: badge.isUnlocked ? const Color(0xFF15803D) : const Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
