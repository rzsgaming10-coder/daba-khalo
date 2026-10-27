import 'package:flutter/material.dart';

import '../../core/models/tournament_models.dart';
import 'registration_page.dart';

class TournamentDetailsPage extends StatelessWidget {
  final String tournamentName;

  const TournamentDetailsPage({
    super.key,
    this.tournamentName = 'DABA GOLD CUP',
  });

  @override
  Widget build(BuildContext context) {
    final payoutPlan = TournamentPrizePlan(
      name: tournamentName,
      entryFee: 500,
      playerCount: 128,
      stake: 20,
    );
    final results = buildDefaultTournamentResults();
    final roadmap = buildRoadMap(
      results: results,
      currentPlayerId: 'DABA-9000',
    );

    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Tournament Details',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tournament shared.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.share_outlined),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TournamentHero(tournamentName: tournamentName),

              const SizedBox(height: 18),

              const Text(
                'Tournament Overview',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              const Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.emoji_events_outlined,
                      title: 'Prize Pool',
                      value: '৳50,000',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.people_outline,
                      title: 'Players',
                      value: '128',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              const Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.payments_outlined,
                      title: 'Entry Fee',
                      value: '৳500',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.timer_outlined,
                      title: 'Time Control',
                      value: '10 + 0',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              const Text(
                'Tournament Information',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              _InformationPanel(
                children: [
                  const _InformationRow(
                    icon: Icons.calendar_today_outlined,
                    title: 'Start Date',
                    value: '25 October 2026',
                  ),
                  const _InformationRow(
                    icon: Icons.access_time,
                    title: 'Start Time',
                    value: '08:00 PM',
                  ),
                  const _InformationRow(
                    icon: Icons.account_tree_outlined,
                    title: 'Format',
                    value: 'Swiss System',
                  ),
                  const _InformationRow(
                    icon: Icons.repeat,
                    title: 'Rounds',
                    value: '7 Rounds',
                  ),
                  const _InformationRow(
                    icon: Icons.speed_outlined,
                    title: 'Time Control',
                    value: '10 Minutes',
                  ),
                  const _InformationRow(
                    icon: Icons.public,
                    title: 'Platform',
                    value: 'DABA KHALO',
                    isLast: true,
                  ),
                ],
              ),

              const SizedBox(height: 22),

              const Text(
                'Prize Distribution',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              ...payoutPlan.payoutBreakdown.map((payout) {
                return _PrizeRow(
                  position: payout.label,
                  amount: '৳${payout.amount}',
                  icon: payout.label == 'Admin'
                      ? Icons.account_balance_wallet_outlined
                      : payout.label == '1st'
                          ? Icons.emoji_events
                          : payout.label == '2nd'
                              ? Icons.workspace_premium_outlined
                              : payout.label == '3rd'
                                  ? Icons.military_tech_outlined
                                  : payout.label == '4th'
                                      ? Icons.star_outline
                                      : Icons.stars_outlined,
                );
              }).toList(),

              const SizedBox(height: 22),

              const Text(
                'Tournament Road Map',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              _RoadmapPanel(roadmap: roadmap),

              const SizedBox(height: 22),

              const Text(
                'Tournament Rules',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              const _RulesPanel(),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return RegistrationPage(
                            tournamentName: tournamentName,
                            entryFee: '৳500',
                            prizePool: '৳50,000',
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'REGISTER NOW',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.7,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Center(
                child: Text(
                  'Registration closes 15 minutes before the start',
                  style: TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TournamentHero extends StatelessWidget {
  final String tournamentName;

  const _TournamentHero({required this.tournamentName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2B2410), Color(0xFF151515), Color(0xFF0D0D0D)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFD4AF37).withValues(alpha: 0.12),
              border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
            ),
            child: const Icon(
              Icons.emoji_events,
              size: 38,
              color: Color(0xFFD4AF37),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            tournamentName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Official DABA KHALO Chess Tournament',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),

          const SizedBox(height: 15),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFF1D5E37),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 8, color: Color(0xFF65D98A)),
                SizedBox(width: 7),
                Text(
                  'REGISTRATION OPEN',
                  style: TextStyle(
                    color: Color(0xFF8BE9A8),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
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

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 21, color: const Color(0xFFD4AF37)),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(color: Colors.white54, fontSize: 10),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _InformationPanel extends StatelessWidget {
  final List<Widget> children;

  const _InformationPanel({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(children: children),
    );
  }
}

class _InformationRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isLast;

  const _InformationRow({
    required this.icon,
    required this.title,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFFD4AF37)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrizeRow extends StatelessWidget {
  final String position;
  final String amount;
  final IconData icon;

  const _PrizeRow({
    required this.position,
    required this.amount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFD4AF37), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              position,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              color: Color(0xFFD4AF37),
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoadmapPanel extends StatelessWidget {
  const _RoadmapPanel({required this.roadmap});

  final List<TournamentRoadmapPoint> roadmap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          for (var i = 0; i < roadmap.length; i++)
            Container(
              margin: EdgeInsets.only(bottom: i == roadmap.length - 1 ? 0 : 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: roadmap[i].isCurrentPlayer
                    ? const Color(0xFF1D2B1B)
                    : const Color(0xFF181818),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: roadmap[i].isCurrentPlayer
                      ? const Color(0xFF73E18B).withValues(alpha: 0.5)
                      : Colors.white10,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${roadmap[i].position}',
                      style: const TextStyle(
                        color: Color(0xFFD4AF37),
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          roadmap[i].title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          roadmap[i].subtitle,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    roadmap[i].isCurrentPlayer ? 'YOU' : roadmap[i].label,
                    style: TextStyle(
                      color: roadmap[i].isCurrentPlayer
                          ? const Color(0xFF7BE1AE)
                          : Colors.white60,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
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

class _RulesPanel extends StatelessWidget {
  const _RulesPanel();

  @override
  Widget build(BuildContext context) {
    const rules = [
      'Players must join before the registration deadline.',
      'All games follow standard chess rules.',
      'Players must be present when their round begins.',
      'Illegal moves will be handled by the game system.',
      'Disconnects and game results are recorded automatically.',
      'Tournament administrators may verify disputed results.',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          for (int i = 0; i < rules.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == rules.length - 1 ? 0 : 13),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Icon(
                      Icons.check_circle_outline,
                      size: 17,
                      color: Color(0xFFD4AF37),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      rules[i],
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        height: 1.4,
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
}
